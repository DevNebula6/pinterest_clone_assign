import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/local/local_datasource.dart';
import '../../data/datasources/local/local_datasource_impl.dart';
import '../../data/datasources/remote/pexels_remote_datasource.dart';
import '../../data/datasources/remote/pexels_remote_datasource_impl.dart';
import 'core_providers.dart';

final pexelsRemoteDataSourceProvider = Provider<PexelsRemoteDataSource>((ref) {
  final dio = ref.watch(dioClientProvider);
  return PexelsRemoteDataSourceImpl(dio);
});

final localDataSourceProvider = Provider<LocalDataSource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LocalDataSourceImpl(prefs);
});
