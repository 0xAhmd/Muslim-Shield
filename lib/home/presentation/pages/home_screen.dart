import 'package:azkar/masjid/presentation/pages/masjid_finder_page.dart';
import 'package:azkar/radio/presentation/pages/radio_page.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../Reminders/presentation/pages/reminders_page.dart';
import '../../../core/app_updater.dart';
import 'main_tab.dart';
import '../widgets/custom_nav_bar.dart';
import '../../../prayer/presentation/pages/prayer_page.dart';
import 'package:flutter/material.dart';
import '../../../Doa/presentation/pages/doa_page.dart';
import '../../../bookmarks/presentation/bookmarks_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _isNavBarVisible = true;
  late AnimationController _animationController;
  late Animation<double> _animation;

  final List<Widget> _pages = const [
    MainTabScreen(), // 0 - Quran
    PrayerPage(), // 1 - Prayer
    DoaPage(), // 2 - Duas
    MasjidFinderPage(), // 3 - Masjid Finder (replacing Radio)

    RadioPage(), // 3 - Radio
    RemindersPage(), // 4 - Reminders
    BookmarksPage(), // 5 - Bookmarks
  ];

  @override
  void initState() {
    AppUpdater.checkForUpdate(context);

    // Initialize animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Start with navigation bar visible
    _animationController.forward();

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showNavBar() {
    if (!_isNavBarVisible) {
      setState(() {
        _isNavBarVisible = true;
      });
      _animationController.forward();
    }
  }

  void _hideNavBar() {
    if (_isNavBarVisible) {
      setState(() {
        _isNavBarVisible = false;
      });
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          // Wrap each page with NotificationListener to detect scroll
          SafeArea(
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                // Only handle UserScrollNotification for user-initiated scrolls
                if (scrollInfo is UserScrollNotification) {
                  if (scrollInfo.direction == ScrollDirection.forward) {
                    // Scrolling up - show nav bar
                    _showNavBar();
                  } else if (scrollInfo.direction == ScrollDirection.reverse) {
                    // Scrolling down - hide nav bar
                    _hideNavBar();
                  }
                }
                return false;
              },
              child: _pages[_selectedIndex],
            ),
          ),

          // Animated Glassmorphic Bottom Nav Bar
          Positioned(
            bottom: 24.h,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    0,
                    (1 - _animation.value) * 100,
                  ), // Slide down when hiding
                  child: Opacity(
                    opacity: _animation.value,
                    child: CustomBottomNav(
                      currentIndex: _selectedIndex,
                      onTap: (index) {
                        setState(() {
                          _selectedIndex = index;
                        });
                        // Show nav bar when user taps
                        _showNavBar();
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
