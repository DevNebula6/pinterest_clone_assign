import 'package:equatable/equatable.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/pin.dart';

class PinDetailState extends Equatable {
  const PinDetailState({
    this.pin,
    this.isLoading = false,
    this.error,
    this.isSaved = false,
    this.savedToBoardId,
    this.relatedPins = const [],
    this.isLoadingRelated = false,
    this.hasMoreRelated = true,
    this.relatedPage = 1,
  });

  final Pin? pin;
  final bool isLoading;
  final Failure? error;
  final bool isSaved;
  final String? savedToBoardId;
  final List<Pin> relatedPins;
  final bool isLoadingRelated;
  final bool hasMoreRelated;
  final int relatedPage;

  PinDetailState copyWith({
    Pin? pin,
    bool? isLoading,
    Failure? error,
    bool clearError = false,
    bool? isSaved,
    String? savedToBoardId,
    bool clearSavedToBoard = false,
    List<Pin>? relatedPins,
    bool? isLoadingRelated,
    bool? hasMoreRelated,
    int? relatedPage,
  }) {
    return PinDetailState(
      pin: pin ?? this.pin,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
      isSaved: isSaved ?? this.isSaved,
      savedToBoardId: clearSavedToBoard ? null : savedToBoardId ?? this.savedToBoardId,
      relatedPins: relatedPins ?? this.relatedPins,
      isLoadingRelated: isLoadingRelated ?? this.isLoadingRelated,
      hasMoreRelated: hasMoreRelated ?? this.hasMoreRelated,
      relatedPage: relatedPage ?? this.relatedPage,
    );
  }

  @override
  List<Object?> get props => [
        pin,
        isLoading,
        error,
        isSaved,
        savedToBoardId,
        relatedPins,
        isLoadingRelated,
        hasMoreRelated,
        relatedPage,
      ];
}
