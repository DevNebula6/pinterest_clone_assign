import 'package:equatable/equatable.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/board.dart';
import '../../domain/entities/pin.dart';
import '../../domain/entities/user.dart';

enum ProfileTab { pins, boards, collages }

class ProfileState extends Equatable {
  const ProfileState({
    this.user,
    this.boards = const [],
    this.createdPins = const [],
    this.savedPins = const [],
    this.isLoading = false,
    this.activeTab = ProfileTab.pins,
    this.error,
  });

  final User? user;
  final List<Board> boards;
  final List<Pin> createdPins;
  final List<Pin> savedPins;
  final bool isLoading;
  final ProfileTab activeTab;
  final Failure? error;

  ProfileState copyWith({
    User? user,
    List<Board>? boards,
    List<Pin>? createdPins,
    List<Pin>? savedPins,
    bool? isLoading,
    ProfileTab? activeTab,
    Failure? error,
    bool clearError = false,
  }) {
    return ProfileState(
      user: user ?? this.user,
      boards: boards ?? this.boards,
      createdPins: createdPins ?? this.createdPins,
      savedPins: savedPins ?? this.savedPins,
      isLoading: isLoading ?? this.isLoading,
      activeTab: activeTab ?? this.activeTab,
      error: clearError ? null : error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        user,
        boards,
        createdPins,
        savedPins,
        isLoading,
        activeTab,
        error,
      ];
}
