import '../../data/repo/hizb_repo.dart';
import '../cubit/hizb_cubit.dart';
import '../cubit/hizb_state.dart';
import 'hizb_err_view.dart';
import 'hizb_list_view.dart';
import 'hizb_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HizbTab extends StatefulWidget {
  const HizbTab({super.key});

  @override
  State<HizbTab> createState() => HizbTabState();
}

class HizbTabState extends State<HizbTab> with AutomaticKeepAliveClientMixin {
  late HizbCubit _hizbCubit;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _hizbCubit = HizbCubit(repository: HizbRepository());
    _hizbCubit.loadHizbSummaries();

    // Preload popular Hizb sections in background
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _hizbCubit.preloadPopularHizb();
    });
  }

  @override
  void dispose() {
    _hizbCubit.close();
    super.dispose();
  }

  // Methods for search functionality (called from HomeScreen)
  void searchHizb(String query) {
    _hizbCubit.searchHizb(query);
  }

  void clearSearch() {
    _hizbCubit.clearSearch();
  }

  void performSearch(String query) {
    searchHizb(query);
  }

  void performClearSearch() {
    clearSearch();
  }

  // Method to get current search state for HomeScreen
  bool get isSearching => _hizbCubit.isSearching;

  String get currentSearchQuery => _hizbCubit.getCurrentSearchQuery();

  int get filteredCount => _hizbCubit.getFilteredCount();

  int get totalCount => _hizbCubit.getTotalCount();

  // Method to filter by Juzz (can be called from other components)
  void filterByJuzz(int juzzNumber) {
    _hizbCubit.filterByJuzz(juzzNumber);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocProvider.value(
      value: _hizbCubit,
      child: BlocBuilder<HizbCubit, HizbState>(
        builder: (context, state) {
          if (state is HizbLoading) {
            return const HizbLoadingView();
          }

          if (state is HizbError) {
            return HizbErrorView(
              message: state.message,
              onRetry: () => _hizbCubit.retry(),
            );
          }

          if (state is HizbLoaded) {
            return HizbListView(
              hizbSummaries: state.filteredHizb,
              isSearching: state.searchQuery.isNotEmpty,
              searchQuery: state.searchQuery,
              hizbCubit: _hizbCubit,
            );
          }

          return const HizbLoadingView();
        },
      ),
    );
  }
}
