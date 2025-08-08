import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants.dart';
import '../../data/models/adhkar.dart';

class AdhkarCard extends StatefulWidget {
  final Adhkar adhkar;

  const AdhkarCard({super.key, required this.adhkar});

  @override
  State<AdhkarCard> createState() => _AdhkarCardState();
}

class _AdhkarCardState extends State<AdhkarCard> {
  int currentRepetition = 0;

  @override
  void initState() {
    super.initState();
    currentRepetition = widget.adhkar.repetition;
  }

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
            _showAdhkarDetails(context);
          },
          child: Padding(
            padding: EdgeInsets.all(20.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with repetition counter
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: widget.adhkar.type == AdhkarType.morning
                            ? orange.withOpacity(0.2)
                            : primary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: widget.adhkar.type == AdhkarType.morning
                              ? orange.withOpacity(0.5)
                              : primary.withOpacity(0.5),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            widget.adhkar.type == AdhkarType.morning
                                ? Icons.wb_sunny
                                : Icons.nights_stay,
                            size: 12.sp,
                            color: widget.adhkar.type == AdhkarType.morning
                                ? orange
                                : primary,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            widget.adhkar.type == AdhkarType.morning
                                ? 'Morning'
                                : 'Evening',
                            style: GoogleFonts.poppins(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              color: widget.adhkar.type == AdhkarType.morning
                                  ? orange
                                  : primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    if (widget.adhkar.repetition > 1) ...[
                      GestureDetector(
                        onTap: () {
                          if (currentRepetition > 0) {
                            setState(() {
                              currentRepetition--;
                            });
                          }
                        },
                        child: Container(
                          width: 32.w,
                          height: 32.h,
                          decoration: BoxDecoration(
                            color: currentRepetition > 0
                                ? primary.withOpacity(0.2)
                                : grey.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: currentRepetition > 0
                                  ? primary.withOpacity(0.5)
                                  : textColor.withOpacity(0.3),
                            ),
                          ),
                          child: Icon(
                            Icons.remove,
                            size: 16.sp,
                            color: currentRepetition > 0
                                ? primary
                                : textColor.withOpacity(0.5),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: currentRepetition == 0
                              ? Colors.green.withOpacity(0.2)
                              : primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: currentRepetition == 0
                                ? Colors.green
                                : primary.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          currentRepetition == 0
                              ? 'Done'
                              : '$currentRepetition left',
                          style: GoogleFonts.poppins(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: currentRepetition == 0
                                ? Colors.green
                                : primary,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            currentRepetition = widget.adhkar.repetition;
                          });
                        },
                        child: Container(
                          width: 32.w,
                          height: 32.h,
                          decoration: BoxDecoration(
                            color: orange.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(color: orange.withOpacity(0.5)),
                          ),
                          child: Icon(
                            Icons.refresh,
                            size: 16.sp,
                            color: orange,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),

                SizedBox(height: 16.h),

                // Arabic text
                Text(
                  widget.adhkar.arabic,
                  style: GoogleFonts.amiri(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.8,
                  ),
                  textAlign: TextAlign.right,
                ),

                SizedBox(height: 12.h),

                // Transliteration
                Text(
                  widget.adhkar.transliteration,
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    fontStyle: FontStyle.italic,
                    color: orange.withOpacity(0.8),
                    height: 1.4,
                  ),
                ),

                SizedBox(height: 12.h),

                // Translation
                Text(
                  widget.adhkar.translation,
                  style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                    color: textColor,
                    height: 1.5,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: 12.h),

                // Footer with reference and tap hint
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Reference: ${widget.adhkar.reference}',
                        style: GoogleFonts.poppins(
                          fontSize: 10.sp,
                          color: textColor.withOpacity(0.7),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.touch_app,
                      size: 14.sp,
                      color: primary.withOpacity(0.7),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'Tap for full text',
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

  void _showAdhkarDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.6,
        maxChildSize: 0.95,
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
                      // Header
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: widget.adhkar.type == AdhkarType.morning
                                  ? orange.withOpacity(0.2)
                                  : primary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(
                                color: widget.adhkar.type == AdhkarType.morning
                                    ? orange.withOpacity(0.5)
                                    : primary.withOpacity(0.5),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  widget.adhkar.type == AdhkarType.morning
                                      ? Icons.wb_sunny
                                      : Icons.nights_stay,
                                  size: 16.sp,
                                  color:
                                      widget.adhkar.type == AdhkarType.morning
                                      ? orange
                                      : primary,
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  '${widget.adhkar.type == AdhkarType.morning ? 'Morning' : 'Evening'} Adhkar',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        widget.adhkar.type == AdhkarType.morning
                                        ? orange
                                        : primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          if (widget.adhkar.repetition > 1)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: textColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(
                                  color: textColor.withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                'Repeat ${widget.adhkar.repetition}x',
                                style: GoogleFonts.poppins(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: textColor,
                                ),
                              ),
                            ),
                        ],
                      ),

                      SizedBox(height: 24.h),

                      // Arabic text
                      Text(
                        'Arabic',
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.r),
                        decoration: BoxDecoration(
                          color: scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                        child: Text(
                          widget.adhkar.arabic,
                          style: GoogleFonts.amiri(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 2.0,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // Transliteration
                      Text(
                        'Transliteration',
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.r),
                        decoration: BoxDecoration(
                          color: orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: orange.withOpacity(0.3)),
                        ),
                        child: Text(
                          widget.adhkar.transliteration,
                          style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            fontStyle: FontStyle.italic,
                            color: orange,
                            height: 1.6,
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // Translation
                      Text(
                        'Translation',
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.r),
                        decoration: BoxDecoration(
                          color: primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: primary.withOpacity(0.3)),
                        ),
                        child: Text(
                          widget.adhkar.translation,
                          style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            color: textColor,
                            height: 1.6,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // Reference
                      Text(
                        'Reference',
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.r),
                        decoration: BoxDecoration(
                          color: scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                        child: Text(
                          widget.adhkar.reference,
                          style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            color: textColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
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
