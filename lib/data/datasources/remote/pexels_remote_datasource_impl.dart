import 'package:dio/dio.dart';

import '../../../core/errors/exceptions.dart';
import '../../models/collection_model.dart';
import '../../models/pagination_model.dart';
import '../../models/photo_model.dart';
import '../../models/video_model.dart';
import 'endpoints.dart';
import 'pexels_remote_datasource.dart';

class PexelsRemoteDataSourceImpl implements PexelsRemoteDataSource {
  PexelsRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<PaginationModel<PhotoModel>> getCuratedPhotos({
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final response = await _dio.get(
        Endpoints.curatedPhotos,
        queryParameters: {'page': page, 'per_page': perPage},
      );
      return PaginationModel.fromJson(
        response.data as Map<String, dynamic>,
        PhotoModel.fromJson,
        'photos',
      );
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to fetch curated photos',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<PhotoModel> getPhoto(int id) async {
    try {
      final response = await _dio.get(Endpoints.photoDetail(id));
      return PhotoModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to fetch photo',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<PaginationModel<PhotoModel>> searchPhotos({
    required String query,
    int page = 1,
    int perPage = 20,
    String? orientation,
    String? size,
    String? color,
  }) async {
    try {
      final params = <String, dynamic>{
        'query': query,
        'page': page,
        'per_page': perPage,
        if (orientation != null) 'orientation': orientation,
        if (size != null) 'size': size,
        if (color != null) 'color': color,
      };
      final response = await _dio.get(
        Endpoints.searchPhotos,
        queryParameters: params,
      );
      return PaginationModel.fromJson(
        response.data as Map<String, dynamic>,
        PhotoModel.fromJson,
        'photos',
      );
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to search photos',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<PaginationModel<VideoModel>> getPopularVideos({
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final response = await _dio.get(
        Endpoints.popularVideos,
        queryParameters: {'page': page, 'per_page': perPage},
      );
      return PaginationModel.fromJson(
        response.data as Map<String, dynamic>,
        VideoModel.fromJson,
        'videos',
      );
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to fetch popular videos',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<VideoModel> getVideo(int id) async {
    try {
      final response = await _dio.get(Endpoints.videoDetail(id));
      return VideoModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to fetch video',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<PaginationModel<VideoModel>> searchVideos({
    required String query,
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final response = await _dio.get(
        Endpoints.searchVideos,
        queryParameters: {'query': query, 'page': page, 'per_page': perPage},
      );
      return PaginationModel.fromJson(
        response.data as Map<String, dynamic>,
        VideoModel.fromJson,
        'videos',
      );
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to search videos',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<PaginationModel<CollectionModel>> getFeaturedCollections({
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final response = await _dio.get(
        Endpoints.featuredCollections,
        queryParameters: {'page': page, 'per_page': perPage},
      );
      return PaginationModel.fromJson(
        response.data as Map<String, dynamic>,
        CollectionModel.fromJson,
        'collections',
      );
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to fetch collections',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<PaginationModel<PhotoModel>> getCollectionMedia(
    String collectionId, {
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final response = await _dio.get(
        Endpoints.collectionMedia(collectionId),
        queryParameters: {'page': page, 'per_page': perPage, 'type': 'photos'},
      );
      return PaginationModel.fromJson(
        response.data as Map<String, dynamic>,
        PhotoModel.fromJson,
        'media',
      );
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to fetch collection media',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
