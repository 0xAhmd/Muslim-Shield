// lib/prayer_tracker/presentation/pages/prayer_tracker_page.dart
import 'package:azkar/prayer_tracker/data/service/prayer_tracker_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants.dart';
import '../../data/models/prayer_completion.dart';

import '../cubit/prayer_tracker_cubit.dart';
import '../cubit/prayer_tracker_state.dart';
import '../widgets/prayer_completion_card.dart';
import '../widgets/streak_info_card.dart';
import '../widgets/daily_progress_card.dart';
import '../widgets/weekly_stats_card.dart';

class PrayerTrackerPage extends StatelessWidget {
  const PrayerTrackerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PrayerTrackerCubit(prayerTrackerService: PrayerTrackerService())
            ..initialize(),
      child: const PrayerTrackerView(),
    );
  }
}

class PrayerTrackerView extends StatelessWidget {
  const PrayerTrackerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Prayer Tracker',
          style: GoogleFonts.poppins(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          BlocBuilder<PrayerTrackerCubit, PrayerTrackerState>(
            builder: (context, state) {
              if (state is PrayerTrackerLoaded) {
                return IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    context.read<PrayerTrackerCubit>().refreshData();
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocConsumer<PrayerTrackerCubit, PrayerTrackerState>(
        listener: (context, state) {
          if (state is PrayerTrackerError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is PrayerTrackerLoading) {
            return const Center(
              child: CircularProgressIndicator(color: primary),
            );
          }

          if (state is PrayerTrackerError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 48.sp),
                  SizedBox(height: 16.h),
                  Text(
                    'Something went wrong',
                    style: GoogleFonts.poppins(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  ElevatedButton(
                    onPressed: () {
                      context.read<PrayerTrackerCubit>().initialize();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'Retry',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is PrayerTrackerLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                await context.read<PrayerTrackerCubit>().refreshData();
              },
              color: primary,
              backgroundColor: grey,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Daily progress card
                    DailyProgressCard(completion: state.todaysCompletion),

                    SizedBox(height: 20.h),

                    // Streak info card
                    StreakInfoCard(streak: state.streak),

                    SizedBox(height: 24.h),

                    // Today's prayers section
                    Text(
                      'Today\'s Prayers',
                      style: GoogleFonts.poppins(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    SizedBox(height: 12.h),

                    // Prayer completion cards
                    ...PrayerType.values.map((prayer) {
                      final isCompleted =
                          state.todaysCompletion.completions[prayer] ?? false;
                      return PrayerCompletionCard(
                        prayer: prayer,
                        isCompleted: isCompleted,
                        onToggle: () {
                          context
                              .read<PrayerTrackerCubit>()
                              .togglePrayerCompletion(prayer);
                        },
                      );
                    }).toList(),

                    SizedBox(height: 24.h),

                    // Statistics card
                    WeeklyStatsCard(
                      weeklyStats: state.weeklyStats,
                      monthlyStats: state.monthlyStats,
                    ),

                    // Add some bottom padding for navigation
                    SizedBox(height: 100.h),
                  ],
                ),
              ),
            );
          }

          return const Center(
            child: Text(
              'Prayer Tracker',
              style: TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}
