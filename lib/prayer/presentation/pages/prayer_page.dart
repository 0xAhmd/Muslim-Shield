import 'package:azkar/constants.dart';
import 'package:azkar/prayer/data/repo/prayer_repo.dart';
import 'package:azkar/prayer/data/service/prayer_api_service.dart';
import 'package:azkar/prayer/presentation/cubit/prayer_cubit.dart';
import 'package:azkar/prayer/presentation/cubit/prayer_state.dart';
import 'package:azkar/prayer/presentation/widgets/compass.dart';
import 'package:azkar/prayer/presentation/widgets/next_prayer_card.dart';
import 'package:azkar/prayer/presentation/widgets/prayer_time_list.dart';
import 'package:azkar/prayer/presentation/widgets/sunnah_prayers_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class PrayerPage extends StatelessWidget {
  const PrayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PrayerTimesCubit(
        PrayerRepositoryImpl(PrayerApiServiceFactory.create()),
      )..fetchPrayerTimes(),
      child: const PrayerPageView(),
    );
  }
}

class PrayerPageView extends StatefulWidget {
  const PrayerPageView({super.key});

  @override
  State<PrayerPageView> createState() => _PrayerPageViewState();
}

class _PrayerPageViewState extends State<PrayerPageView>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Prayer Times',
          style: TextStyle(
            color: textColor,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: background,
        elevation: 0,
        actions: [
          BlocBuilder<PrayerTimesCubit, PrayerTimesState>(
            builder: (context, state) {
              return IconButton(
                onPressed: () {
                  context.read<PrayerTimesCubit>().refreshPrayerTimes();
                },
                icon: Icon(Icons.refresh, color: textColor, size: 24.sp),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<PrayerTimesCubit, PrayerTimesState>(
        builder: (context, state) {
          if (state is PrayerTimesLoading) {
            return _buildLoadingState();
          }

          if (state is PrayerTimesError) {
            return _buildErrorState(state.message, context);
          }

          if (state is PrayerTimesLoaded) {
            return _buildLoadedState(state);
          }

          return _buildInitialState(context);
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: primary, strokeWidth: 3),
          SizedBox(height: 24.h),
          Text(
            'Getting your location...',
            style: TextStyle(
              color: textColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Fetching accurate prayer times',
            style: TextStyle(
              color: textColor.withOpacity(0.7),
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message, BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red.shade400, size: 64.sp),
            SizedBox(height: 24.h),
            Text(
              'Something went wrong',
              style: TextStyle(
                color: textColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor.withOpacity(0.7),
                fontSize: 14.sp,
                height: 1.5,
              ),
            ),
            SizedBox(height: 32.h),
            ElevatedButton(
              onPressed: () {
                context.read<PrayerTimesCubit>().fetchPrayerTimes();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                'Try Again',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_searching, color: primary, size: 64.sp),
          SizedBox(height: 24.h),
          Text(
            'Welcome to Prayer Times',
            style: TextStyle(
              color: textColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'Tap the button below to get started',
            style: TextStyle(
              color: textColor.withOpacity(0.7),
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 32.h),
          ElevatedButton(
            onPressed: () {
              context.read<PrayerTimesCubit>().fetchPrayerTimes();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              'Get Prayer Times',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadedState(PrayerTimesLoaded state) {
    return Column(
      children: [
        // Next Prayer Card (always visible)
        NextPrayerCard(nextPrayer: state.nextPrayer, location: state.location),

        // Tab Bar
        Container(
          margin: EdgeInsets.symmetric(horizontal: 24.w),
          decoration: BoxDecoration(
            color: gray,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: TabBar(
            controller: _tabController,
            labelColor: Colors.white,
            unselectedLabelColor: textColor.withOpacity(0.6),
            indicator: BoxDecoration(
              color: primary,
              borderRadius: BorderRadius.circular(8.r),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            labelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
            unselectedLabelStyle: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
            tabs: const [
              Tab(text: 'Prayer Times'),
              Tab(text: 'Qiblah'),
              Tab(text: 'Sunnah'),
            ],
          ),
        ),

        SizedBox(height: 16.h),

        // Tab View Content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // Prayer Times Tab
              SingleChildScrollView(
                child: Column(
                  children: [
                    PrayerTimesList(prayers: state.prayersList),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),

              // Qiblah Tab
              const SingleChildScrollView(
                child: Column(
                  children: [QiblahCompass(), SizedBox(height: 24)],
                ),
              ),

              // Sunnah Prayers Tab
              const SingleChildScrollView(
                child: Column(
                  children: [SunnahPrayersList(), SizedBox(height: 24)],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
