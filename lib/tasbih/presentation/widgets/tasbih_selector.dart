import 'package:azkar/tasbih/data/models/tasbih.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../constants.dart';

class TasbihSelector extends StatelessWidget {
  final List<TasbihModel> tasbihList;
  final TasbihModel? selectedTasbih;
  final ValueChanged<String> onTasbihSelected;

  const TasbihSelector({
    super.key,
    required this.tasbihList,
    required this.selectedTasbih,
    required this.onTasbihSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: tasbihList.length,
        itemBuilder: (context, index) {
          final tasbih = tasbihList[index];
          final isSelected = selectedTasbih?.id == tasbih.id;

          return GestureDetector(
            onTap: () => onTasbihSelected(tasbih.id),
            child: Container(
              width: 200.w,
              margin: EdgeInsets.only(right: 12.w),
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: isSelected ? primary.withOpacity(0.1) : grey,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: isSelected ? primary : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    tasbih.arabicText,
                    style: GoogleFonts.amiri(
                      fontSize: 20.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    tasbih.transliteration,
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      color: textColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      '${tasbih.currentCount}/${tasbih.targetCount}',
                      style: GoogleFonts.poppins(
                        fontSize: 10.sp,
                        color: primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
