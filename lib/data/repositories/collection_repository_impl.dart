import 'package:dartz/dartz.dart';

import '../../core/errors/error_handler.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/network/api_response.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/collection.dart';
import '../../domain/entities/pin.dart';
import '../../domain/entities/search_result.dart';
import '../../domain/repositories/collection_repository.dart';
import '../datasources/remote/pexels_remote_datasource.dart';

class CollectionRepositoryImpl implements CollectionRepository {
  CollectionRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  final PexelsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  @override
  ApiResult<SearchResult<Collection>> getFeaturedCollections({
    int page = 1,
    int perPage = 20,
  }) async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) return const Left(NetworkFailure());

    try {
      final result = await remoteDataSource.getFeaturedCollections(
        page: page,
        perPage: perPage,
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

  @override
  ApiResult<SearchResult<Pin>> getCollectionMedia(
    String collectionId, {
    int page = 1,
    int perPage = 20,
  }) async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) return const Left(NetworkFailure());

    try {
      // Pexels collection media is fetched as photos only (type=photos)
      final response = await remoteDataSource.getCollectionMedia(
        collectionId,
        page: page,
        perPage: perPage,
      );
      return Right(SearchResult(
        items: response.items.map((m) => m.toEntity()).toList(),
        totalResults: response.totalResults,
        currentPage: page,
        hasMore: response.hasMore,
        nextPageUrl: response.nextPage,
      ));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }
}
