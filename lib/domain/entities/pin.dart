import 'package:equatable/equatable.dart';

// Represents a single Pinterest pin (photo from Pexels)
class Pin extends Equatable {
  const Pin({
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
  final PinImageSources src;
  final bool liked;
  final String alt;

  double get aspectRatio => height == 0 ? 1.0 : width / height;
  // src.large (~940px wide) provides crisp images on high-density displays
  // while keeping file size reasonable compared to original/large2x.
  String get thumbnailUrl => src.large;
  String get fullUrl => src.large2x;

  @override
  List<Object?> get props => [id];
}

class PinImageSources extends Equatable {
  const PinImageSources({
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

  @override
  List<Object?> get props => [original];
}
