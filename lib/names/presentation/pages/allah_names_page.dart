import '../../data/repo/allah_names_repo.dart';
import '../widgets/allah_name_card.dart';
import '../widgets/allah_names_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants.dart';
import '../cubit/allah_names_cubit.dart';

class AllahNamesPage extends StatelessWidget {
  const AllahNamesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AllahNamesCubit(AllahNamesRepository()),
      child: const AllahNamesView(),
    );
  }
}

class AllahNamesView extends StatefulWidget {
  const AllahNamesView({super.key});

  @override
  State<AllahNamesView> createState() => _AllahNamesViewState();
}

class _AllahNamesViewState extends State<AllahNamesView> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          _isSearching ? 'Search Names' : 'Names of Allah',
          style: GoogleFonts.poppins(
            fontSize: 20.sp,
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
                  context.read<AllahNamesCubit>().clearSearch();
                }
              });
            },
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: textColor,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_isSearching)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: SearchField(
                controller: _searchController,
                hintText: 'Search by name or meaning...',
                onChanged: (query) {
                  context.read<AllahNamesCubit>().searchNames(query);
                },
              ),
            ),

          // Header with count
          BlocBuilder<AllahNamesCubit, AllahNamesState>(
            builder: (context, state) {
              if (state is AllahNamesLoaded) {
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 16.h,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(color: primary.withOpacity(0.3)),
                        ),
                        child: Text(
                          '${state.filteredNames.length} Names',
                          style: GoogleFonts.poppins(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: primary,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (state.searchQuery?.isNotEmpty ?? false)
                        Text(
                          'Results for "${state.searchQuery}"',
                          style: GoogleFonts.poppins(
                            fontSize: 12.sp,
                            color: textColor.withOpacity(0.7),
                          ),
                        ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),

          // Names List
          Expanded(
            child: BlocBuilder<AllahNamesCubit, AllahNamesState>(
              builder: (context, state) {
                if (state is AllahNamesLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: primary),
                  );
                }

                if (state is AllahNamesError) {
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

                if (state is AllahNamesLoaded) {
                  if (state.filteredNames.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off, size: 48.sp, color: textColor),
                          SizedBox(height: 16.h),
                          Text(
                            'No names found',
                            style: GoogleFonts.poppins(
                              fontSize: 16.sp,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    itemCount: state.filteredNames.length,
                    itemBuilder: (context, index) {
                      final name = state.filteredNames[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: AllahNameCard(name: name),
                      );
                    },
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
