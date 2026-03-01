import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../domain/entities/pin.dart';
import '../../../presentation/notifiers/home_feed_state.dart';
import '../../../presentation/providers/home_providers.dart';
import '../pin_detail/widgets/save_to_board_sheet.dart';
import 'widgets/home_app_bar.dart';
import 'widgets/masonry_feed.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  final ScrollController _scrollController = ScrollController();
  bool _isAppBarVisible = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeFeedNotifierProvider.notifier).loadInitialPins();
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
    final direction = _scrollController.position.userScrollDirection;
    if (direction == ScrollDirection.forward && !_isAppBarVisible) {
      setState(() => _isAppBarVisible = true);
    } else if (direction == ScrollDirection.reverse && _isAppBarVisible) {
      setState(() => _isAppBarVisible = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final feedState = ref.watch(homeFeedNotifierProvider);
    // Height occupied by the floating app bar
    // status-bar + 8 (padding) + 44 (title row) + 8
    final topPadding = MediaQuery.of(context).padding.top + 60.0;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Stack(
        children: [
          _buildBody(feedState, topPadding),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: HomeAppBar(isVisible: _isAppBarVisible),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(HomeFeedState feedState, double topPadding) {
    if (feedState.error != null && feedState.pins.isEmpty) {
      return _buildErrorState(feedState, topPadding);
    }

    if (feedState.pins.isEmpty && !feedState.isLoading) {
      return _buildEmptyState(topPadding);
    }

    return MasonryFeed(
      pins: feedState.pins,
      isLoading: feedState.isLoading,
      isLoadingMore: feedState.isLoadingMore,
      hasReachedEnd: feedState.hasReachedEnd,
      savedPinIds: feedState.savedPinIds,
      scrollController: _scrollController,
      topPadding: topPadding,
      onLoadMore: () {
        ref.read(homeFeedNotifierProvider.notifier).loadMorePins();
      },
      onRefresh: () async {
        await ref.read(homeFeedNotifierProvider.notifier).refreshPins();
      },
      onSavePin: (pin) => _showSaveToBoardSheet(context, pin),
    );
  }

  void _showSaveToBoardSheet(BuildContext context, Pin pin) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SaveToBoardSheet(pinId: pin.id, pin: pin),
    );
  }

  Widget _buildErrorState(HomeFeedState feedState, double topPadding) {
    return Column(
      children: [
        SizedBox(height: topPadding),
        Expanded(
          child: AppErrorWidget(
            message: 'Could not load feed',
            subtitle: feedState.error?.message,
            onRetry: () {
              ref
                  .read(homeFeedNotifierProvider.notifier)
                  .loadInitialPins();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(double topPadding) {
    return Column(
      children: [
        SizedBox(height: topPadding),
        const Expanded(
          child: AppErrorWidget(
            message: 'Nothing here yet',
            subtitle: 'Pull down to refresh your feed.',
            icon: Icons.image_not_supported_outlined,
          ),
        ),
      ],
    );
  }
}
