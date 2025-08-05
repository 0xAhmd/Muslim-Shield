import 'package:azkar/constants.dart';

import 'package:azkar/hizb/presentation/widgets/hizb_tab.dart';
import 'package:azkar/home/presentation/widgets/custom_nav_bar.dart';
import 'package:azkar/home/presentation/widgets/custom_tab_bar.dart';
import 'package:azkar/home/presentation/widgets/greeting_section.dart';
import 'package:azkar/home/presentation/widgets/search_appbar.dart';
import 'package:azkar/juzz/presentation/widgets/juz_tab.dart';
import 'package:azkar/surah/widgets/surah_tab.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  bool isSearching = false;
  final TextEditingController searchController = TextEditingController();
  late TabController tabController;
  final GlobalKey<SurahTabState> surahTabKey = GlobalKey<SurahTabState>();
  final GlobalKey<JuzTabState> juzTabKey = GlobalKey<JuzTabState>();
  final GlobalKey<HizbTabState> hizbTabKey = GlobalKey<HizbTabState>();

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    searchController.dispose();
    tabController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      isSearching = !isSearching;
      if (!isSearching) {
        searchController.clear();
        _clearCurrentTabSearch();
      }
    });
  }

  void _clearCurrentTabSearch() {
    switch (tabController.index) {
      case 0:
        surahTabKey.currentState?.clearSearch();
        break;
      case 1:
        juzTabKey.currentState?.performClearSearch();
        break;
      case 2:
        hizbTabKey.currentState?.performClearSearch();
        break;
    }
  }

  void _onSearchChanged(String query) {
    switch (tabController.index) {
      case 0:
        surahTabKey.currentState?.searchSurahs(query);
        break;
      case 1:
        juzTabKey.currentState?.performSearch(query);
        break;
      case 2:
        hizbTabKey.currentState?.performSearch(query);
        break;
    }
  }

  bool _canSearchInCurrentTab() {
    return tabController.index == 0 ||
        tabController.index == 1 ||
        tabController.index == 2;
  }

  String _getSearchHint() {
    switch (tabController.index) {
      case 0:
        return 'Search Surahs...';
      case 1:
        return 'Search Juzz...';
      case 2:
        return 'Search Hizb sections...';
      default:
        return 'Search...';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBar(
        isSearching: isSearching,
        searchController: searchController,
        onToggleSearch: _toggleSearch,
        onSearchChanged: _onSearchChanged,
        canSearch: _canSearchInCurrentTab(),
        searchHint: _getSearchHint(),
      ),
      bottomNavigationBar: const CustomBottomNav(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              if (!isSearching)
                const SliverToBoxAdapter(child: GreetingSection()),
              SliverAppBar(
                shape: Border(
                  bottom: BorderSide(
                    width: 3,
                    color: Color(0xFFAAAAAA).withOpacity(.1),
                  ),
                ),
                elevation: 0,
                backgroundColor: background,
                automaticallyImplyLeading: true,
                pinned: true,
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(0),
                  child: CustomTabBar(
                    controller: tabController,
                    onTap: (index) {
                      if (isSearching && !_canSearchInCurrentTab()) {
                        _toggleSearch();
                      }
                      _clearCurrentTabSearch();
                    },
                  ),
                ),
              ),
            ],
            body: TabBarView(
              controller: tabController,
              children: [
                SurahTab(key: surahTabKey),
                JuzTab(key: juzTabKey),
                HizbTab(key: hizbTabKey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
