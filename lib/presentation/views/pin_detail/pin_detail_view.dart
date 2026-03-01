import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/avatar_widget.dart';
import '../../../core/widgets/cached_image_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/scale_tap.dart';
import '../../../domain/entities/pin.dart';
import '../../../presentation/providers/home_providers.dart';
import '../../../presentation/providers/pin_detail_providers.dart';
import 'widgets/more_like_this_grid.dart';
import 'widgets/pin_action_bar.dart';
import 'widgets/pin_creator_row.dart';
import 'widgets/save_to_board_sheet.dart';

class PinDetailView extends ConsumerStatefulWidget {
  const PinDetailView({super.key, required this.pinId});

  final int pinId;

  @override
  ConsumerState<PinDetailView> createState() => _PinDetailViewState();
}

class _PinDetailViewState extends ConsumerState<PinDetailView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(pinDetailNotifierProvider(widget.pinId).notifier)
          .loadPinDetail(widget.pinId);
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final max = _scrollController.position.maxScrollExtent;
    final pixels = _scrollController.position.pixels;
    if (pixels >= max - 500) {
      ref
          .read(pinDetailNotifierProvider(widget.pinId).notifier)
          .loadMoreRelatedPins();
    }
  }

  @override
  Widget build(BuildContext context) {
    final detailState = ref.watch(pinDetailNotifierProvider(widget.pinId));
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Stack(
        children: [
          _buildScrollContent(detailState),
          _buildBackButton(topPad),
        ],
      ),
    );
  }

  Widget _buildScrollContent(detailState) {
    if (detailState.isLoading && detailState.pin == null) {
      return const Center(child: LoadingWidget());
    }

    if (detailState.error != null && detailState.pin == null) {
      return AppErrorWidget(
        message: 'Could not load pin',
        subtitle: detailState.error?.message,
        onRetry: () => ref
            .read(pinDetailNotifierProvider(widget.pinId).notifier)
            .loadPinDetail(widget.pinId),
      );
    }

    final pin = detailState.pin;
    if (pin == null) return const SizedBox.shrink();

    final homeFeedState = ref.watch(homeFeedNotifierProvider);
    final savedPinIds = homeFeedState.savedPinIds;

    return CustomScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        SliverToBoxAdapter(child: _buildHeroImage(pin)),
        SliverToBoxAdapter(
          child: PinActionBar(
            isSaved: detailState.isSaved,
            pageUrl: pin.url,
            onSave: () => _handleSave(context, detailState.isSaved),
            onShare: () => _share(pin),
          ),
        ),
        SliverToBoxAdapter(
          child: PinCreatorRow(
            photographerName: pin.photographer,
            photographerUrl: pin.photographerUrl,
          ),
        ),
        SliverToBoxAdapter(
          child: _buildTitleAndDescription(pin),
        ),
        SliverToBoxAdapter(
          child: MoreLikeThisGrid(
            pins: detailState.relatedPins,
            isLoading: detailState.isLoadingRelated,
            savedPinIds: savedPinIds,
            onSavePin: (relatedPin) => _showSaveToBoardSheet(
              context,
              relatedPin,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleAndDescription(Pin pin) {
    final title = pin.alt.isNotEmpty
        ? pin.alt.split('.').first.trim()
        : 'Untitled';

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingLarge,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.h2,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          if (pin.alt.isNotEmpty && pin.alt.contains('.')) ...[
            const SizedBox(height: 4),
            Text(
              pin.alt.substring(pin.alt.indexOf('.') + 1).trim(),
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: AppDimensions.paddingLarge),
        ],
      ),
    );
  }

  Widget _buildHeroImage(Pin pin) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth - 16; // 8px margin each side
    final aspectRatio =
        pin.height == 0 ? 1.0 : pin.width / pin.height;
    final clamped = aspectRatio.clamp(0.45, 1.5);
    final imageHeight = cardWidth / clamped;

    return Padding(
      padding: const EdgeInsets.only(
        left: 8,
        right: 8,
        top: 26,
        bottom: 0,
      ),
      child: Hero(
        tag: 'pin-${pin.id}-',
        flightShuttleBuilder: (_, animation, __, ___, ____) {
          return FadeTransition(
            opacity: animation,
            child: CachedImageWidget(
              imageUrl: pin.src.large2x,
              width: cardWidth,
              height: imageHeight,
              avgColor: pin.avgColor,
              borderRadius: 28,
            ),
          );
        },
        child: Stack(
          children: [
            CachedImageWidget(
              imageUrl: pin.src.large2x,
              width: cardWidth,
              height: imageHeight,
              avgColor: pin.avgColor,
              borderRadius: 28,
            ),
            // Photographer overlay at image bottom
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black54],
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
                child: Row(
                  children: [
                    AvatarWidget(
                      size: 28,
                      name: pin.photographer,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Remixed from ${pin.photographer}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton(double topPad) {
    return Positioned(
      top: topPad + 8,
      left: 12,
      child: _FloatButton(
        icon: Icons.arrow_back_ios_new_rounded,
        onTap: () => context.pop(),
        tooltip: 'Back',
      ),
    );
  }

  void _handleSave(BuildContext context, bool isSaved) {
    if (isSaved) {
      ref
          .read(pinDetailNotifierProvider(widget.pinId).notifier)
          .unsavePin()
          .then((_) {
        ref.read(homeFeedNotifierProvider.notifier).refreshSavedPinIds();
      });
    } else {
      _showSaveToBoardSheet(context, null);
    }
  }

  void _showSaveToBoardSheet(BuildContext context, Pin? pin) {
    final pinId = pin?.id ?? widget.pinId;
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SaveToBoardSheet(pinId: pinId, pin: pin),
    );
  }

  void _share(Pin pin) {
    final text = pin.alt.isNotEmpty
        ? '${pin.alt}\n\n${pin.url}'
        : 'Check out this photo by ${pin.photographer}\n\n${pin.url}';
    Share.share(text);
  }
}

class _FloatButton extends StatelessWidget {
  const _FloatButton({
    required this.icon,
    required this.onTap,
    required this.tooltip,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return ScaleTap(
      onPressed: onTap,
      scaleTo: 0.90,
      enableHaptic: true,
      child: Tooltip(
        message: tooltip,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.75),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: AppDimensions.iconSmall,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
