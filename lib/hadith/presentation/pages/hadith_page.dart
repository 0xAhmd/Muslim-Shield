import 'package:azkar/hadith/data/repo/hadith_repo.dart';
import 'package:azkar/hadith/presentation/cubit/hadith_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants.dart';
import '../../data/models/book.dart';
import '../widgets/hadith_card.dart';
import '../widgets/loading_shimmer.dart';

class HadithsPage extends StatefulWidget {
  final Book book;

  const HadithsPage({super.key, required this.book});

  @override
  State<HadithsPage> createState() => _HadithsPageState();
}

class _HadithsPageState extends State<HadithsPage> {
  late HadithsCubit _hadithsCubit;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _hadithsCubit = HadithsCubit(HadithRepository());
    _scrollController = ScrollController();

    _hadithsCubit.loadHadiths(widget.book.id);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        _hadithsCubit.loadMore(widget.book.id);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _hadithsCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.book.name,
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocProvider.value(
        value: _hadithsCubit,
        child: BlocBuilder<HadithsCubit, HadithsState>(
          builder: (context, state) {
            if (state is HadithsLoading) {
              return const LoadingShimmer();
            } else if (state is HadithsError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error, color: Colors.red, size: 48.sp),
                    SizedBox(height: 16.h),
                    Text(
                      'Error: ${state.message}',
                      style: GoogleFonts.poppins(
                        color: Colors.red,
                        fontSize: 16.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () =>
                          _hadithsCubit.loadHadiths(widget.book.id),
                      style: ElevatedButton.styleFrom(backgroundColor: primary),
                      child: Text(
                        'Retry',
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is HadithsLoaded || state is HadithsLoadingMore) {
              final hadiths = state is HadithsLoaded
                  ? state.hadiths
                  : (state as HadithsLoadingMore).hadiths;

              if (hadiths.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.book_outlined, color: textColor, size: 48.sp),
                      SizedBox(height: 16.h),
                      Text(
                        'No hadiths found',
                        style: GoogleFonts.poppins(
                          color: textColor,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.all(16.r),
                itemCount: hadiths.length + 1,
                itemBuilder: (context, index) {
                  if (index < hadiths.length) {
                    return HadithCard(hadith: hadiths[index]);
                  } else {
                    // Load more indicator
                    if (state is HadithsLoaded && state.hasMore) {
                      return Container(
                        padding: EdgeInsets.all(16.r),
                        child: const Center(
                          child: CupertinoActivityIndicator(color: primary),
                        ),
                      );
                    } else if (state is HadithsLoadingMore) {
                      return Container(
                        padding: EdgeInsets.all(16.r),
                        child: const Center(
                          child: CupertinoActivityIndicator(color: primary),
                        ),
                      );
                    } else {
                      return SizedBox(height: 80.h); // Bottom padding
                    }
                  }
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
