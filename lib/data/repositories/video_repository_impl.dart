import 'package:dartz/dartz.dart';

import '../../core/errors/error_handler.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/network/api_response.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/search_result.dart';
import '../../domain/entities/video_pin.dart';
import '../../domain/repositories/video_repository.dart';
import '../datasources/remote/pexels_remote_datasource.dart';

class VideoRepositoryImpl implements VideoRepository {
  VideoRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  final PexelsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  @override
  ApiResult<SearchResult<VideoPin>> getPopularVideos({
    int page = 1,
    int perPage = 20,
  }) async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) return const Left(NetworkFailure());

    try {
      final result = await remoteDataSource.getPopularVideos(
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
  ApiResult<VideoPin> getVideoDetail(int id) async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) return const Left(NetworkFailure());

    try {
      final model = await remoteDataSource.getVideo(id);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  ApiResult<SearchResult<VideoPin>> searchVideos({
    required String query,
    int page = 1,
    int perPage = 20,
  }) async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) return const Left(NetworkFailure());

    try {
      final result = await remoteDataSource.searchVideos(
        query: query,
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
}
