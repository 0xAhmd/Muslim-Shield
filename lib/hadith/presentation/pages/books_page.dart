import '../../data/repo/hadith_repo.dart';
import 'hadith_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants.dart';
import '../cubit/books_cubit.dart';
import '../widgets/book_tile.dart';
import '../widgets/loading_shimmer.dart';

class BooksPage extends StatefulWidget {
  const BooksPage({super.key});

  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  final TextEditingController _searchController = TextEditingController();
  late BooksCubit _booksCubit;

  @override
  void initState() {
    super.initState();
    _booksCubit = BooksCubit(HadithRepository());
    _booksCubit.loadBooks();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _booksCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hadith Books',
          style: GoogleFonts.poppins(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocProvider.value(
        value: _booksCubit,
        child: Column(
          children: [
            // Search Bar
            Container(
              margin: EdgeInsets.all(16.r),
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: grey,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: primary.withOpacity(0.2)),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (query) => _booksCubit.searchBooks(query),
                style: GoogleFonts.poppins(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search books...',
                  hintStyle: GoogleFonts.poppins(color: textColor),
                  border: InputBorder.none,
                  prefixIcon: const Icon(Icons.search, color: primary),
                ),
              ),
            ),

            // Books List
            Expanded(
              child: BlocBuilder<BooksCubit, BooksState>(
                builder: (context, state) {
                  if (state is BooksLoading) {
                    return const LoadingShimmer();
                  } else if (state is BooksError) {
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
                            onPressed: () => _booksCubit.loadBooks(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primary,
                            ),
                            child: Text(
                              'Retry',
                              style: GoogleFonts.poppins(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (state is BooksLoaded) {
                    if (state.books.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.book_outlined,
                              color: textColor,
                              size: 48.sp,
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'No books found',
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
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      itemCount: state.books.length,
                      itemBuilder: (context, index) {
                        final book = state.books[index];
                        return BookTile(
                          book: book,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HadithsPage(book: book),
                              ),
                            );
                          },
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
      ),
    );
  }
}
