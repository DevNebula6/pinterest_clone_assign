import 'package:dartz/dartz.dart';

import '../../core/errors/error_handler.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/network/api_response.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/pin.dart';
import '../../domain/entities/search_result.dart';
import '../../domain/repositories/photo_repository.dart';
import '../datasources/local/local_datasource.dart';
import '../datasources/remote/pexels_remote_datasource.dart';

class PhotoRepositoryImpl implements PhotoRepository {
  PhotoRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  final PexelsRemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  @override
  ApiResult<SearchResult<Pin>> getCuratedPhotos({
    int page = 1,
    int perPage = 20,
  }) async {
    final isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      // try to return cached photos if available
      final cached = await localDataSource.getCachedPhotos('curated_$page');
      if (cached != null && cached.isNotEmpty) {
        return Right(SearchResult(
          items: cached.map((m) => m.toEntity()).toList(),
          totalResults: cached.length,
          currentPage: page,
          hasMore: false,
        ));
      }
      return const Left(NetworkFailure());
    }

    try {
      final result = await remoteDataSource.getCuratedPhotos(
        page: page,
        perPage: perPage,
      );
      // cache first page for offline use
      if (page == 1) {
        await localDataSource.cachePhotos(result.items, 'curated_1');
      }
      return Right(SearchResult(
        items: result.items.map((m) => m.toEntity()).toList(),
        totalResults: result.totalResults,
        currentPage: page,
        hasMore: result.hasMore,
        nextPageUrl: result.nextPage,
      ));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  ApiResult<Pin> getPhotoDetail(int id) async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) return const Left(NetworkFailure());

    try {
      final model = await remoteDataSource.getPhoto(id);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  ApiResult<SearchResult<Pin>> searchPhotos({
    required String query,
    int page = 1,
    int perPage = 20,
    String? orientation,
    String? size,
    String? color,
  }) async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) return const Left(NetworkFailure());

    try {
      final result = await remoteDataSource.searchPhotos(
        query: query,
        page: page,
        perPage: perPage,
        orientation: orientation,
        size: size,
        color: color,
      );
      return Right(SearchResult(
        items: result.items.map((m) => m.toEntity()).toList(),
        totalResults: result.totalResults,
        currentPage: page,
        hasMore: result.hasMore,
        nextPageUrl: result.nextPage,
      ));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }
}
