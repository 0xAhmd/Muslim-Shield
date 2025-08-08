// lib/adhkar/presentation/pages/adhkar_page.dart
import 'package:azkar/names/data/repo/adhkar_repo.dart';
import 'package:azkar/names/presentation/widgets/adhkar_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants.dart';
import '../cubit/adhkar_cubit.dart';
import '../../data/models/adhkar.dart';

class AdhkarPage extends StatelessWidget {
  const AdhkarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdhkarCubit(AdhkarRepository()),
      child: const AdhkarView(),
    );
  }
}

class AdhkarView extends StatefulWidget {
  const AdhkarView({super.key});

  @override
  State<AdhkarView> createState() => _AdhkarViewState();
}

class _AdhkarViewState extends State<AdhkarView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          _isSearching ? 'Search Adhkar' : 'Morning & Evening Adhkar',
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: textColor),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  context.read<AdhkarCubit>().clearSearch();
                }
              });
            },
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: textColor,
            ),
          ),
        ],
        bottom: _isSearching
            ? null
            : TabBar(
                dividerColor: Colors.transparent,
                controller: _tabController,
                indicatorColor: primary,
                labelColor: primary,
                unselectedLabelColor: textColor.withOpacity(0.7),
                labelStyle: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.wb_sunny_outlined, size: 16.sp),
                        SizedBox(width: 4.w),
                        const Text('Morning'),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.nights_stay_outlined, size: 16.sp),
                        SizedBox(width: 4.w),
                        const Text('Evening'),
                      ],
                    ),
                  ),
                ],
              ),
      ),
      body: Column(
        children: [
          if (_isSearching)
            Container(
              padding: EdgeInsets.all(24.r),
              child: Container(
                decoration: BoxDecoration(
                  color: grey.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (query) {
                    final currentType = _tabController.index == 0
                        ? AdhkarType.morning
                        : AdhkarType.evening;
                    context.read<AdhkarCubit>().searchAdhkar(
                      query,
                      currentType,
                    );
                  },
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14.sp,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search adhkar...',
                    hintStyle: GoogleFonts.poppins(
                      color: textColor.withOpacity(0.7),
                      fontSize: 14.sp,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: textColor.withOpacity(0.7),
                      size: 20.sp,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                  ),
                ),
              ),
            ),

          Expanded(
            child: BlocBuilder<AdhkarCubit, AdhkarState>(
              builder: (context, state) {
                if (state is AdhkarLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: primary),
                  );
                }

                if (state is AdhkarError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48.sp,
                          color: textColor,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          state.message,
                          style: GoogleFonts.poppins(
                            fontSize: 16.sp,
                            color: textColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                if (state is AdhkarLoaded) {
                  if (_isSearching) {
                    // Show search results in a single view
                    final currentAdhkar = _tabController.index == 0
                        ? state.filteredMorningAdhkar
                        : state.filteredEveningAdhkar;

                    return AdhkarTabView(adhkar: currentAdhkar);
                  }

                  // Show tabs
                  return TabBarView(
                    controller: _tabController,
                    children: [
                      AdhkarTabView(adhkar: state.filteredMorningAdhkar),
                      AdhkarTabView(adhkar: state.filteredEveningAdhkar),
                    ],
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
