import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../domain/entities/pin.dart';
import 'pin_card.dart';
import 'pin_card_shimmer.dart';

class MasonryFeed extends StatefulWidget {
  const MasonryFeed({
    super.key,
    required this.pins,
    required this.isLoading,
    required this.isLoadingMore,
    required this.hasReachedEnd,
    required this.savedPinIds,
    this.onLoadMore,
    this.onRefresh,
    this.onSavePin,
    this.scrollController,
    this.topPadding = 0,
  });

  final List<Pin> pins;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasReachedEnd;
  final List<int> savedPinIds;
  final VoidCallback? onLoadMore;
  final Future<void> Function()? onRefresh;
  final void Function(Pin pin)? onSavePin;
  final ScrollController? scrollController;
  // Extra top padding to account for a floating overlay app bar.
  final double topPadding;

  @override
  State<MasonryFeed> createState() => _MasonryFeedState();
}

class _MasonryFeedState extends State<MasonryFeed> {
  late final ScrollController _internalController;
  ScrollController get _controller =>
      widget.scrollController ?? _internalController;

  @override
  void initState() {
    super.initState();
    _internalController = ScrollController();
    _controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    if (widget.scrollController == null) {
      _internalController.dispose();
    }
    super.dispose();
  }

  void _onScroll() {
    if (!_controller.hasClients) return;
    final maxExtent = _controller.position.maxScrollExtent;
    final currentPixels = _controller.position.pixels;
    if (currentPixels >= maxExtent - 500 &&
        !widget.isLoadingMore &&
        !widget.hasReachedEnd) {
      widget.onLoadMore?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: widget.topPadding),
            const PinCardShimmer(),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.pinterestRed,
      onRefresh: widget.onRefresh ?? () async {},
      child: CustomScrollView(
        controller: _controller,
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.only(top: widget.topPadding),
            sliver: const SliverToBoxAdapter(child: SizedBox.shrink()),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(AppDimensions.gridPadding),
            sliver: SliverMasonryGrid.count(
              crossAxisCount: AppDimensions.gridColumnCount,
              mainAxisSpacing: AppDimensions.gridMainAxisSpacing,
              crossAxisSpacing: AppDimensions.gridCrossAxisSpacing,
              childCount: widget.pins.length,
              itemBuilder: (context, index) {
                final pin = widget.pins[index];
                return RepaintBoundary(
                  child: PinCard(
                    pin: pin,
                    isSaved: widget.savedPinIds.contains(pin.id),
                    onSave: () => widget.onSavePin?.call(pin),
                    heroTagSuffix: '',
                  ),
                );
              },
            ),
          ),
          if (widget.isLoadingMore)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: LoadingWidget(),
              ),
            ),
          if (widget.hasReachedEnd && widget.pins.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: AppColors.lightGray,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "You're all caught up!",
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }
}
