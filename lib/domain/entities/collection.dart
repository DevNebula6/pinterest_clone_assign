import 'package:equatable/equatable.dart';

class Collection extends Equatable {
  const Collection({
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

  @override
  List<Object?> get props => [id];
}
