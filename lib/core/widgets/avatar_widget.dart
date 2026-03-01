import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_typography.dart';

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({
    super.key,
    required this.size,
    this.imageUrl,
    this.name,
    this.borderColor,
    this.borderWidth = 0.0,
    this.onTap,
  });

  final double size;
  final String? imageUrl;
  // Used to derive the fallback initial letter and background color.
  final String? name;
  final Color? borderColor;
  final double borderWidth;
  final VoidCallback? onTap;

  String get _initial {
    if (name == null || name!.isEmpty) return '?';
    return name![0].toUpperCase();
  }

  Color get _fallbackColor {
    if (name == null || name!.isEmpty) return AppColors.textTertiary;
    final index = name!.codeUnitAt(0) % AppColors.boardColors.length;
    return AppColors.boardColors[index];
  }

  @override
  Widget build(BuildContext context) {
    Widget avatar;

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      avatar = CachedNetworkImage(
        imageUrl: imageUrl!,
        imageBuilder: (context, imageProvider) => CircleAvatar(
          radius: size / 2,
          backgroundImage: imageProvider,
        ),
        placeholder: (context, url) => _buildFallback(),
        errorWidget: (context, url, error) => _buildFallback(),
      );
    } else {
      avatar = _buildFallback();
    }

    if (borderColor != null && borderWidth > 0) {
      avatar = Container(
        width: size + borderWidth * 2,
        height: size + borderWidth * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: borderColor!, width: borderWidth),
        ),
        child: avatar,
      );
    }

    if (onTap != null) {
      avatar = GestureDetector(onTap: onTap, child: avatar);
    }

    return avatar;
  }

  Widget _buildFallback() {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: _fallbackColor,
      child: Text(
        _initial,
        style: AppTypography.labelMedium.copyWith(
          color: AppColors.white,
          fontSize: size * 0.4,
        ),
      ),
    );
  }
}
