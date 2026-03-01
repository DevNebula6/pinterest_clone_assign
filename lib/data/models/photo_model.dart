import '../../domain/entities/pin.dart';

// Maps the Pexels photo JSON to a Dart object
class PhotoModel {
  PhotoModel({
    required this.id,
    required this.width,
    required this.height,
    required this.url,
    required this.photographer,
    required this.photographerUrl,
    required this.photographerId,
    required this.avgColor,
    required this.src,
    required this.liked,
    required this.alt,
  });

  final int id;
  final int width;
  final int height;
  final String url;
  final String photographer;
  final String photographerUrl;
  final int photographerId;
  final String avgColor;
  final PhotoSrcModel src;
  final bool liked;
  final String alt;

  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    return PhotoModel(
      id: json['id'] as int,
      width: json['width'] as int,
      height: json['height'] as int,
      url: json['url'] as String,
      photographer: json['photographer'] as String,
      photographerUrl: json['photographer_url'] as String,
      photographerId: json['photographer_id'] as int,
      avgColor: json['avg_color'] as String? ?? '#CCCCCC',
      src: PhotoSrcModel.fromJson(json['src'] as Map<String, dynamic>),
      liked: json['liked'] as bool? ?? false,
      alt: json['alt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'width': width,
      'height': height,
      'url': url,
      'photographer': photographer,
      'photographer_url': photographerUrl,
      'photographer_id': photographerId,
      'avg_color': avgColor,
      'src': src.toJson(),
      'liked': liked,
      'alt': alt,
    };
  }

  // convert from domain entity back to model (for caching)
  factory PhotoModel.fromEntity(Pin pin) {
    return PhotoModel(
      id: pin.id,
      width: pin.width,
      height: pin.height,
      url: pin.url,
      photographer: pin.photographer,
      photographerUrl: pin.photographerUrl,
      photographerId: pin.photographerId,
      avgColor: pin.avgColor,
      src: PhotoSrcModel.fromEntity(pin.src),
      liked: pin.liked,
      alt: pin.alt,
    );
  }

  // Convert this data model to the domain Pin entity
  Pin toEntity() {
    return Pin(
      id: id,
      width: width,
      height: height,
      url: url,
      photographer: photographer,
      photographerUrl: photographerUrl,
      photographerId: photographerId,
      avgColor: avgColor,
      src: src.toEntity(),
      liked: liked,
      alt: alt,
    );
  }
}

class PhotoSrcModel {
  PhotoSrcModel({
    required this.original,
    required this.large2x,
    required this.large,
    required this.medium,
    required this.small,
    required this.portrait,
    required this.landscape,
    required this.tiny,
  });

  final String original;
  final String large2x;
  final String large;
  final String medium;
  final String small;
  final String portrait;
  final String landscape;
  final String tiny;

  factory PhotoSrcModel.fromEntity(PinImageSources src) {
    return PhotoSrcModel(
      original: src.original,
      large2x: src.large2x,
      large: src.large,
      medium: src.medium,
      small: src.small,
      portrait: src.portrait,
      landscape: src.landscape,
      tiny: src.tiny,
    );
  }

  factory PhotoSrcModel.fromJson(Map<String, dynamic> json) {
    return PhotoSrcModel(
      original: json['original'] as String? ?? '',
      large2x: json['large2x'] as String? ?? '',
      large: json['large'] as String? ?? '',
      medium: json['medium'] as String? ?? '',
      small: json['small'] as String? ?? '',
      portrait: json['portrait'] as String? ?? '',
      landscape: json['landscape'] as String? ?? '',
      tiny: json['tiny'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'original': original,
      'large2x': large2x,
      'large': large,
      'medium': medium,
      'small': small,
      'portrait': portrait,
      'landscape': landscape,
      'tiny': tiny,
    };
  }

  PinImageSources toEntity() {
    return PinImageSources(
      original: original,
      large2x: large2x,
      large: large,
      medium: medium,
      small: small,
      portrait: portrait,
      landscape: landscape,
      tiny: tiny,
    );
  }
}
