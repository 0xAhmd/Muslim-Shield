import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../hizb/presentation/widgets/hizb_tab.dart';
import '../../../juzz/presentation/widgets/juz_tab.dart';
import '../../../sajda/presentation/widget/sajda_tab.dart';
import '../../../surah/widgets/custom_tab_bar.dart';
import '../../../surah/widgets/surah_tab.dart';
import '../widgets/greeting_section.dart';
import '../widgets/search_appbar.dart';

class MainTabScreen extends StatefulWidget {
  const MainTabScreen({super.key});

  @override
  State<MainTabScreen> createState() => _MainTabScreenState();
}

class _MainTabScreenState extends State<MainTabScreen>
    with TickerProviderStateMixin {
  bool isSearching = false;
  final TextEditingController searchController = TextEditingController();
  late TabController tabController;
  final GlobalKey<SurahTabState> surahTabKey = GlobalKey<SurahTabState>();
  final GlobalKey<JuzTabState> juzTabKey = GlobalKey<JuzTabState>();
  final GlobalKey<HizbTabState> hizbTabKey = GlobalKey<HizbTabState>();
  final GlobalKey<SajdaTabState> sajdaTabKey =
      GlobalKey<SajdaTabState>(); // Add SajdaTab key

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
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
      case 3:
        sajdaTabKey.currentState
            ?.performClearSearch(); // Add sajda clear search
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
      case 3:
        sajdaTabKey.currentState?.performSearch(query); // Add sajda search
        break;
    }
  }

  bool _canSearchInCurrentTab() {
    return tabController.index == 0 ||
        tabController.index == 1 ||
        tabController.index == 2 ||
        tabController.index == 3; // Enable search for sajda tab
  }

  String _getSearchHint() {
    switch (tabController.index) {
      case 0:
        return 'Search Surahs...';
      case 1:
        return 'Search Juzz...';
      case 2:
        return 'Search Hizb sections...';
      case 3:
        return 'Search Sajdas...'; // Add sajda search hint
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              if (!isSearching)
                const SliverToBoxAdapter(child: GreetingSection()),
              SliverAppBar(
                floating: false,

                elevation: 0,
                backgroundColor: scaffoldBackgroundColor,
                automaticallyImplyLeading: false,
                pinned: true,
                snap: false,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(0),
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
                SajdaTab(
                  key: sajdaTabKey,
                ), // Replace duplicate HizbTab with SajdaTab
              ],
            ),
          ),
        ),
      ),
    );
  }
}
