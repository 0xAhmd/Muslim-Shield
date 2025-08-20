import '../../../core/connectivity_service.dart';
import '../../../core/widgets/offline_message.dart';

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
  final ConnectivityService _connectivityService = ConnectivityService();
  bool _isInitialized = false;
  bool _isConnected = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initializeConnectivity();
  }

  Future<void> _initializeConnectivity() async {
    // Check initial connectivity
    _isConnected = _connectivityService.isConnected;

    // Listen to connectivity changes
    _connectivityService.connectionStream.listen((connected) {
      if (mounted) {
        setState(() {
          _isConnected = connected;
          if (connected && !_isInitialized) {
            _initializeCubit();
          }
        });
      }
    });

    // Initialize if connected
    if (_isConnected) {
      _initializeCubit();
    }
  }

  void _initializeCubit() {
    if (!_isInitialized && _connectivityService.isConnected) {
      _hizbCubit = HizbCubit(repository: HizbRepository());
      _hizbCubit.loadHizbSummaries();

      // Preload popular Hizb sections in background
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _hizbCubit.preloadPopularHizb();
      });

      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    if (_isInitialized) {
      _hizbCubit.close();
    }
    super.dispose();
  }

  // Methods for search functionality (called from HomeScreen)
  void searchHizb(String query) {
    if (_isInitialized) {
      _hizbCubit.searchHizb(query);
    }
  }

  void clearSearch() {
    if (_isInitialized) {
      _hizbCubit.clearSearch();
    }
  }

  void performSearch(String query) {
    searchHizb(query);
  }

  void performClearSearch() {
    clearSearch();
  }

  // Method to get current search state for HomeScreen
  bool get isSearching => _isInitialized ? _hizbCubit.isSearching : false;

  String get currentSearchQuery =>
      _isInitialized ? _hizbCubit.getCurrentSearchQuery() : '';

  int get filteredCount => _isInitialized ? _hizbCubit.getFilteredCount() : 0;

  int get totalCount => _isInitialized ? _hizbCubit.getTotalCount() : 0;

  // Method to filter by Juzz (can be called from other components)
  void filterByJuzz(int juzzNumber) {
    if (_isInitialized) {
      _hizbCubit.filterByJuzz(juzzNumber);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // Show offline message if not connected
    if (!_isConnected) {
      return OfflineMessageWidget(
        customMessage:
            'Hizb content needs internet connectivity.\nPlease make sure you have an internet connection.',
        onRetry: () => _initializeConnectivity(),
      );
    }

    if (!_isInitialized) {
      return const HizbLoadingView();
    }

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
