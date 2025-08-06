import 'package:azkar/radio/presentation/cubit/radio_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../cubit/radio_cubit.dart';
import '../../../constants.dart';

class RadioControls extends StatelessWidget {
  const RadioControls({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RadioCubit, RadioState>(
      builder: (context, state) {
        final cubit = context.read<RadioCubit>();

        return Column(
          children: [
            // Station switching controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Previous station button
                _buildControlButton(
                  icon: Icons.skip_previous,
                  onTap: () => cubit.previousStation(),
                  isEnabled: cubit.availableStations.length > 1,
                ),

                // Station selector button
                _buildControlButton(
                  icon: Icons.radio,
                  onTap: () => _showStationSelector(context, cubit),
                  isEnabled: true,
                ),

                // Retry button (only show when error)
                if (state is RadioError)
                  _buildControlButton(
                    icon: Icons.refresh,
                    onTap: () => cubit.retryCurrentStation(),
                    isEnabled: true,
                  )
                else
                  // Next station button
                  _buildControlButton(
                    icon: Icons.skip_next,
                    onTap: () => cubit.nextStation(),
                    isEnabled: cubit.availableStations.length > 1,
                  ),
              ],
            ),

            const SizedBox(height: 28),

            // Main playback controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Stop button
                _buildControlButton(
                  icon: Icons.stop,
                  onTap: state is RadioStopped || state is RadioInitial
                      ? null
                      : () => cubit.stop(),
                  isEnabled: !(state is RadioStopped || state is RadioInitial),
                ),

                // Main play/pause button
                _buildMainControlButton(context, state, cubit),

                // Volume button (placeholder)
                _buildControlButton(
                  icon: Icons.volume_up,
                  onTap: () => _showVolumeSlider(context),
                  isEnabled: true,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildMainControlButton(
    BuildContext context,
    RadioState state,
    RadioCubit cubit,
  ) {
    IconData icon;
    VoidCallback? onTap;
    bool showLoading = false;

    if (state is RadioLoading || state is RadioBuffering) {
      icon = Icons.pause;
      onTap = null;
      showLoading = true;
    } else if (state is RadioPlaying) {
      icon = Icons.pause;
      onTap = cubit.pause;
    } else if (state is RadioPaused) {
      icon = Icons.play_arrow;
      onTap = cubit.resume;
    } else {
      icon = Icons.play_arrow;
      onTap = () => cubit.playStation(cubit.defaultStation);
    }

    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [primary, primary.withOpacity(0.8)]),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(40),
          onTap: onTap,
          child: Center(
            child: showLoading
                ? const CupertinoActivityIndicator(
                    color: Colors.white,
                    radius: 12,
                  )
                : Icon(icon, color: Colors.white, size: 32),
          ),
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback? onTap,
    required bool isEnabled,
  }) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: grey,
        shape: BoxShape.circle,
        border: Border.all(
          color: primary.withOpacity(isEnabled ? 0.3 : 0.1),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: onTap,
          child: Center(
            child: Icon(
              icon,
              color: isEnabled ? Colors.white : textColor.withOpacity(0.5),
              size: 24,
            ),
          ),
        ),
      ),
    );
  }

  void _showStationSelector(BuildContext context, RadioCubit cubit) {
    showModalBottomSheet(
      context: context,
      backgroundColor: grey,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: textColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Icon(Icons.radio, color: primary, size: 24.sp),
                  SizedBox(width: 12.w),
                  Text(
                    'Select Radio Station',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              ...cubit.availableStations.asMap().entries.map((entry) {
                final index = entry.key;
                final station = entry.value;
                final isSelected = index == cubit.currentStationIndex;

                return Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  decoration: BoxDecoration(
                    color: isSelected ? primary.withOpacity(0.2) : background,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isSelected ? primary : textColor.withOpacity(0.2),
                      width: 1.w,
                    ),
                  ),
                  child: ListTile(
                    leading: Icon(
                      isSelected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: isSelected ? primary : textColor,
                      size: 24.sp,
                    ),
                    title: Text(
                      station.name,
                      style: TextStyle(
                        color: isSelected ? primary : Colors.white,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                        fontSize: 14.sp,
                      ),
                    ),
                    subtitle: Text(
                      station.description,
                      style: TextStyle(
                        color: textColor.withOpacity(0.8),
                        fontSize: 12.sp,
                      ),
                    ),
                    trailing: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: primary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        station.language,
                        style: TextStyle(
                          color: primary,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      cubit.switchToStation(index);
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _showVolumeSlider(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: grey,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: textColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Icon(Icons.volume_up, color: primary, size: 24.sp),
                  SizedBox(width: 12.w),
                  Text(
                    'Volume Control',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Text(
                'Use your device volume buttons to control audio',
                style: TextStyle(color: textColor, fontSize: 14.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
