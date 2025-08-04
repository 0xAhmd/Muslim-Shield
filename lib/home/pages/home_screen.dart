import 'package:azkar/constants.dart';
import 'package:azkar/home/data/service/last_read.dart';
import 'package:azkar/home/tabs/hizb_tab.dart';
import 'package:azkar/home/tabs/juz_tab.dart';
import 'package:azkar/home/tabs/page_tab.dart';
import 'package:azkar/home/tabs/surah_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      bottomNavigationBar: _bottomNavigationBar(),
      body: SafeArea(
        child: DefaultTabController(
          length: 4,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverToBoxAdapter(child: Greetings()),
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
                    child: _Tab(),
                  ),
                ),
              ],
              body: TabBarView(
                children: [SurahTab(), JuzTab(), PageTab(), HizbTab()],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TabBar _Tab() {
    return TabBar(
      unselectedLabelColor: text,
      indicatorWeight: 3,
      labelStyle: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        fontSize: 18,
        color: Colors.white,
      ),
      dividerHeight: 0,
      tabs: [
        TabItem(title: "Surah"),
        TabItem(title: "Juz'"),
        TabItem(title: "Page"),
        TabItem(title: "Hizb"),
      ],
    );
  }

  Tab TabItem({required String title}) => Tab(text: title);

  BottomNavigationBar _bottomNavigationBar() => BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    backgroundColor: gray,
    showSelectedLabels: false,
    showUnselectedLabels: false,
    items: [
      _bottomBarItem(icon: "assets/svgs/quran-icon.svg", label: "Quran"),
      _bottomBarItem(icon: "assets/svgs/lamp-icon.svg", label: "Tips"),
      _bottomBarItem(icon: "assets/svgs/pray-icon.svg", label: "Prayer"),
      _bottomBarItem(icon: "assets/svgs/doa-icon.svg", label: "Doa"),
      _bottomBarItem(icon: "assets/svgs/bookmark-icon.svg", label: "Bookmark"),
    ],
  );

  BottomNavigationBarItem _bottomBarItem({
    required String icon,
    required String label,
  }) => BottomNavigationBarItem(
    // ignore: deprecated_member_use
    icon: SvgPicture.asset(icon, color: text),
    activeIcon: SvgPicture.asset(icon, color: primary),
    label: "",
  );

  AppBar _appBar() => AppBar(
    elevation: 0,
    automaticallyImplyLeading: false,
    title: Row(
      children: [
        IconButton(
          onPressed: () {},
          icon: SvgPicture.asset('assets/svgs/menu-icon.svg'),
        ),
        const SizedBox(width: 24),
        Text(
          "Azkar",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: text,
          ),
        ),
        Spacer(),
        IconButton(
          onPressed: () {},
          icon: SvgPicture.asset('assets/svgs/search-icon.svg'),
        ),
      ],
    ),
  );
}

class Greetings extends StatelessWidget {
  const Greetings({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Assalamalaikum",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: text,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Bless Muhammad",
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),
        LastRead(),
      ],
    );
  }
}

class LastRead extends StatefulWidget {
  const LastRead({super.key});

  @override
  State<LastRead> createState() => _LastReadState();
}

class _LastReadState extends State<LastRead> {
  LastReadData? lastReadData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLastRead();
  }

  Future<void> _loadLastRead() async {
    try {
      setState(() {
        isLoading = true;
      });
      final data = await LastReadService.getLastRead();
      setState(() {
        lastReadData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 133,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0, .6, 1],
              colors: [Color(0xFFDF98EA), Color(0XFFB070FD), Color(0xFF9055FF)],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: SvgPicture.asset('assets/svgs/quran.svg'),
        ),

        // Refresh Button
        Positioned(
          top: 70,
          left: 140,
          child: GestureDetector(
            onTap: () {
              _loadLastRead();
              // Show brief feedback
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.refresh, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        'Refreshed',
                        style: GoogleFonts.poppins(fontSize: 12),
                      ),
                    ],
                  ),
                  duration: const Duration(seconds: 1),
                  backgroundColor: primary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(Icons.refresh, color: Colors.white, size: 16),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
              ),
              const SizedBox(height: 20),
              if (isLoading)
                Column(
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
                )
              else if (lastReadData != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lastReadData!.surahEnglishName,
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
                          'Ayah ${lastReadData!.ayahNumber}',
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${lastReadData!.progressPercentage.toStringAsFixed(0)}%',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              else
                Column(
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
                      'Begin your Quran journey',
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}
