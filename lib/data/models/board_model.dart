import '../../domain/entities/board.dart';

// Local board model — stored in SharedPreferences as JSON
class BoardModel {
  BoardModel({
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

  factory BoardModel.fromJson(Map<String, dynamic> json) {
    return BoardModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      pinIds: (json['pinIds'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
      coverImageUrl: json['coverImageUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isPrivate: json['isPrivate'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'pinIds': pinIds,
      'coverImageUrl': coverImageUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isPrivate': isPrivate,
    };
  }

  Board toEntity() {
    return Board(
      id: id,
      name: name,
      description: description,
      pinIds: pinIds,
      coverImageUrl: coverImageUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isPrivate: isPrivate,
    );
  }

  // Create a copy with updated fields
  BoardModel copyWith({
    String? name,
    String? description,
    List<int>? pinIds,
    String? coverImageUrl,
    DateTime? updatedAt,
    bool? isPrivate,
  }) {
    return BoardModel(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      pinIds: pinIds ?? this.pinIds,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isPrivate: isPrivate ?? this.isPrivate,
    );
  }
}
