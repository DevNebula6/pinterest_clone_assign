import 'package:equatable/equatable.dart';

class Board extends Equatable {
  const Board({
    required this.id,
    required this.name,
    this.description,
    required this.pinIds,
    this.coverImageUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.isPrivate,
  });

  final String id;
  final String name;
  final String? description;
  final List<int> pinIds;
  final String? coverImageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isPrivate;

  int get pinCount => pinIds.length;
  bool containsPin(int pinId) => pinIds.contains(pinId);

  @override
  List<Object?> get props => [id];
}
