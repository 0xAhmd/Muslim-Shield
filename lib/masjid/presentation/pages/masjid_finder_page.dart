import 'package:azkar/core/connectivity_service.dart';
import 'package:azkar/core/offline_message.dart';
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
  final ConnectivityService _connectivityService = ConnectivityService();
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
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
          // Show snackbar when connection is lost
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.wifi_off, color: Colors.white, size: 16),
                  SizedBox(width: 8),
                  Text('Connection lost'),
                ],
              ),
              backgroundColor: Colors.red.withOpacity(0.9),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    });
  }

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
        backgroundColor: scaffoldBackgroundColor,
        elevation: 0,
        actions: [
          BlocBuilder<MasjidStateCubit, MasjidState>(
            builder: (context, state) {
              if (state is MasjidLoaded) {
                return IconButton(
                  onPressed: (!_isConnected || state.isRefreshing)
                      ? null
                      : () {
                          if (_isConnected) {
                            context.read<MasjidStateCubit>().refreshMasjids();
                          } else {
                            SnackbarHelper.showError(
                              context,
                              'No internet connection',
                            );
                          }
                        },
                  icon: state.isRefreshing
                      ? SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: primary,
                          ),
                        )
                      : Icon(
                          Icons.refresh,
                          color: _isConnected
                              ? textColor
                              : textColor.withOpacity(0.5),
                          size: 24.sp,
                        ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: !_isConnected
          ? OfflineMessageWidget(
              customMessage:
                  'Masjid finder needs internet connectivity to locate nearby masjids.\nPlease make sure you have an internet connection.',
              onRetry: () => _initializeConnectivity(),
            )
          : BlocConsumer<MasjidStateCubit, MasjidState>(
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
                onPressed: _isConnected
                    ? () {
                        context.read<MasjidStateCubit>().retry();
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isConnected
                      ? primary
                      : primary.withOpacity(0.5),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(Icons.refresh, size: 20),
                label: Text(
                  _isConnected ? 'Try Again' : 'No Connection',
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
            onPressed: _isConnected
                ? () {
                    context.read<MasjidStateCubit>().loadNearbyMasjids();
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
              _isConnected ? 'Find Masjids' : 'No Connection',
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
        onRefresh: () {
          _isConnected
              ? () => context.read<MasjidStateCubit>().refreshMasjids()
              : null;
        },
      );
    }

    return RefreshIndicator(
      onRefresh: _isConnected
          ? () => context.read<MasjidStateCubit>().refreshMasjids()
          : () async {
              SnackbarHelper.showError(context, 'No internet connection');
            },
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
                  // Connection status indicator
                  if (!_isConnected)
                    Container(
                      margin: EdgeInsets.only(bottom: 16.h),
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: Colors.red.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.wifi_off, color: Colors.red, size: 16.sp),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              'Offline - Some features may not work',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Header Info
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 0, right: 8),
                        child: Icon(
                          Icons.location_on,
                          color: primary,
                          size: 19.sp,
                        ),
                      ),
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
                  Padding(
                    padding: const EdgeInsets.only(left: 6.0).w,
                    child: Text(
                      'Within 5km of your location',
                      style: TextStyle(
                        color: textColor.withOpacity(0.7),
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
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
                  onTap: _isConnected
                      ? () => _handleMasjidTap(context, masjid)
                      : () => SnackbarHelper.showError(
                          context,
                          'No internet connection',
                        ),
                  onDirectionsTap: _isConnected
                      ? () => _handleDirectionsTap(context, masjid)
                      : () => SnackbarHelper.showError(
                          context,
                          'No internet connection',
                        ),
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
    if (!_isConnected) {
      SnackbarHelper.showError(context, 'No internet connection');
      return;
    }

    final cubit = context.read<MasjidStateCubit>();
    SnackbarHelper.showInfo(context, 'Opening ${masjid.name} in maps...');

    final success = await cubit.openMasjidInMaps(masjid);

    if (!success && mounted) {
      SnackbarHelper.showError(context, 'Unable to open maps app');
    }
  }

  void _handleDirectionsTap(BuildContext context, masjid) async {
    if (!_isConnected) {
      SnackbarHelper.showError(context, 'No internet connection');
      return;
    }

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
        if (_isConnected) {
          context.read<MasjidStateCubit>().retry();
        } else {
          SnackbarHelper.showError(context, 'No internet connection');
        }
      },
      onOpenSettings: () {
        Navigator.of(context).pop();
        // Could implement app settings opening here if needed
      },
    );
  }
}
