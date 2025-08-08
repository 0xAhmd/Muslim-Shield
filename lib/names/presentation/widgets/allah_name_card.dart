import 'package:azkar/names/data/models/names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants.dart';

class AllahNameCard extends StatelessWidget {
  final AllahName name;

  const AllahNameCard({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [grey.withOpacity(0.8), grey.withOpacity(0.4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () {
            _showNameDetails(context);
          },
          child: Padding(
            padding: EdgeInsets.all(20.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    // Number badge
                    Container(
                      width: 32.w,
                      height: 32.h,
                      decoration: BoxDecoration(
                        color: primary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: primary.withOpacity(0.5)),
                      ),
                      child: Center(
                        child: Text(
                          '${name.id}',
                          style: GoogleFonts.poppins(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: primary,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            name.arabic,
                            style: GoogleFonts.amiri(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.2,
                            ),
                            textAlign: TextAlign.right,
                          ),
                          SizedBox(height: 4.h),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              name.transliteration,
                              style: GoogleFonts.poppins(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: orange,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    name.meaning,
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  name.description,
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    color: textColor,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.touch_app,
                      size: 16.sp,
                      color: primary.withOpacity(0.7),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'Tap for details',
                      style: GoogleFonts.poppins(
                        fontSize: 10.sp,
                        color: primary.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showNameDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: grey,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: EdgeInsets.only(top: 12.h),
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: textColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: EdgeInsets.all(24.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Arabic name centered
                      Center(
                        child: Text(
                          name.arabic,
                          style: GoogleFonts.amiri(
                            fontSize: 48.sp,
                            fontWeight: FontWeight.bold,
                            color: primary,
                            height: 1.2,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Transliteration centered
                      Center(
                        child: Text(
                          name.transliteration,
                          style: GoogleFonts.poppins(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: orange,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),

                      // Meaning centered
                      Center(
                        child: Text(
                          name.meaning,
                          style: GoogleFonts.poppins(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // Description section
                      Text(
                        'Description',
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        name.description,
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          color: textColor,
                          height: 1.6,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
