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
    MainTabScreen(),
    PrayerPage(),
    DoaPage(),
    RemindersPage(),
    BookmarksPage(),
  ];
  @override
  void initState() {
    AppUpdater.checkForUpdate(context);
    super.initState();
  }

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
