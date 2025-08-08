import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants.dart';
import '../../data/models/hadith.dart';

class HadithCard extends StatelessWidget {
  final Hadith hadith;

  const HadithCard({
    super.key,
    required this.hadith,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: grey,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: primary.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hadith Number Badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              'Hadith #${hadith.id}',
              style: GoogleFonts.poppins(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: primary,
              ),
            ),
          ),
          
          SizedBox(height: 16.h),

          // Hadith Text
          Text(
            hadith.hadith,
            style: GoogleFonts.amiri(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              height: 1.8,
            ),
            textAlign: TextAlign.justify,
          ),

          SizedBox(height: 16.h),

          // Attribution
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Icon(Icons.person, color: orange, size: 16.sp),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    hadith.attribution,
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      color: orange,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (hadith.grade != null) ...[
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: _getGradeColor(hadith.grade!).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                'Grade: ${hadith.grade}',
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  color: _getGradeColor(hadith.grade!),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],

          SizedBox(height: 12.h),

          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () => _copyHadith(context),
                icon: Icon(Icons.copy, color: textColor, size: 20.sp),
                tooltip: 'Copy',
              ),
              IconButton(
                onPressed: () => _shareHadith(context),
                icon: Icon(Icons.share, color: textColor, size: 20.sp),
                tooltip: 'Share',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getGradeColor(String grade) {
    switch (grade.toLowerCase()) {
      case 'sahih':
        return Colors.green;
      case 'hasan':
        return Colors.blue;
      case 'da\'if':
        return Colors.orange;
      default:
        return textColor;
    }
  }

  void _copyHadith(BuildContext context) {
    final text = '${hadith.hadith}\n\n- ${hadith.attribution}';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Hadith copied to clipboard'),
        backgroundColor: primary,
      ),
    );
  }

  void _shareHadith(BuildContext context) {
    //!TODO Implement share functionality if needed
    // You can use share_plus package
  }
}