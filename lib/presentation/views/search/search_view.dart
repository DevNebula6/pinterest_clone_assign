import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../presentation/notifiers/search_state.dart';
import '../../../presentation/providers/search_providers.dart';
import 'widgets/filter_pills.dart';
import 'widgets/search_bar_widget.dart';
import 'widgets/search_categories_grid.dart';
import 'widgets/search_results_grid.dart';
import 'widgets/search_suggestions.dart';

class SearchView extends ConsumerStatefulWidget {
  const SearchView({super.key});

  @override
  ConsumerState<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends ConsumerState<SearchView> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isActive = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(searchNotifierProvider.notifier).loadInitialState();
    });
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && mounted) {
        setState(() => _isActive = false);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _activate() {
    setState(() => _isActive = true);
    _focusNode.requestFocus();
  }

  void _cancel() {
    _focusNode.unfocus();
    setState(() => _isActive = false);
    _controller.clear();
    ref.read(searchNotifierProvider.notifier).clearSearch();
  }

  void _clearField() {
    _controller.clear();
    ref.read(searchNotifierProvider.notifier).clearSearch();
    setState(() {}); // refresh suffixIcon
  }

  void _onChanged(String value) {
    setState(() {}); // refresh suffixIcon visibility
    ref.read(searchNotifierProvider.notifier).onQueryChanged(value);
  }

  void _onSubmitted(String value) {
    if (value.trim().isEmpty) return;
    _focusNode.unfocus();
    ref.read(searchNotifierProvider.notifier).search(value.trim());
  }

  void _executeSuggestion(String query) {
    _controller.text = query;
    _focusNode.unfocus();
    setState(() => _isActive = false);
    ref.read(searchNotifierProvider.notifier).search(query);
  }

  void _executeCategory(String name) {
    _controller.text = name;
    setState(() => _isActive = false);
    ref.read(searchNotifierProvider.notifier).search(name);
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    final searchState = ref.watch(searchNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Column(
        children: [
          SizedBox(height: topPad + AppDimensions.paddingSmall),
          _buildPageTitle(searchState.status),
          SearchBarWidget(
            controller: _controller,
            focusNode: _focusNode,
            isActive: _isActive,
            onChanged: _onChanged,
            onSubmitted: _onSubmitted,
            onClear: _clearField,
            onActivate: _activate,
            onCancel: _cancel,
          ),
          _buildFilterRow(searchState),
          const Divider(height: 1, color: AppColors.divider),
          Expanded(
            child: _buildBody(searchState),
          ),
        ],
      ),
    );
  }

  Widget _buildPageTitle(SearchStatus status) {
    if (status == SearchStatus.initial && !_isActive) {
      return const Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingLarge,
          vertical: AppDimensions.paddingSmall,
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text('Explore', style: AppTypography.h2),
        ),
      );
    }
    return const SizedBox(height: 4);
  }

  Widget _buildFilterRow(SearchState searchState) {
    final showFilters = searchState.status == SearchStatus.results ||
        searchState.status == SearchStatus.empty;
    if (!showFilters) return const SizedBox.shrink();
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingSmall),
      child: FilterPills(),
    );
  }

  Widget _buildBody(SearchState searchState) {
    // Typing: show suggestions
    if (_isActive || searchState.query.isNotEmpty && searchState.status != SearchStatus.results) {
      final status = searchState.status;
      if (status == SearchStatus.results) {
        return SearchResultsGrid(onRetry: () {
          ref.read(searchNotifierProvider.notifier).search(searchState.query);
        });
      }
      return SingleChildScrollView(
        child: SearchSuggestions(onSuggestionTap: _executeSuggestion),
      );
    }

    // Results
    if (searchState.status == SearchStatus.results ||
        searchState.status == SearchStatus.loading ||
        searchState.status == SearchStatus.error ||
        searchState.status == SearchStatus.empty) {
      return SearchResultsGrid(
        onRetry: () {
          ref.read(searchNotifierProvider.notifier).search(searchState.query);
        },
      );
    }

    // Initial: categories grid
    return SingleChildScrollView(
      child: SearchCategoriesGrid(onCategoryTap: _executeCategory),
    );
  }
}
