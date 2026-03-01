import '../../domain/entities/collection.dart';

class CollectionModel {
  CollectionModel({
    required this.id,
    required this.title,
    this.description,
    required this.isPrivate,
    required this.mediaCount,
    required this.photosCount,
    required this.videosCount,
  });

  final String id;
  final String title;
  final String? description;
  final bool isPrivate;
  final int mediaCount;
  final int photosCount;
  final int videosCount;

  factory CollectionModel.fromJson(Map<String, dynamic> json) {
    return CollectionModel(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      isPrivate: json['private'] as bool? ?? false,
      mediaCount: json['media_count'] as int? ?? 0,
      photosCount: json['photos_count'] as int? ?? 0,
      videosCount: json['videos_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'private': isPrivate,
      'media_count': mediaCount,
      'photos_count': photosCount,
      'videos_count': videosCount,
    };
  }

  Collection toEntity() {
    return Collection(
      id: id,
      title: title,
      description: description,
      isPrivate: isPrivate,
      mediaCount: mediaCount,
      photosCount: photosCount,
      videosCount: videosCount,
    );
  }
}
