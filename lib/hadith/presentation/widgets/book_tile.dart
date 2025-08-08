import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants.dart';
import '../../data/models/book.dart';

class BookTile extends StatelessWidget {
  final Book book;
  final VoidCallback onTap;

  const BookTile({super.key, required this.book, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: grey,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: primary.withOpacity(0.1)),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        leading: Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Image.asset(
            'assets/images/al-quran.png',
            width: 24.sp,
            color: primary,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.book, color: primary, size: 24.sp);
            },
          ),
        ),
        title: Text(
          book.name,
          style: GoogleFonts.poppins(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'By ${book.writerName}',
              style: GoogleFonts.poppins(fontSize: 12.sp, color: textColor),
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Icon(Icons.book_outlined, size: 12.sp, color: primary),
                SizedBox(width: 4.w),
                Text(
                  '${book.hadithsCount} hadiths',
                  style: GoogleFonts.poppins(fontSize: 11.sp, color: primary),
                ),
                SizedBox(width: 8.w),
                Icon(Icons.list_alt, size: 12.sp, color: orange),
                SizedBox(width: 4.w),
                Text(
                  '${book.chaptersCount} chapters',
                  style: GoogleFonts.poppins(fontSize: 11.sp, color: orange),
                ),
              ],
            ),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: primary, size: 16.sp),
        onTap: onTap,
      ),
    );
  }
}
