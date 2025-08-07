import 'package:azkar/core/connectivity_service.dart';
import 'package:azkar/core/offline_message.dart';
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
  final ConnectivityService _connectivityService = ConnectivityService();
  String _currentSearchQuery = '';
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
      _sajdaCubit = SajdaCubit(repository: SajdaRepository());
      _sajdaCubit.loadSajdaSummaries();
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    if (_isInitialized) {
      _sajdaCubit.close();
    }
    super.dispose();
  }

  // Method to be called from parent for search functionality
  void performSearch(String query) {
    if (_isInitialized) {
      _currentSearchQuery = query;
      _sajdaCubit.searchSajdas(query);
    }
  }

  // Method to be called from parent to clear search
  void performClearSearch() {
    if (_isInitialized) {
      _currentSearchQuery = '';
      _sajdaCubit.clearSearch();
    }
  }

  // Get current search query
  String getCurrentSearchQuery() {
    return _currentSearchQuery;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // Show offline message if not connected
    if (!_isConnected) {
      return OfflineMessageWidget(
        customMessage:
            'Sajda content needs internet connectivity.\nPlease make sure you have an internet connection.',
        onRetry: () => _initializeConnectivity(),
      );
    }

    if (!_isInitialized) {
      return const SajdaLoadingView();
    }

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
      return SajdaListView(
        sajdaSummaries: state.filteredSajdas,
        isSearching:
            _currentSearchQuery.isNotEmpty || state.searchQuery.isNotEmpty,
        searchQuery: state.searchQuery.isEmpty
            ? _currentSearchQuery
            : state.searchQuery,
        sajdaCubit: _sajdaCubit,
        showObligatory: state.showObligatory,
        showRecommended: state.showRecommended,
      );
    }

    return const SajdaLoadingView();
  }
}
