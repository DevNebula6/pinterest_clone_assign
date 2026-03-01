import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/photo_repository_impl.dart';
import '../../data/repositories/video_repository_impl.dart';
import '../../data/repositories/search_repository_impl.dart';
import '../../data/repositories/board_repository_impl.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../data/repositories/collection_repository_impl.dart';
import '../../domain/repositories/photo_repository.dart';
import '../../domain/repositories/video_repository.dart';
import '../../domain/repositories/search_repository.dart';
import '../../domain/repositories/board_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/repositories/collection_repository.dart';
import 'core_providers.dart';
import 'datasource_providers.dart';

final photoRepositoryProvider = Provider<PhotoRepository>((ref) {
  return PhotoRepositoryImpl(
    remoteDataSource: ref.watch(pexelsRemoteDataSourceProvider),
    localDataSource: ref.watch(localDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
});

final videoRepositoryProvider = Provider<VideoRepository>((ref) {
  return VideoRepositoryImpl(
    remoteDataSource: ref.watch(pexelsRemoteDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
});

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  return SearchRepositoryImpl(
    localDataSource: ref.watch(localDataSourceProvider),
  );
});

final boardRepositoryProvider = Provider<BoardRepository>((ref) {
  return BoardRepositoryImpl(
    localDataSource: ref.watch(localDataSourceProvider),
  );
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImpl(
    localDataSource: ref.watch(localDataSourceProvider),
  );
});

final collectionRepositoryProvider = Provider<CollectionRepository>((ref) {
  return CollectionRepositoryImpl(
    remoteDataSource: ref.watch(pexelsRemoteDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
});
