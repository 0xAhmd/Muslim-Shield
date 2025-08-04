import 'package:azkar/constants.dart';
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
              body: Container(),
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

class LastRead extends StatelessWidget {
  const LastRead({super.key});

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
              Text(
                'Al-Fatihah',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Ayat No: 1',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
