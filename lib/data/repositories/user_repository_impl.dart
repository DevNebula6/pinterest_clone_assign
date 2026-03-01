import 'package:dartz/dartz.dart';

import '../../core/errors/error_handler.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/network/api_response.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/local/local_datasource.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl({required this.localDataSource});

  final LocalDataSource localDataSource;

  @override
  ApiResult<User?> getCurrentUser() async {
    try {
      final json = await localDataSource.getUserJson();
      if (json == null) return const Right(null);
      return Right(UserModel.fromJson(json).toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  ApiResult<void> saveUser(User user) async {
    try {
      final model = UserModel(
        id: user.id,
        name: user.name,
        username: user.username,
        email: user.email,
        avatarUrl: user.avatarUrl,
        followersCount: user.followersCount,
        followingCount: user.followingCount,
        boardIds: user.boardIds,
      );
      await localDataSource.saveUserJson(model.toJson());
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  ApiResult<void> clearUser() async {
    try {
      await localDataSource.clearUser();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }
}
