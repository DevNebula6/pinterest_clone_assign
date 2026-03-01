import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';

import '../../core/errors/error_handler.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/network/api_response.dart';
import '../../domain/entities/board.dart';
import '../../domain/entities/pin.dart';
import '../../domain/repositories/board_repository.dart';
import '../datasources/local/local_datasource.dart';
import '../models/board_model.dart';
import '../models/photo_model.dart';

class BoardRepositoryImpl implements BoardRepository {
  BoardRepositoryImpl({required this.localDataSource});

  final LocalDataSource localDataSource;
  final _uuid = const Uuid();

  @override
  ApiResult<List<Board>> getBoards() async {
    try {
      final models = await localDataSource.getBoards();
      return Right(models.map((m) => m.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  ApiResult<Board> getBoard(String id) async {
    try {
      final model = await localDataSource.getBoard(id);
      if (model == null) {
        return const Left(ServerFailure(message: 'Board not found'));
      }
      return Right(model.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  ApiResult<Board> createBoard(
    String name, {
    String? description,
    bool isPrivate = false,
  }) async {
    try {
      final now = DateTime.now();
      final board = BoardModel(
        id: _uuid.v4(),
        name: name,
        description: description,
        pinIds: [],
        createdAt: now,
        updatedAt: now,
        isPrivate: isPrivate,
      );
      await localDataSource.saveBoard(board);
      return Right(board.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  ApiResult<void> deleteBoard(String id) async {
    try {
      await localDataSource.deleteBoard(id);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  ApiResult<void> updateBoard(Board board) async {
    try {
      final model = BoardModel(
        id: board.id,
        name: board.name,
        description: board.description,
        pinIds: board.pinIds,
        coverImageUrl: board.coverImageUrl,
        createdAt: board.createdAt,
        updatedAt: DateTime.now(),
        isPrivate: board.isPrivate,
      );
      await localDataSource.saveBoard(model);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  ApiResult<void> savePinToBoard(String boardId, Pin pin) async {
    try {
      await localDataSource.savePinToBoard(boardId, pin.id);
      // Also persist the full pin data so it can be displayed later
      await localDataSource.saveSavedPinData(PhotoModel.fromEntity(pin));
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  ApiResult<void> removePinFromBoard(String boardId, int pinId) async {
    try {
      await localDataSource.removePinFromBoard(boardId, pinId);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  ApiResult<bool> isPinSaved(int pinId) async {
    try {
      final saved = await localDataSource.isPinSaved(pinId);
      return Right(saved);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  ApiResult<List<int>> getAllSavedPinIds() async {
    try {
      final ids = await localDataSource.getSavedPinIds();
      return Right(ids);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  ApiResult<List<Pin>> getSavedPins() async {
    try {
      final models = await localDataSource.getSavedPinsData();
      return Right(models.map((m) => m.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }
}
