import 'package:azkar/radio/presentation/pages/radio_page.dart';
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

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    MainTabScreen(), // 0 - Quran
    PrayerPage(), // 1 - Prayer
    DoaPage(), // 2 - Duas
    RadioPage(), // 3 - Radio
    RemindersPage(), // 4 - Reminders
    BookmarksPage(), // 5 - Bookmarks
  ];

  @override
  void initState() {
    AppUpdater.checkForUpdate(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Needed to allow bottom nav bar to float over body
      body: Stack(
        children: [
          SafeArea(child: _pages[_selectedIndex]),

          /// Glassmorphic Bottom Nav Bar
          CustomBottomNav(
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ],
      ),
    );
  }
}
