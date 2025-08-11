import 'package:easy_localization/easy_localization.dart';

import '../../../core/connectivity_service.dart';
import '../../../core/widgets/azan_settings.dart';
import '../../../core/widgets/offline_message.dart';
import '../widgets/shimmers.dart';

import '../../../constants.dart';

import '../../data/repo/prayer_repo.dart';
import '../../data/service/prayer_api_service.dart';
import '../cubit/prayer_cubit.dart';
import '../cubit/prayer_state.dart';
import '../widgets/compass.dart';
import '../widgets/next_prayer_card.dart';
import '../widgets/prayer_time_list.dart';
import '../widgets/sunnah_prayers_list.dart';
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
  final ConnectivityService _connectivityService = ConnectivityService();
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this); // Updated to 4 tabs
    _initializeConnectivity();
  }

  void _initializeConnectivity() {
    _isConnected = _connectivityService.isConnected;

    _connectivityService.connectionStream.listen((connected) {
      if (mounted) {
        setState(() {
          _isConnected = connected;
        });

        if (!connected) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.wifi_off, color: Colors.white, size: 16),
                  const SizedBox(width: 8),
                  Text('prayer.connection_lost'.tr()),
                ],
              ),
              backgroundColor: Colors.orange.withOpacity(0.9),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    });
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
          'prayer.prayer_times'.tr(),
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
                onPressed: _isConnected
                    ? () {
                        context.read<PrayerTimesCubit>().refreshPrayerTimes();
                      }
                    : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('prayer.no_internet'.tr()),
                            backgroundColor: Colors.red.withOpacity(0.9),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                icon: Icon(
                  Icons.refresh,
                  color: _isConnected ? textColor : textColor.withOpacity(0.5),
                  size: 24.sp,
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<PrayerTimesCubit, PrayerTimesState>(
        builder: (context, state) {
          if (!_isConnected && state is! PrayerTimesLoaded) {
            return OfflineMessageWidget(
              customMessage:
                  'Prayer times need internet connectivity to fetch accurate times based on your location.\nPlease make sure you have an internet connection.',
              onRetry: () => _initializeConnectivity(),
            );
          }

          if (state is PrayerTimesLoading) {
            return _buildLoadingStateWithShimmer();
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

  Widget _buildLoadingStateWithShimmer() {
    return PrayerPageShimmers.fullPageLoadingShimmer();
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
              'prayer.something_wrong'.tr(),
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
              onPressed: _isConnected
                  ? () {
                      context.read<PrayerTimesCubit>().fetchPrayerTimes();
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isConnected
                    ? primary
                    : primary.withOpacity(0.5),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                _isConnected
                    ? 'prayer.try_again'.tr()
                    : 'prayer.no_connection'.tr(),
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
            'prayer.welcome'.tr(),
            style: TextStyle(
              color: textColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'prayer.get_started'.tr(),
            style: TextStyle(
              color: textColor.withOpacity(0.7),
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 32.h),
          ElevatedButton(
            onPressed: _isConnected
                ? () {
                    context.read<PrayerTimesCubit>().fetchPrayerTimes();
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: _isConnected
                  ? primary
                  : primary.withOpacity(0.5),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              _isConnected
                  ? 'prayer.get_prayer_times'.tr()
                  : 'prayer.no_connection'.tr(),
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
        // Connection status indicator
        if (!_isConnected)
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
            color: Colors.orange.withOpacity(0.1),
            child: Row(
              children: [
                Icon(Icons.wifi_off, color: Colors.orange, size: 16.sp),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'prayer.offline_cached'.tr(),
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

        // Next Prayer Card
        NextPrayerCard(nextPrayer: state.nextPrayer, location: state.location),

        // Tab Bar - Updated with 4 tabs
        Container(
          margin: EdgeInsets.symmetric(horizontal: 24.w),
          decoration: BoxDecoration(
            color: grey,
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
            labelStyle: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
            unselectedLabelStyle: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
            // Remove isScrollable to center the tabs properly
            tabs: [
              Tab(text: 'prayer.prayer_times'.tr()),
              Tab(text: 'prayer.qiblah'.tr()),
              Tab(text: 'prayer.sunnah'.tr()),
              Tab(text: 'prayer.adhan'.tr()),
            ],
          ),
        ),

        SizedBox(height: 16.h),

        // Tab View Content - Removed Center wrapper and fixed alignment
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
              SingleChildScrollView(
                child: Column(
                  children: [
                    if (!_isConnected)
                      Container(
                        margin: EdgeInsets.all(24.w),
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: Colors.blue.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.blue,
                              size: 16.sp,
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                'prayer.compass_offline'.tr(),
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const QiblahCompass(),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),

              // Sunnah Prayers Tab
              SingleChildScrollView(
                child: Column(
                  children: [
                    if (!_isConnected)
                      Container(
                        margin: EdgeInsets.all(24.w),
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: Colors.green.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              color: Colors.green,
                              size: 16.sp,
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                'prayer.sunnah_offline'.tr(),
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SunnahPrayersList(),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),

              // Adhan Settings Tab
              SingleChildScrollView(
                child: Column(
                  children: [
                    BlocListener<PrayerTimesCubit, PrayerTimesState>(
                      listener: (context, cubitState) {
                        // Update Adhan settings when prayer times change
                        if (cubitState is PrayerTimesLoaded) {
                          context
                              .read<PrayerTimesCubit>()
                              .updateAdhanSettings();
                        }
                      },
                      child: const AdhanSettingsWidget(),
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
