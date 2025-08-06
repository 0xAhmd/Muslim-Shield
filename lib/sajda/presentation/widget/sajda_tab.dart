import 'package:azkar/sajda/data/repo/sajda_repo.dart';
import 'package:azkar/sajda/presentation/cubit/sajda_cubit.dart';
import 'package:azkar/sajda/presentation/cubit/sajda_state.dart';
import 'package:azkar/sajda/presentation/widget/sajda_err_view.dart';
import 'package:azkar/sajda/presentation/widget/sajda_list_view.dart';
import 'package:azkar/sajda/presentation/widget/sajda_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../constants.dart';


class SajdaTab extends StatefulWidget {
  const SajdaTab({super.key});

  @override
  State<SajdaTab> createState() => SajdaTabState();
}

class SajdaTabState extends State<SajdaTab> with AutomaticKeepAliveClientMixin {
  late SajdaCubit _sajdaCubit;
  String _currentSearchQuery = '';

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _sajdaCubit = SajdaCubit(repository: SajdaRepository());
    _sajdaCubit.loadSajdaSummaries();
  }

  @override
  void dispose() {
    _sajdaCubit.close();
    super.dispose();
  }

  // Method to be called from parent for search functionality
  void performSearch(String query) {
    _currentSearchQuery = query;
    _sajdaCubit.searchSajdas(query);
  }

  // Method to be called from parent to clear search
  void performClearSearch() {
    _currentSearchQuery = '';
    _sajdaCubit.clearSearch();
  }

  // Get current search query
  String getCurrentSearchQuery() {
    return _currentSearchQuery;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocProvider.value(
      value: _sajdaCubit,
      child: Container(
        color: scaffoldBackgroundColor,
        child: BlocBuilder<SajdaCubit, SajdaState>(
          builder: (context, state) {
            return _buildContent(state);
          },
        ),
      ),
    );
  }

  Widget _buildContent(SajdaState state) {
    if (state is SajdaLoading) {
      return const SajdaLoadingView();
    }

    if (state is SajdaError) {
      return SajdaErrorView(
        message: state.message,
        onRetry: () => _sajdaCubit.retry(),
      );
    }

    if (state is SajdaLoaded) {
      return Column(
        children: [
          _buildFilterControls(state),
          Expanded(
            child: SajdaListView(
              sajdaSummaries: state.filteredSajdas,
              isSearching:
                  _currentSearchQuery.isNotEmpty ||
                  state.searchQuery.isNotEmpty,
              searchQuery: state.searchQuery.isEmpty
                  ? _currentSearchQuery
                  : state.searchQuery,
              sajdaCubit: _sajdaCubit,
              showObligatory: state.showObligatory,
              showRecommended: state.showRecommended,
            ),
          ),
        ],
      );
    }

    return const SajdaLoadingView();
  }

  Widget _buildFilterControls(SajdaLoaded state) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 8, 24, 0),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _sajdaCubit.toggleObligatory(),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: state.showObligatory
                      ? Colors.red.withOpacity(0.1)
                      : grey.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: state.showObligatory
                        ? Colors.red.withOpacity(0.3)
                        : textColor.withOpacity(0.1),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.priority_high,
                      size: 18,
                      color: state.showObligatory
                          ? Colors.red
                          : textColor.withOpacity(0.6),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Obligatory',
                      style: TextStyle(
                        color: state.showObligatory
                            ? Colors.red
                            : textColor.withOpacity(0.6),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () => _sajdaCubit.toggleRecommended(),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: state.showRecommended
                      ? orange.withOpacity(0.1)
                      : grey.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: state.showRecommended
                        ? orange.withOpacity(0.3)
                        : textColor.withOpacity(0.1),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.star_outline,
                      size: 18,
                      color: state.showRecommended
                          ? orange
                          : textColor.withOpacity(0.6),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Recommended',
                      style: TextStyle(
                        color: state.showRecommended
                            ? orange
                            : textColor.withOpacity(0.6),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
