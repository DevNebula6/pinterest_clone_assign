import 'package:equatable/equatable.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/pin.dart';

enum HomeFeedTab { all, forYou, today }

class HomeFeedState extends Equatable {
  const HomeFeedState({
    this.pins = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.activeTab = HomeFeedTab.all,
    this.currentPage = 1,
    this.hasReachedEnd = false,
    this.savedPinIds = const [],
  });

  final List<Pin> pins;
  final bool isLoading;
  final bool isLoadingMore;
  final Failure? error;
  final HomeFeedTab activeTab;
  final int currentPage;
  final bool hasReachedEnd;
  final List<int> savedPinIds;

  bool isPinSaved(int pinId) => savedPinIds.contains(pinId);

  HomeFeedState copyWith({
    List<Pin>? pins,
    bool? isLoading,
    bool? isLoadingMore,
    Failure? error,
    bool clearError = false,
    HomeFeedTab? activeTab,
    int? currentPage,
    bool? hasReachedEnd,
    List<int>? savedPinIds,
  }) {
    return HomeFeedState(
      pins: pins ?? this.pins,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: clearError ? null : error ?? this.error,
      activeTab: activeTab ?? this.activeTab,
      currentPage: currentPage ?? this.currentPage,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      savedPinIds: savedPinIds ?? this.savedPinIds,
    );
  }

  @override
  List<Object?> get props => [
        pins,
        isLoading,
        isLoadingMore,
        error,
        activeTab,
        currentPage,
        hasReachedEnd,
        savedPinIds,
      ];
}
