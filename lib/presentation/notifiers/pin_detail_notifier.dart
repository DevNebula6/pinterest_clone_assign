import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/pin.dart';
import '../../domain/usecases/get_photo_detail.dart';
import '../../domain/usecases/search_photos.dart';
import '../../domain/usecases/save_pin_to_board.dart';
import '../../domain/usecases/remove_pin_from_board.dart';
import '../../domain/usecases/get_boards.dart';
import 'pin_detail_state.dart';

class PinDetailNotifier extends StateNotifier<PinDetailState> {
  PinDetailNotifier({
    required this.getPhotoDetail,
    required this.searchPhotos,
    required this.savePinToBoard,
    required this.removePinFromBoard,
    required this.getBoards,
  }) : super(const PinDetailState());

  final GetPhotoDetail getPhotoDetail;
  final SearchPhotos searchPhotos;
  final SavePinToBoard savePinToBoard;
  final RemovePinFromBoard removePinFromBoard;
  final GetBoards getBoards;

  static const int _relatedPerPage = 20;

  Future<void> loadPinDetail(int pinId, {Pin? initialPin}) async {
    if (initialPin != null) {
      state = state.copyWith(pin: initialPin, isLoading: true, clearError: true);
    } else {
      state = state.copyWith(isLoading: true, clearError: true);
    }

    final result = await getPhotoDetail(pinId);

    if (!mounted) return;

    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure);
      },
      (pin) {
        state = state.copyWith(pin: pin, isLoading: false, clearError: true);
        _checkIfSaved(pin);
        _loadRelatedPins(pin.alt.isNotEmpty ? pin.alt : pin.photographer);
      },
    );
  }

  Future<void> _checkIfSaved(Pin pin) async {
    final boardsResult = await getBoards();
    boardsResult.fold(
      (failure) => null,
      (boards) {
        for (final board in boards) {
          if (board.containsPin(pin.id)) {
            state = state.copyWith(isSaved: true, savedToBoardId: board.id);
            return;
          }
        }
        state = state.copyWith(isSaved: false);
      },
    );
  }

  Future<void> _loadRelatedPins(String query) async {
    if (!mounted) return;
    state = state.copyWith(isLoadingRelated: true);

    final result = await searchPhotos(
      query: query,
      page: 1,
      perPage: _relatedPerPage,
    );

    if (!mounted) return;

    result.fold(
      (failure) {
        state = state.copyWith(isLoadingRelated: false);
      },
      (searchResult) {
        final currentPinId = state.pin?.id;
        final related = searchResult.items
            .where((p) => p.id != currentPinId)
            .toList();
        state = state.copyWith(
          relatedPins: related,
          isLoadingRelated: false,
          hasMoreRelated: searchResult.hasMore,
          relatedPage: 1,
        );
      },
    );
  }

  Future<void> loadMoreRelatedPins() async {
    if (state.isLoadingRelated || !state.hasMoreRelated || state.pin == null) return;

    state = state.copyWith(isLoadingRelated: true);
    final nextPage = state.relatedPage + 1;
    final query = state.pin!.alt.isNotEmpty ? state.pin!.alt : state.pin!.photographer;

    final result = await searchPhotos(
      query: query,
      page: nextPage,
      perPage: _relatedPerPage,
    );

    if (!mounted) return;

    result.fold(
      (failure) {
        state = state.copyWith(isLoadingRelated: false);
      },
      (searchResult) {
        state = state.copyWith(
          relatedPins: [...state.relatedPins, ...searchResult.items],
          isLoadingRelated: false,
          hasMoreRelated: searchResult.hasMore,
          relatedPage: nextPage,
        );
      },
    );
  }

  Future<bool> savePin(String boardId) async {
    if (state.pin == null) return false;

    final result = await savePinToBoard(boardId, state.pin!);
    return result.fold(
      (failure) => false,
      (_) {
        state = state.copyWith(isSaved: true, savedToBoardId: boardId);
        return true;
      },
    );
  }

  Future<bool> unsavePin() async {
    if (state.pin == null || state.savedToBoardId == null) return false;

    final result = await removePinFromBoard(state.savedToBoardId!, state.pin!.id);
    return result.fold(
      (failure) => false,
      (_) {
        state = state.copyWith(isSaved: false, clearSavedToBoard: true);
        return true;
      },
    );
  }

  String? getPinUrl() {
    return state.pin?.url;
  }
}
