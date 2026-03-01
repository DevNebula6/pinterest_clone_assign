import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifiers/pin_detail_notifier.dart';
import '../notifiers/pin_detail_state.dart';
import 'usecase_providers.dart';

// Family provider — one notifier per pin ID.
// Usage: ref.watch(pinDetailNotifierProvider(pinId))
final pinDetailNotifierProvider =
    StateNotifierProvider.family<PinDetailNotifier, PinDetailState, int>(
  (ref, pinId) {
    return PinDetailNotifier(
      getPhotoDetail: ref.watch(getPhotoDetailProvider),
      searchPhotos: ref.watch(searchPhotosProvider),
      savePinToBoard: ref.watch(savePinToBoardProvider),
      removePinFromBoard: ref.watch(removePinFromBoardProvider),
      getBoards: ref.watch(getBoardsProvider),
    );
  },
);
