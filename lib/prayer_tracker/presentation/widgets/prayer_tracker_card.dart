import 'package:azkar/prayer_tracker/data/service/prayer_tracker_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants.dart';
import '../../data/models/prayer_completion.dart';
import '../cubit/prayer_tracker_cubit.dart';
import '../cubit/prayer_tracker_state.dart';
import '../pages/prayer_tracker_page.dart';

class PrayerTrackerCard extends StatelessWidget {
  const PrayerTrackerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PrayerTrackerCubit(
        prayerTrackerService: PrayerTrackerService(),
      )..initialize(),
      child: const PrayerTrackerCardView(),
    );
  }
}

class PrayerTrackerCardView extends StatelessWidget {
  const PrayerTrackerCardView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayerTrackerCubit, PrayerTrackerState>(
      builder: (context, state) {
        if (state is PrayerTrackerLoaded) {
          final completedCount = state.todaysCompletion.completedCount;
          final totalCount = PrayerType.values.length;
          final progress = completedCount / totalCount;

          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const PrayerTrackerPage(),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    primary.withOpacity(0.15),
                    primary.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: primary.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: primary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.check_circle_outline,
                          color: primary,
                          size: 20.sp,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Prayer Tracker',
                              style: GoogleFonts.poppins(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '$completedCount/$totalCount prayers completed',
                              style: GoogleFonts.poppins(
                                fontSize: 12.sp,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (state.todaysCompletion.isComplete)
                        Container(
                          padding: EdgeInsets.all(6.r),
                          decoration: BoxDecoration(
                            color: primary.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check,
                            color: primary,
                            size: 16.sp,
                          ),
                        ),
                    ],
                  ),
                  
                  SizedBox(height: 12.h),
                  
                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4.r),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: textColor.withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        state.todaysCompletion.isComplete ? primary : orange,
                      ),
                      minHeight: 4.h,
                    ),
                  ),
                  
                  SizedBox(height: 8.h),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${(progress * 100).toInt()}% completed',
                        style: GoogleFonts.poppins(
                          fontSize: 11.sp,
                          color: textColor,
                        ),
                      ),
                      if (state.streak.currentStreak > 0)
                        Row(
                          children: [
                            Icon(
                              Icons.local_fire_department,
                              color: orange,
                              size: 12.sp,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              '${state.streak.currentStreak}',
                              style: GoogleFonts.poppins(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                                color: orange,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }

        if (state is PrayerTrackerLoading) {
          return Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: grey.withOpacity(0.5),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: const Center(
              child: CircularProgressIndicator(
                color: primary,
                strokeWidth: 2,
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}