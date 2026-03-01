import '../../models/board_model.dart';
import '../../models/photo_model.dart';

// Abstract contract for all local storage operations
abstract class LocalDataSource {
  Future<void> saveBoard(BoardModel board);
  Future<void> deleteBoard(String boardId);
  Future<List<BoardModel>> getBoards();
  Future<BoardModel?> getBoard(String boardId);
  Future<void> savePinToBoard(String boardId, int pinId);
  Future<void> removePinFromBoard(String boardId, int pinId);
  Future<List<int>> getSavedPinIds();
  Future<bool> isPinSaved(int pinId);
  Future<void> saveSavedPinData(PhotoModel pin);
  Future<void> removeSavedPinData(int pinId);
  Future<List<PhotoModel>> getSavedPinsData();
  Future<void> cachePhotos(List<PhotoModel> photos, String cacheKey);
  Future<List<PhotoModel>?> getCachedPhotos(String cacheKey);
  Future<void> saveRecentSearch(String query);
  Future<List<String>> getRecentSearches();
  Future<void> clearRecentSearches();
  Future<void> saveUserJson(Map<String, dynamic> userJson);
  Future<Map<String, dynamic>?> getUserJson();
  Future<void> clearUser();
}
