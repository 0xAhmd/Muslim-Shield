import 'package:azkar/names/presentation/widgets/adhkar_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants.dart';
import '../../data/models/adhkar.dart';

class AdhkarTabView extends StatelessWidget {
  final List<Adhkar> adhkar;

  const AdhkarTabView({super.key, required this.adhkar});

  @override
  Widget build(BuildContext context) {
    if (adhkar.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 48.sp, color: textColor),
            SizedBox(height: 16.h),
            Text(
              'No adhkar found',
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                color: textColor,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Header with count
        Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: primary.withOpacity(0.3)),
                ),
                child: Text(
                  '${adhkar.length} Adhkar',
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: primary,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Adhkar List
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            itemCount: adhkar.length,
            itemBuilder: (context, index) {
              final item = adhkar[index];
              return Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: AdhkarCard(adhkar: item),
              );
            },
          ),
        ),
      ],
    );
  }
}
