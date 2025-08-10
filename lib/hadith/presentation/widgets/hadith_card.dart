import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants.dart';
import '../../../bookmarks/service/bookmark_service.dart';
import '../../data/models/hadith.dart';

class HadithCard extends StatefulWidget {
  final Hadith hadith;

  const HadithCard({super.key, required this.hadith});

  @override
  State<HadithCard> createState() => _HadithCardState();
}

class _HadithCardState extends State<HadithCard>
    with SingleTickerProviderStateMixin {
  bool _showArabic = true;
  bool _isBookmarked = false;
  bool _isBookmarkLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final BookmarksService _bookmarksService = BookmarksService();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _checkBookmarkStatus();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _checkBookmarkStatus() async {
    try {
      final isBookmarked = await _bookmarksService.isHadithBookmarked(widget.hadith.id.toString());
      if (mounted) {
        setState(() {
          _isBookmarked = isBookmarked;
        });
      }
    } catch (e) {
      // Handle error silently or show a snackbar
    }
  }

  Future<void> _toggleBookmark() async {
    if (_isBookmarkLoading) return;

    setState(() {
      _isBookmarkLoading = true;
    });

    try {
      if (_isBookmarked) {
        await _bookmarksService.removeHadithBookmark(widget.hadith.id.toString());
        if (mounted) {
          setState(() {
            _isBookmarked = false;
            _isBookmarkLoading = false;
          });
          _showSnackBar('Hadith removed from bookmarks', Colors.orange);
        }
      } else {
        // Create hadith bookmark
        await _bookmarksService.bookmarkHadith(
          hadithId: widget.hadith.id.toString(),
          title: 'Hadith #${widget.hadith.hadithNumber}',
          text: widget.hadith.hadithEnglish,
          reference: '${widget.hadith.book.name} - ${widget.hadith.attribution}',
          category: widget.hadith.book.name,
        );
        
        if (mounted) {
          setState(() {
            _isBookmarked = true;
            _isBookmarkLoading = false;
          });
          _showSnackBar('Hadith bookmarked successfully', Colors.green);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isBookmarkLoading = false;
        });
        _showSnackBar('Error: ${e.toString()}', Colors.red);
      }
    }
  }

  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
    );
  }

  void _toggleLanguage() {
    _animationController.forward().then((_) {
      setState(() {
        _showArabic = !_showArabic;
      });
      _animationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleLanguage,
      child: Container(
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
            // Header with Hadith Number Badge and Language Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    'Hadith #${widget.hadith.hadithNumber}',
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: primary,
                    ),
                  ),
                ),
                // Language indicator
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: _showArabic
                        ? orange.withOpacity(0.1)
                        : Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _showArabic ? Icons.translate : Icons.language,
                        size: 12.sp,
                        color: _showArabic ? orange : Colors.blue,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        _showArabic ? 'العربية' : 'English',
                        style: GoogleFonts.poppins(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                          color: _showArabic ? orange : Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            // Tap to translate hint
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: scaffoldBackgroundColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.touch_app,
                    size: 12.sp,
                    color: textColor.withOpacity(0.7),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'Tap to ${_showArabic ? 'translate' : 'show Arabic'}',
                    style: GoogleFonts.poppins(
                      fontSize: 10.sp,
                      color: textColor.withOpacity(0.7),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 12.h),

            // Hadith Text with Animation
            FadeTransition(
              opacity: _fadeAnimation,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  _showArabic
                      ? (widget.hadith.hadithArabic ?? widget.hadith.hadith)
                      : widget.hadith.hadith,
                  key: ValueKey(_showArabic),
                  style: _showArabic
                      ? GoogleFonts.amiri(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          height: 1.8,
                        )
                      : GoogleFonts.poppins(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          height: 1.6,
                        ),
                  textAlign: _showArabic ? TextAlign.right : TextAlign.justify,
                ),
              ),
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
                      widget.hadith.attribution,
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

            if (widget.hadith.grade != null) ...[
              SizedBox(height: 12.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: _getGradeColor(widget.hadith.grade!).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  'Grade: ${widget.hadith.grade}',
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    color: _getGradeColor(widget.hadith.grade!),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],

            SizedBox(height: 12.h),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Bookmark button
                Container(
                  decoration: BoxDecoration(
                    color: _isBookmarked 
                        ? primary.withOpacity(0.1) 
                        : scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: IconButton(
                    onPressed: _isBookmarkLoading ? null : _toggleBookmark,
                    icon: _isBookmarkLoading
                        ? SizedBox(
                            width: 20.sp,
                            height: 20.sp,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(primary),
                            ),
                          )
                        : Icon(
                            _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                            color: _isBookmarked ? primary : textColor,
                            size: 20.sp,
                          ),
                    tooltip: _isBookmarked ? 'Remove bookmark' : 'Add bookmark',
                  ),
                ),
                SizedBox(width: 8.w),
                // Copy button
                Container(
                  decoration: BoxDecoration(
                    color: scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: IconButton(
                    onPressed: () => _copyHadith(context),
                    icon: Icon(Icons.copy, color: textColor, size: 20.sp),
                    tooltip: 'Copy hadith',
                  ),
                ),
              ],
            ),
          ],
        ),
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
    final arabicText = widget.hadith.hadithArabic ?? '';
    final englishText = widget.hadith.hadith;
    final attribution = widget.hadith.attribution;
    final bookName = widget.hadith.book.name;

    final text = '''${arabicText.isNotEmpty ? '$arabicText\n\n' : ''}$englishText

- $attribution
Source: $bookName''';

    Clipboard.setData(ClipboardData(text: text));
    _showSnackBar('Hadith copied to clipboard', primary);
  }
}