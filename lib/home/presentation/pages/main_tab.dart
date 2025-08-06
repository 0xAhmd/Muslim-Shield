import '../../../constants.dart';
import '../../../hizb/presentation/widgets/hizb_tab.dart';
import '../../../surah/widgets/custom_tab_bar.dart';
import '../widgets/greeting_section.dart';
import '../widgets/search_appbar.dart';
import '../../../juzz/presentation/widgets/juz_tab.dart';
import '../../../surah/widgets/surah_tab.dart';
import 'package:flutter/material.dart';

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
                    color: const Color(0xFFAAAAAA).withOpacity(.1),
                  ),
                ),
                elevation: 0,
                backgroundColor: scaffoldBackgroundColor,
                automaticallyImplyLeading: false,
                pinned: true,
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
                HizbTab(key: hizbTabKey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
