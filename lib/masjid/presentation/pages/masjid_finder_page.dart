import 'package:azkar/masjid/presentation/widgets/loading_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants.dart';
import '../cubit/masjid_cubit.dart';
import '../cubit/masjid_state.dart';
import '../widgets/empty_masjids.dart';
import '../widgets/location_permission_dialog.dart';
import '../widgets/masjic_card.dart';
import '../widgets/snackbar_helper.dart';

class MasjidFinderPage extends StatelessWidget {
  const MasjidFinderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MasjidStateCubit()..loadNearbyMasjids(),
      child: const MasjidFinderView(),
    );
  }
}

class MasjidFinderView extends StatefulWidget {
  const MasjidFinderView({super.key});

  @override
  State<MasjidFinderView> createState() => _MasjidFinderViewState();
}

class _MasjidFinderViewState extends State<MasjidFinderView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Nearby Masjids',
          style: TextStyle(
            color: textColor,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: background,
        elevation: 0,
        actions: [
          BlocBuilder<MasjidStateCubit, MasjidState>(
            builder: (context, state) {
              if (state is MasjidLoaded) {
                return IconButton(
                  onPressed: state.isRefreshing
                      ? null
                      : () => context.read<MasjidStateCubit>().refreshMasjids(),
                  icon: state.isRefreshing
                      ? SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: primary,
                          ),
                        )
                      : Icon(Icons.refresh, color: textColor, size: 24.sp),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocConsumer<MasjidStateCubit, MasjidState>(
        listener: (context, state) {
          if (state is MasjidError && state.isLocationError) {
            _showLocationPermissionDialog(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is MasjidLoading) {
            return _buildLoadingState();
          }

          if (state is MasjidError && !state.isLocationError) {
            return _buildErrorState(state.message, context);
          }

          if (state is MasjidLoaded) {
            return _buildLoadedState(state, context);
          }

          return _buildInitialState(context);
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return const SingleChildScrollView(child: MasjidLoadingShimmer());
  }

  Widget _buildErrorState(String message, BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(40.r),
              ),
              child: Icon(
                Icons.error_outline,
                color: Colors.red.shade400,
                size: 40.sp,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'Unable to Load Masjids',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            Text(
              message,
              style: TextStyle(
                color: textColor.withOpacity(0.8),
                fontSize: 14.sp,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  context.read<MasjidStateCubit>().retry();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(Icons.refresh, size: 20),
                label: Text(
                  'Try Again',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
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
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              color: primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(40.r),
            ),
            child: Icon(Icons.mosque_outlined, color: primary, size: 40.sp),
          ),
          SizedBox(height: 24.h),
          Text(
            'Find Nearby Masjids',
            style: TextStyle(
              color: textColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'Get prayer locations near you',
            style: TextStyle(
              color: textColor.withOpacity(0.7),
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 32.h),
          ElevatedButton(
            onPressed: () {
              context.read<MasjidStateCubit>().loadNearbyMasjids();
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
              'Find Masjids',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadedState(MasjidLoaded state, BuildContext context) {
    if (state.masjids.isEmpty) {
      return EmptyMasjidsWidget(
        onRefresh: () => context.read<MasjidStateCubit>().refreshMasjids(),
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<MasjidStateCubit>().refreshMasjids(),
      color: primary,
      backgroundColor: grey,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Info
                  Row(
                    children: [
                      Icon(Icons.location_on, color: primary, size: 20.sp),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          'Found ${state.masjids.length} masjids nearby',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Within 5km of your location',
                    style: TextStyle(
                      color: textColor.withOpacity(0.7),
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final masjid = state.masjids[index];
              final cubit = context.read<MasjidStateCubit>();

              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 24.w,
                ).copyWith(bottom: 16.h),
                child: MasjidCard(
                  masjid: masjid,
                  formattedDistance: cubit.formatDistance(masjid.distance),
                  isClosest: index == 0, // First item is closest
                  onTap: () => _handleMasjidTap(context, masjid),
                  onDirectionsTap: () => _handleDirectionsTap(context, masjid),
                ),
              );
            }, childCount: state.masjids.length),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 100.h), // Bottom padding for nav bar
          ),
        ],
      ),
    );
  }

  void _handleMasjidTap(BuildContext context, masjid) async {
    final cubit = context.read<MasjidStateCubit>();
    SnackbarHelper.showInfo(context, 'Opening ${masjid.name} in maps...');

    final success = await cubit.openMasjidInMaps(masjid);

    if (!success && mounted) {
      SnackbarHelper.showError(context, 'Unable to open maps app');
    }
  }

  void _handleDirectionsTap(BuildContext context, masjid) async {
    final cubit = context.read<MasjidStateCubit>();
    SnackbarHelper.showInfo(context, 'Getting directions to ${masjid.name}...');

    final success = await cubit.getDirectionsToMasjid(masjid);

    if (!success && mounted) {
      SnackbarHelper.showError(context, 'Unable to open directions');
    }
  }

  void _showLocationPermissionDialog(BuildContext context, String message) {
    LocationPermissionDialog.show(
      context,
      message: message,
      onRetry: () {
        Navigator.of(context).pop();
        context.read<MasjidStateCubit>().retry();
      },
      onOpenSettings: () {
        Navigator.of(context).pop();
        // Could implement app settings opening here if needed
      },
    );
  }
}
