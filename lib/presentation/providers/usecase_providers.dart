import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/get_curated_photos.dart';
import '../../domain/usecases/get_photo_detail.dart';
import '../../domain/usecases/search_photos.dart';
import '../../domain/usecases/get_popular_videos.dart';
import '../../domain/usecases/search_videos.dart';
import '../../domain/usecases/get_collections.dart';
import '../../domain/usecases/get_collection_media.dart';
import '../../domain/usecases/get_boards.dart';
import '../../domain/usecases/create_board.dart';
import '../../domain/usecases/delete_board.dart';
import '../../domain/usecases/save_pin_to_board.dart';
import '../../domain/usecases/remove_pin_from_board.dart';
import '../../domain/usecases/get_saved_pin_ids.dart';
import '../../domain/usecases/get_saved_pins.dart';
import '../../domain/usecases/get_recent_searches.dart';
import '../../domain/usecases/save_recent_search.dart';
import '../../domain/usecases/clear_recent_searches.dart';
import '../../domain/usecases/get_profile.dart';
import '../../domain/usecases/save_user.dart';
import '../../domain/usecases/clear_user.dart';
import 'repository_providers.dart';

// Photo use cases
final getCuratedPhotosProvider = Provider<GetCuratedPhotos>((ref) {
  return GetCuratedPhotos(ref.watch(photoRepositoryProvider));
});

final getPhotoDetailProvider = Provider<GetPhotoDetail>((ref) {
  return GetPhotoDetail(ref.watch(photoRepositoryProvider));
});

final searchPhotosProvider = Provider<SearchPhotos>((ref) {
  return SearchPhotos(ref.watch(photoRepositoryProvider));
});

// Video use cases
final getPopularVideosProvider = Provider<GetPopularVideos>((ref) {
  return GetPopularVideos(ref.watch(videoRepositoryProvider));
});

final searchVideosProvider = Provider<SearchVideos>((ref) {
  return SearchVideos(ref.watch(videoRepositoryProvider));
});

// Collection use cases
final getCollectionsProvider = Provider<GetCollections>((ref) {
  return GetCollections(ref.watch(collectionRepositoryProvider));
});

final getCollectionMediaProvider = Provider<GetCollectionMedia>((ref) {
  return GetCollectionMedia(ref.watch(collectionRepositoryProvider));
});

// Board use cases
final getBoardsProvider = Provider<GetBoards>((ref) {
  return GetBoards(ref.watch(boardRepositoryProvider));
});

final createBoardProvider = Provider<CreateBoard>((ref) {
  return CreateBoard(ref.watch(boardRepositoryProvider));
});

final deleteBoardProvider = Provider<DeleteBoard>((ref) {
  return DeleteBoard(ref.watch(boardRepositoryProvider));
});

final savePinToBoardProvider = Provider<SavePinToBoard>((ref) {
  return SavePinToBoard(ref.watch(boardRepositoryProvider));
});

final removePinFromBoardProvider = Provider<RemovePinFromBoard>((ref) {
  return RemovePinFromBoard(ref.watch(boardRepositoryProvider));
});

final getSavedPinIdsProvider = Provider<GetSavedPinIds>((ref) {
  return GetSavedPinIds(ref.watch(boardRepositoryProvider));
});

final getSavedPinsProvider = Provider<GetSavedPins>((ref) {
  return GetSavedPins(ref.watch(boardRepositoryProvider));
});

// Search use cases
final getRecentSearchesProvider = Provider<GetRecentSearches>((ref) {
  return GetRecentSearches(ref.watch(searchRepositoryProvider));
});

final saveRecentSearchProvider = Provider<SaveRecentSearch>((ref) {
  return SaveRecentSearch(ref.watch(searchRepositoryProvider));
});

final clearRecentSearchesProvider = Provider<ClearRecentSearches>((ref) {
  return ClearRecentSearches(ref.watch(searchRepositoryProvider));
});

// User use cases
final getProfileProvider = Provider<GetProfile>((ref) {
  return GetProfile(ref.watch(userRepositoryProvider));
});

final saveUserProvider = Provider<SaveUser>((ref) {
  return SaveUser(ref.watch(userRepositoryProvider));
});

final clearUserProvider = Provider<ClearUser>((ref) {
  return ClearUser(ref.watch(userRepositoryProvider));
});
