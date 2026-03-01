import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import 'shimmer_widget.dart';

class CachedImageWidget extends StatelessWidget {
  const CachedImageWidget({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
    this.borderRadius = 0.0,
    this.avgColor,
    this.fit = BoxFit.cover,
    this.heroTag,
    this.memCacheWidth,
  });

  final String imageUrl;
  final double width;
  final double height;
  final double borderRadius;
  // Pexels provides an average hex color per photo — used as placeholder bg.
  final String? avgColor;
  final BoxFit fit;
  final String? heroTag;
  // Physical pixel width cap for memory cache. Keeps RAM usage proportional
  // to display size rather than raw image dimensions.
  final int? memCacheWidth;

  Color? get _avgColorValue {
    if (avgColor == null || avgColor!.length < 6) return null;
    final hex = avgColor!.replaceFirst('#', '');
    final value = int.tryParse('FF$hex', radix: 16);
    if (value == null) return null;
    return Color(value);
  }

  @override
  Widget build(BuildContext context) {
    Widget image = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        memCacheWidth: memCacheWidth,
        fadeInDuration: const Duration(milliseconds: 300),
        placeholderFadeInDuration: const Duration(milliseconds: 150),
        placeholder: (context, url) => _buildPlaceholder(),
        errorWidget: (context, url, error) => _buildError(),
        imageBuilder: (context, imageProvider) => Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            image: DecorationImage(image: imageProvider, fit: fit),
          ),
        ),
      ),
    );

    if (heroTag != null) {
      image = Hero(tag: heroTag!, child: image);
    }

    return image;
  }

  Widget _buildPlaceholder() {
    final color = _avgColorValue;
    if (color != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          width: width,
          height: height,
          color: color.withValues(alpha: 0.4),
        ),
      );
    }
    return ShimmerWidget(
      width: width,
      height: height,
      borderRadius: borderRadius,
    );
  }

  Widget _buildError() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        width: width,
        height: height,
        color: AppColors.lightGray,
        child: const Center(
          child: Icon(
            Icons.broken_image_outlined,
            color: AppColors.textTertiary,
            size: 28,
          ),
        ),
      ),
    );
  }
}
