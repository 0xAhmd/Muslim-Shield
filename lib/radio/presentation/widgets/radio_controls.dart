import 'package:azkar/core/connectivity_service.dart';
import 'package:azkar/radio/presentation/cubit/radio_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../cubit/radio_cubit.dart';
import '../../../constants.dart';

class RadioControls extends StatefulWidget {
  const RadioControls({super.key});

  @override
  State<RadioControls> createState() => _RadioControlsState();
}

class _RadioControlsState extends State<RadioControls> {
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
          // Stop radio when connection is lost
          final cubit = context.read<RadioCubit>();
          cubit.stop();

          // Show snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.wifi_off, color: Colors.white, size: 16),
                  SizedBox(width: 8),
                  Text('Connection lost - Radio stopped'),
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

  void _showOfflineMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.wifi_off, color: Colors.white, size: 16),
            SizedBox(width: 8),
            Text('Internet connection required for radio streaming'),
          ],
        ),
        backgroundColor: Colors.red.withOpacity(0.9),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RadioCubit, RadioState>(
      builder: (context, state) {
        final cubit = context.read<RadioCubit>();

        return Column(
          children: [
            // Offline indicator
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
                        'No internet connection - Radio streaming unavailable',
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

            // Station switching controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Previous station button
                _buildControlButton(
                  icon: Icons.skip_previous,
                  onTap: _isConnected && cubit.availableStations.length > 1
                      ? () => cubit.previousStation()
                      : _isConnected
                      ? null
                      : _showOfflineMessage,
                  isEnabled: _isConnected && cubit.availableStations.length > 1,
                ),

                // Station selector button
                _buildControlButton(
                  icon: Icons.radio,
                  onTap: _isConnected
                      ? () => _showStationSelector(context, cubit)
                      : _showOfflineMessage,
                  isEnabled: _isConnected,
                ),

                // Retry button (only show when error) or Next station button
                if (state is RadioError)
                  _buildControlButton(
                    icon: Icons.refresh,
                    onTap: _isConnected
                        ? () => cubit.retryCurrentStation()
                        : _showOfflineMessage,
                    isEnabled: _isConnected,
                  )
                else
                  // Next station button
                  _buildControlButton(
                    icon: Icons.skip_next,
                    onTap: _isConnected && cubit.availableStations.length > 1
                        ? () => cubit.nextStation()
                        : _isConnected
                        ? null
                        : _showOfflineMessage,
                    isEnabled:
                        _isConnected && cubit.availableStations.length > 1,
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
                  onTap:
                      (!_isConnected ||
                          state is RadioStopped ||
                          state is RadioInitial)
                      ? (!_isConnected ? _showOfflineMessage : null)
                      : () => cubit.stop(),
                  isEnabled:
                      _isConnected &&
                      !(state is RadioStopped || state is RadioInitial),
                ),

                // Main play/pause button
                _buildMainControlButton(context, state, cubit),

                // Volume button
                _buildControlButton(
                  icon: Icons.volume_up,
                  onTap: () => _showVolumeSlider(context),
                  isEnabled: true, // Volume slider works offline
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

    if (!_isConnected) {
      icon = Icons.wifi_off;
      onTap = _showOfflineMessage;
    } else if (state is RadioLoading || state is RadioBuffering) {
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
        gradient: LinearGradient(
          colors: _isConnected
              ? [primary, primary.withOpacity(0.8)]
              : [primary.withOpacity(0.3), primary.withOpacity(0.2)],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(_isConnected ? 0.3 : 0.1),
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
                : Icon(
                    icon,
                    color: _isConnected
                        ? Colors.white
                        : Colors.white.withOpacity(0.6),
                    size: 32,
                  ),
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
    final actuallyEnabled = _isConnected && isEnabled;

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: grey,
        shape: BoxShape.circle,
        border: Border.all(
          color: primary.withOpacity(actuallyEnabled ? 0.3 : 0.1),
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
              color: actuallyEnabled
                  ? Colors.white
                  : textColor.withOpacity(0.3),
              size: 24,
            ),
          ),
        ),
      ),
    );
  }

  void _showStationSelector(BuildContext context, RadioCubit cubit) {
    if (!_isConnected) {
      _showOfflineMessage();
      return;
    }

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
                  const Spacer(),
                  if (!_isConnected)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.wifi_off, color: Colors.red, size: 12.sp),
                          SizedBox(width: 4.w),
                          Text(
                            'Offline',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
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
                      color: (_isConnected && isSelected)
                          ? primary
                          : textColor.withOpacity(0.5),
                      size: 24.sp,
                    ),
                    title: Text(
                      station.name,
                      style: TextStyle(
                        color: _isConnected
                            ? (isSelected ? primary : Colors.white)
                            : Colors.white.withOpacity(0.5),
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                        fontSize: 14.sp,
                      ),
                    ),
                    subtitle: Text(
                      station.description,
                      style: TextStyle(
                        color: textColor.withOpacity(_isConnected ? 0.8 : 0.4),
                        fontSize: 12.sp,
                      ),
                    ),
                    trailing: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: primary.withOpacity(_isConnected ? 0.2 : 0.1),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        station.language,
                        style: TextStyle(
                          color: primary.withOpacity(_isConnected ? 1.0 : 0.5),
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    onTap: _isConnected
                        ? () {
                            Navigator.pop(context);
                            cubit.switchToStation(index);
                          }
                        : () {
                            Navigator.pop(context);
                            _showOfflineMessage();
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
              if (!_isConnected) ...[
                SizedBox(height: 12.h),
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Colors.orange.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.orange,
                        size: 16.sp,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          'Volume controls work offline, but radio streaming requires internet connection',
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
              ],
            ],
          ),
        ),
      ),
    );
  }
}
