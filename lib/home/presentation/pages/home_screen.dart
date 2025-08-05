import 'package:azkar/home/presentation/pages/main_tab.dart';
import 'package:azkar/home/presentation/widgets/custom_nav_bar.dart';
import 'package:azkar/prayer/presentation/pages/prayer_page.dart';
import 'package:flutter/material.dart';
import 'package:azkar/Doa/presentation/pages/doa_page.dart';
import 'package:azkar/Reminders/presentation/reminders_page.dart';
import 'package:azkar/bookmarks/presentation/bookmarks_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    MainTabScreen(), // Surah/Juzz/Hizb with search
    // RemindersPage(),
    PrayerPage(),
    DoaPage(),
    // BookmarksPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _pages[_selectedIndex]),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
