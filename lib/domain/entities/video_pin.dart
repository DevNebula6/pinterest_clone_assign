import 'package:equatable/equatable.dart';

class VideoPin extends Equatable {
  const VideoPin({
    required this.id,
    required this.width,
    required this.height,
    required this.url,
    required this.thumbnailUrl,
    required this.duration,
    required this.userName,
    required this.userUrl,
    required this.videoFiles,
  });

  final int id;
  final int width;
  final int height;
  final String url;
  final String thumbnailUrl;
  final int duration;
  final String userName;
  final String userUrl;
  final List<VideoFile> videoFiles;

  double get aspectRatio => height == 0 ? 1.0 : width / height;

  VideoFile? get hdFile {
    try {
      return videoFiles.firstWhere((f) => f.quality == 'hd');
    } catch (_) {
      return videoFiles.isNotEmpty ? videoFiles.first : null;
    }
  }

  VideoFile? get sdFile {
    try {
      return videoFiles.firstWhere((f) => f.quality == 'sd');
    } catch (_) {
      return null;
    }
  }

  @override
  List<Object?> get props => [id];
}

class VideoFile extends Equatable {
  const VideoFile({
    required this.id,
    required this.quality,
    required this.fileType,
    required this.width,
    required this.height,
    required this.link,
  });

  final int id;
  final String quality;
  final String fileType;
  final int width;
  final int height;
  final String link;

  @override
  List<Object?> get props => [id];
}
