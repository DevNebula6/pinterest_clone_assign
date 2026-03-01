import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/errors/exceptions.dart';
import '../../models/board_model.dart';
import '../../models/photo_model.dart';
import 'local_datasource.dart';

// SharedPreferences keys
const _keyBoards = 'boards';
const _keySavedPins = 'saved_pins';
const _keySavedPinsData = 'saved_pins_data';
const _keyRecentSearches = 'recent_searches';
const _keyUserProfile = 'user_profile';
const _maxRecentSearches = 10;

class LocalDataSourceImpl implements LocalDataSource {
  LocalDataSourceImpl(this._prefs);

  final SharedPreferences _prefs;

  @override
  Future<void> saveBoard(BoardModel board) async {
    try {
      final boards = await getBoards();
      final index = boards.indexWhere((b) => b.id == board.id);
      if (index >= 0) {
        boards[index] = board;
      } else {
        boards.add(board);
      }
      final jsonList = boards.map((b) => jsonEncode(b.toJson())).toList();
      await _prefs.setStringList(_keyBoards, jsonList);
    } catch (e) {
      throw const CacheException(message: 'Failed to save board');
    }
  }

  @override
  Future<void> deleteBoard(String boardId) async {
    try {
      final boards = await getBoards();
      boards.removeWhere((b) => b.id == boardId);
      final jsonList = boards.map((b) => jsonEncode(b.toJson())).toList();
      await _prefs.setStringList(_keyBoards, jsonList);
    } catch (e) {
      throw const CacheException(message: 'Failed to delete board');
    }
  }

  @override
  Future<List<BoardModel>> getBoards() async {
    try {
      final jsonList = _prefs.getStringList(_keyBoards) ?? [];
      return jsonList
          .map((s) => BoardModel.fromJson(jsonDecode(s) as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw const CacheException(message: 'Failed to get boards');
    }
  }

  @override
  Future<BoardModel?> getBoard(String boardId) async {
    final boards = await getBoards();
    try {
      return boards.firstWhere((b) => b.id == boardId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> savePinToBoard(String boardId, int pinId) async {
    final board = await getBoard(boardId);
    if (board == null) throw const CacheException(message: 'Board not found');
    if (!board.pinIds.contains(pinId)) {
      final updated = board.copyWith(pinIds: [...board.pinIds, pinId]);
      await saveBoard(updated);
    }
    // also add to global saved pins list
    await _addToSavedPins(pinId);
  }

  @override
  Future<void> removePinFromBoard(String boardId, int pinId) async {
    final board = await getBoard(boardId);
    if (board == null) throw const CacheException(message: 'Board not found');
    final updated = board.copyWith(
      pinIds: board.pinIds.where((id) => id != pinId).toList(),
    );
    await saveBoard(updated);
  }

  @override
  Future<List<int>> getSavedPinIds() async {
    try {
      final jsonList = _prefs.getStringList(_keySavedPins) ?? [];
      return jsonList.map((s) => int.parse(s)).toList();
    } catch (e) {
      throw const CacheException(message: 'Failed to get saved pins');
    }
  }

  @override
  Future<bool> isPinSaved(int pinId) async {
    final saved = await getSavedPinIds();
    return saved.contains(pinId);
  }

  @override
  Future<void> saveSavedPinData(PhotoModel pin) async {
    try {
      final existing = await getSavedPinsData();
      // Avoid duplicates
      existing.removeWhere((p) => p.id == pin.id);
      existing.add(pin);
      final jsonList = existing.map((p) => jsonEncode(p.toJson())).toList();
      await _prefs.setStringList(_keySavedPinsData, jsonList);
    } catch (e) {
      throw const CacheException(message: 'Failed to save pin data');
    }
  }

  @override
  Future<void> removeSavedPinData(int pinId) async {
    try {
      final existing = await getSavedPinsData();
      existing.removeWhere((p) => p.id == pinId);
      final jsonList = existing.map((p) => jsonEncode(p.toJson())).toList();
      await _prefs.setStringList(_keySavedPinsData, jsonList);
    } catch (e) {
      throw const CacheException(message: 'Failed to remove pin data');
    }
  }

  @override
  Future<List<PhotoModel>> getSavedPinsData() async {
    try {
      final jsonList = _prefs.getStringList(_keySavedPinsData) ?? [];
      return jsonList
          .map((s) => PhotoModel.fromJson(jsonDecode(s) as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw const CacheException(message: 'Failed to get saved pins data');
    }
  }

  @override
  Future<void> cachePhotos(List<PhotoModel> photos, String cacheKey) async {
    try {
      final jsonList = photos.map((p) => jsonEncode(p.toJson())).toList();
      await _prefs.setStringList('cache_$cacheKey', jsonList);
    } catch (e) {
      // cache failures are non-critical, just log and move on
      print('[Cache] Failed to cache photos: $e');
    }
  }

  @override
  Future<List<PhotoModel>?> getCachedPhotos(String cacheKey) async {
    try {
      final jsonList = _prefs.getStringList('cache_$cacheKey');
      if (jsonList == null) return null;
      return jsonList
          .map((s) => PhotoModel.fromJson(jsonDecode(s) as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveRecentSearch(String query) async {
    try {
      final searches = await getRecentSearches();
      searches.remove(query); // remove duplicate if exists
      searches.insert(0, query);
      if (searches.length > _maxRecentSearches) {
        searches.removeLast();
      }
      await _prefs.setStringList(_keyRecentSearches, searches);
    } catch (e) {
      throw const CacheException(message: 'Failed to save recent search');
    }
  }

  @override
  Future<List<String>> getRecentSearches() async {
    return _prefs.getStringList(_keyRecentSearches) ?? [];
  }

  @override
  Future<void> clearRecentSearches() async {
    await _prefs.remove(_keyRecentSearches);
  }

  @override
  Future<void> saveUserJson(Map<String, dynamic> userJson) async {
    await _prefs.setString(_keyUserProfile, jsonEncode(userJson));
  }

  @override
  Future<Map<String, dynamic>?> getUserJson() async {
    final raw = _prefs.getString(_keyUserProfile);
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  @override
  Future<void> clearUser() async {
    await _prefs.remove(_keyUserProfile);
  }

  // helper to keep global saved pins list in sync
  Future<void> _addToSavedPins(int pinId) async {
    final saved = await getSavedPinIds();
    if (!saved.contains(pinId)) {
      saved.add(pinId);
      await _prefs.setStringList(
        _keySavedPins,
        saved.map((id) => id.toString()).toList(),
      );
    }
  }
}
