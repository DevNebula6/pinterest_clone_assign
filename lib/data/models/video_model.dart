import '../../domain/entities/video_pin.dart';

class VideoModel {
  VideoModel({
    required this.id,
    required this.width,
    required this.height,
    required this.url,
    required this.image,
    required this.duration,
    required this.user,
    required this.videoFiles,
    required this.videoPictures,
  });

  final int id;
  final int width;
  final int height;
  final String url;
  final String image; // thumbnail
  final int duration;
  final VideoUserModel user;
  final List<VideoFileModel> videoFiles;
  final List<VideoPictureModel> videoPictures;

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'] as int,
      width: json['width'] as int,
      height: json['height'] as int,
      url: json['url'] as String,
      image: json['image'] as String? ?? '',
      duration: json['duration'] as int? ?? 0,
      user: VideoUserModel.fromJson(json['user'] as Map<String, dynamic>),
      videoFiles: (json['video_files'] as List<dynamic>?)
              ?.map((e) => VideoFileModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      videoPictures: (json['video_pictures'] as List<dynamic>?)
              ?.map((e) => VideoPictureModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'width': width,
      'height': height,
      'url': url,
      'image': image,
      'duration': duration,
      'user': user.toJson(),
      'video_files': videoFiles.map((f) => f.toJson()).toList(),
      'video_pictures': videoPictures.map((p) => p.toJson()).toList(),
    };
  }

  VideoPin toEntity() {
    return VideoPin(
      id: id,
      width: width,
      height: height,
      url: url,
      thumbnailUrl: image,
      duration: duration,
      userName: user.name,
      userUrl: user.url,
      videoFiles: videoFiles.map((f) => f.toEntity()).toList(),
    );
  }
}

class VideoUserModel {
  VideoUserModel({
    required this.id,
    required this.name,
    required this.url,
  });

  final int id;
  final String name;
  final String url;

  factory VideoUserModel.fromJson(Map<String, dynamic> json) {
    return VideoUserModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      url: json['url'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'url': url};
}

class VideoFileModel {
  VideoFileModel({
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

  factory VideoFileModel.fromJson(Map<String, dynamic> json) {
    return VideoFileModel(
      id: json['id'] as int,
      quality: json['quality'] as String? ?? '',
      fileType: json['file_type'] as String? ?? '',
      width: json['width'] as int? ?? 0,
      height: json['height'] as int? ?? 0,
      link: json['link'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quality': quality,
      'file_type': fileType,
      'width': width,
      'height': height,
      'link': link,
    };
  }

  VideoFile toEntity() {
    return VideoFile(
      id: id,
      quality: quality,
      fileType: fileType,
      width: width,
      height: height,
      link: link,
    );
  }
}

class VideoPictureModel {
  VideoPictureModel({
    required this.id,
    required this.picture,
    required this.nr,
  });

  final int id;
  final String picture;
  final int nr;

  factory VideoPictureModel.fromJson(Map<String, dynamic> json) {
    return VideoPictureModel(
      id: json['id'] as int,
      picture: json['picture'] as String? ?? '',
      nr: json['nr'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'picture': picture, 'nr': nr};
}
