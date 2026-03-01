import 'package:dartz/dartz.dart';

import '../../core/errors/error_handler.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/network/api_response.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/local/local_datasource.dart';

class SearchRepositoryImpl implements SearchRepository {
  SearchRepositoryImpl({required this.localDataSource});

  final LocalDataSource localDataSource;

  @override
  ApiResult<List<String>> getRecentSearches() async {
    try {
      final searches = await localDataSource.getRecentSearches();
      return Right(searches);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  ApiResult<void> saveRecentSearch(String query) async {
    try {
      await localDataSource.saveRecentSearch(query);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  ApiResult<void> clearRecentSearches() async {
    try {
      await localDataSource.clearRecentSearches();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }
}
