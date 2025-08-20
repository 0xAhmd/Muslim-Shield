import 'dart:math';
import 'dart:ui';
import 'package:azkar/home/presentation/pages/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants.dart';
import 'onboarding_service.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isNavigating = false;

  final List<OnboardingData> _onboardingData = [
    OnboardingData(
      size: 10,
      title: "Read & Listen to Quran",
      description:
          "Experience the holy Quran with audio recitations, memorization tools, and track your reading progress with ease.",
      imagePath: "assets/images/quran_feature.png",
      icon: Icons.book,
      features: ["Audio Recitations", "Reading Progress", "Memorization Tools"],
    ),
    OnboardingData(
      size: 60,
      title: "Prayer Times & Tracking",
      description:
          "Never miss a prayer with accurate prayer times, Qibla direction, nearby masjids, and track your salah streak.",
      imagePath: "assets/images/prayer_feature.png",
      icon: Icons.schedule,
      features: [
        "Prayer Times",
        "Qibla Direction",
        "Nearby Masjids",
        "Salah Streak",
      ],
    ),
    OnboardingData(
      size: 60,
      imgColor: null,

      title: "Islamic Radio Stations",
      description:
          "Listen to Quran recitations, Islamic lessons, and spiritual content from renowned reciters and scholars.",
      imagePath: "assets/images/radio_feature.png",
      icon: Icons.radio,
      features: ["Quran Radio", "Islamic Lessons", "Multiple Reciters"],
    ),
    OnboardingData(
      size: 60,
      imgColor: Colors.deepPurple,
      title: "Authentic Hadith Collection",
      description:
          "Access authentic Hadith books and collections to deepen your Islamic knowledge and spiritual understanding.",
      imagePath: "assets/images/muhammad.png",
      icon: Icons.menu_book,
      features: ["Authentic Hadiths", "Multiple Books", "Easy Search"],
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_isNavigating) return;

    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _skipOnboarding() {
    if (_isNavigating) return;
    _finishOnboarding();
  }

  Future<void> _finishOnboarding() async {
    if (_isNavigating) return;

    setState(() {
      _isNavigating = true;
    });

    try {
      // Save onboarding completion status to SharedPreferences
      await OnboardingService.setOnboardingComplete();

      if (!mounted) return;

      // Navigate to home screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (e) {
      debugPrint('Error finishing onboarding: $e');

      if (mounted) {
        // Navigate anyway to prevent user from being stuck
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Muslim Shield",
                    style: GoogleFonts.poppins(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  TextButton(
                    onPressed: _isNavigating ? null : _skipOnboarding,
                    child: Text(
                      "Skip",
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        color: _isNavigating
                            ? textColor.withOpacity(0.5)
                            : textColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Page view content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  return _buildOnboardingPage(_onboardingData[index]);
                },
              ),
            ),

            // Page indicators and navigation
            Padding(
              padding: EdgeInsets.only(
                // CHANGE: Changed to only bottom padding
                left: 20.w,
                right: 20.w,
                bottom: 20.h,
                top: 10.h, // CHANGE: Reduced top padding from 20.h to 10.h
              ),
              child: Column(
                children: [
                  // Page indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _onboardingData.length,
                      (index) => _buildPageIndicator(index),
                    ),
                  ),
                  SizedBox(height: 24.h), // CHANGE: Reduced from 32.h to 24.h
                  // Navigation button
                  _buildNavigationButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingPage(OnboardingData data) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: max(MediaQuery.of(context).size.height - 200.h, 0),
          // Adjusts for top bar and button space
        ),
        child: Center(
          child: IntrinsicHeight(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20.h),
                  SizedBox(height: 120.h, child: _buildImageContent(data)),
                  SizedBox(height: 24.h),
                  Text(
                    data.title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    data.description,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      color: textColor,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    alignment: WrapAlignment.center,
                    children: data.features
                        .map((feature) => _buildFeatureChip(feature))
                        .toList(),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageContent(OnboardingData data) {
    return FutureBuilder<bool>(
      future: _assetExists(data.imagePath),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: primary.withOpacity(0.5),
              strokeWidth: 2,
            ),
          );
        }

        final bool assetExists = snapshot.data ?? false;

        if (assetExists) {
          return Image.asset(
            data.imagePath,
            fit: BoxFit.contain,
            height: 120.h, // Adjusted for smaller image
            color: data.imgColor,
          );
        } else {
          return _buildFallbackContent(data);
        }
      },
    );
  }

  Widget _buildFallbackContent(OnboardingData data) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20.w), // CHANGE: Reduced from 24.w to 20.w
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primary.withOpacity(0.1),
              border: Border.all(color: primary.withOpacity(0.3), width: 2),
            ),
            child: Icon(
              data.icon,
              size: 48.w, // CHANGE: Reduced from 60.w to 48.w for smaller icon
              color: primary,
            ),
          ),
          SizedBox(height: 12.h), // CHANGE: Reduced from 16.h to 12.h
          Text(
            "Feature Preview",
            style: GoogleFonts.poppins(
              fontSize: 14.sp, // CHANGE: Reduced from 16.sp to 14.sp
              fontWeight: FontWeight.w600,
              color: primary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            data.imagePath.split('/').last,
            style: GoogleFonts.poppins(
              fontSize: 9.sp, // CHANGE: Reduced from 10.sp to 9.sp
              color: textColor.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _assetExists(String path) async {
    try {
      await DefaultAssetBundle.of(context).load(path);
      return true;
    } catch (e) {
      return false;
    }
  }

  Widget _buildFeatureChip(String feature) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: primary.withOpacity(0.3)),
      ),
      child: Text(
        feature,
        style: GoogleFonts.poppins(
          fontSize: 12.sp,
          color: primary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildPageIndicator(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      width: _currentPage == index ? 24.w : 8.w,
      height: 8.h,
      decoration: BoxDecoration(
        color: _currentPage == index ? primary : textColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4.r),
      ),
    );
  }

  Widget _buildNavigationButton() {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: ElevatedButton(
            onPressed: _isNavigating ? null : _nextPage,
            style: ElevatedButton.styleFrom(
              backgroundColor: _isNavigating
                  ? primary.withOpacity(0.3)
                  : primary.withOpacity(0.8),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
                side: BorderSide(color: primary.withOpacity(0.5)),
              ),
            ),
            child: _isNavigating
                ? SizedBox(
                    width: 20.w,
                    height: 20.h,
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    _currentPage == _onboardingData.length - 1
                        ? "Get Started"
                        : "Continue",
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final String imagePath;
  final IconData icon;
  final Color? imgColor;
  final double? size;
  final List<String> features;

  OnboardingData({
    this.imgColor,
    required this.size,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.icon,
    required this.features,
  });
}
