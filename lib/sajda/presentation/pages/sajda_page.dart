import 'package:easy_localization/easy_localization.dart';

import '../../data/repo/sajda_repo.dart';
import '../cubit/sajda_cubit.dart';
import '../cubit/sajda_state.dart';
import '../widget/sajda_err_view.dart';
import '../widget/sajda_list_view.dart';
import '../widget/sajda_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants.dart';

class SajdaPage extends StatefulWidget {
  const SajdaPage({super.key});

  @override
  State<SajdaPage> createState() => _SajdaPageState();
}

class _SajdaPageState extends State<SajdaPage> {
  late SajdaCubit _sajdaCubit;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _sajdaCubit = SajdaCubit(repository: SajdaRepository());
    _sajdaCubit.loadSajdaSummaries();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _sajdaCubit.close();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _sajdaCubit.clearSearch();
      }
    });
  }

  void _onSearchChanged(String query) {
    _sajdaCubit.searchSajdas(query);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _sajdaCubit,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: Column(
          children: [
            if (_isSearching) _buildSearchField(),
            Expanded(
              child: BlocBuilder<SajdaCubit, SajdaState>(
                builder: (context, state) {
                  return _buildBody(state);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: scaffoldBackgroundColor,
      title: _isSearching
          ? null
          : Text(
              'sajda.sajdas'.tr(),
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
      actions: [
        if (!_isSearching)
          BlocBuilder<SajdaCubit, SajdaState>(
            builder: (context, state) {
              if (state is SajdaLoaded) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildFilterButton(
                      icon: Icons.priority_high,
                      label: 'sajda.obligatory'.tr(),
                      isActive: state.showObligatory,
                      color: Colors.red,
                      onPressed: () => _sajdaCubit.toggleObligatory(),
                    ),
                    const SizedBox(width: 8),
                    _buildFilterButton(
                      icon: Icons.star_outline,
                      label: 'sajda.recommended'.tr(),
                      isActive: state.showRecommended,
                      color: orange,
                      onPressed: () => _sajdaCubit.toggleRecommended(),
                    ),
                    const SizedBox(width: 8),
                  ],
                );
              }
              return const SizedBox();
            },
          ),
        IconButton(
          onPressed: _toggleSearch,
          icon: Icon(
            _isSearching ? Icons.close : Icons.search,
            color: textColor,
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildFilterButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isActive ? color.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isActive
                ? color.withOpacity(0.3)
                : textColor.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isActive ? color : textColor.withOpacity(0.6),
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isActive ? color : textColor.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      decoration: BoxDecoration(
        color: grey,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primary.withOpacity(0.2)),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          hintText: 'sajda.search_placeholder'.tr(),
          hintStyle: GoogleFonts.poppins(
            color: textColor.withOpacity(0.6),
            fontSize: 14,
          ),
          prefixIcon: Icon(Icons.search, color: textColor.withOpacity(0.6)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildBody(SajdaState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: _buildStateContent(state),
    );
  }

  Widget _buildStateContent(SajdaState state) {
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
        isSearching: _isSearching || state.searchQuery.isNotEmpty,
        searchQuery: state.searchQuery.isEmpty
            ? _searchController.text
            : state.searchQuery,
        sajdaCubit: _sajdaCubit,
        showObligatory: state.showObligatory,
        showRecommended: state.showRecommended,
      );
    }

    return const SajdaLoadingView();
  }
}
