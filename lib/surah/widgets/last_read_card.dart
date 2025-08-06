import '../../constants.dart';
import '../data/service/last_read.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LastReadCard extends StatefulWidget {
  const LastReadCard({super.key});

  @override
  State<LastReadCard> createState() => _LastReadCardState();
}

class _LastReadCardState extends State<LastReadCard> {
  LastReadData? lastReadData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLastRead();
  }

  Future<void> _loadLastRead() async {
    try {
      setState(() => isLoading = true);
      final data = await LastReadService.getLastRead();
      setState(() {
        lastReadData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  void _showRefreshMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.refresh, color: Colors.white, size: 14.sp),
            SizedBox(width: 6.w),
            Text('Refreshed', style: GoogleFonts.poppins(fontSize: 11.sp)),
          ],
        ),
        duration: const Duration(seconds: 1),
        backgroundColor: primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.r)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _GradientBackground(),
        _QuranIllustration(),
        _RefreshButton(
          onRefresh: () {
            _loadLastRead();
            _showRefreshMessage();
          },
        ),
        _CardContent(isLoading: isLoading, lastReadData: lastReadData),
      ],
    );
  }
}

class _GradientBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 133,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0, .6, 1],
          colors: [Color(0xFFDF98EA), Color(0XFFB070FD), Color(0xFF9055FF)],
        ),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

class _QuranIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: -6.h,
      right: 0,
      child: SvgPicture.asset('assets/svgs/quran.svg', height: 80.h),
    );
  }
}

class _RefreshButton extends StatelessWidget {
  final VoidCallback onRefresh;

  const _RefreshButton({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 12.h,
      right: 12.w,
      child: GestureDetector(
        onTap: onRefresh,
        child: Container(
          padding: EdgeInsets.all(6.r),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Icon(Icons.refresh, color: Colors.white, size: 14.sp),
        ),
      ),
    );
  }
}

class _CardContent extends StatelessWidget {
  final bool isLoading;
  final LastReadData? lastReadData;

  const _CardContent({required this.isLoading, required this.lastReadData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(),
          const SizedBox(height: 20),
          if (isLoading)
            _LoadingState()
          else if (lastReadData != null)
            _ReadingData(data: lastReadData!)
          else
            _EmptyState(),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset('assets/svgs/book.svg'),
        const SizedBox(width: 8),
        Text(
          'Last Read',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _LoadingState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 18,
          width: 120,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 14,
          width: 80,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}

class _ReadingData extends StatelessWidget {
  final LastReadData data;

  const _ReadingData({required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          data.surahEnglishName,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              'Ayah ${data.ayahNumber}',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
            if (data.juzzNumber != null) ...[
              const SizedBox(width: 8),
              _Badge(text: 'Juzz ${data.juzzNumber}'),
            ],
            const SizedBox(width: 8),
            _Badge(text: '${data.progressPercentage.toStringAsFixed(0)}%'),
          ],
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;

  const _Badge({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Start Reading',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Start Thawab Streak',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
      ],
    );
  }
}
