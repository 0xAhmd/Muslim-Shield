import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants.dart';

class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;

  const SearchField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: grey.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: GoogleFonts.poppins(color: Colors.white, fontSize: 14.sp),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(
            color: textColor.withOpacity(0.7),
            fontSize: 14.sp,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: textColor.withOpacity(0.7),
            size: 20.sp,
          ),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: textColor.withOpacity(0.7),
                    size: 20.sp,
                  ),
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 12.h,
          ),
        ),
      ),
    );
  }
}
