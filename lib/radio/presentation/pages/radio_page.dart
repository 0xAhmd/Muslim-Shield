// lib/radio/presentation/pages/radio_page.dart
import 'package:azkar/core/connectivity_service.dart';
import 'package:azkar/core/offline_message.dart';
import 'package:azkar/radio/presentation/widgets/station_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants.dart';
import '../cubit/radio_cubit.dart';
import '../cubit/radio_state.dart';
import '../widgets/radio_controls.dart';

class RadioPage extends StatefulWidget {
  const RadioPage({super.key});

  @override
  State<RadioPage> createState() => _RadioPageState();
}

class _RadioPageState extends State<RadioPage> {
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
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RadioCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Islamic Radio',
            style: TextStyle(
              color: textColor,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: scaffoldBackgroundColor,
          elevation: 0,
          actions: [
            // Connection status indicator in app bar
            Container(
              margin: EdgeInsets.only(right: 16.w),
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: (_isConnected ? Colors.green : Colors.red).withOpacity(
                  0.2,
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _isConnected ? Icons.wifi : Icons.wifi_off,
                    color: _isConnected ? Colors.green : Colors.red,
                    size: 14.sp,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    _isConnected ? 'Online' : 'Offline',
                    style: TextStyle(
                      color: _isConnected ? Colors.green : Colors.red,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: !_isConnected
            ? OfflineMessageWidget(
                customMessage:
                    'Islamic Radio requires internet connectivity for streaming.\nPlease make sure you have an internet connection.',
                onRetry: () => _initializeConnectivity(),
              )
            : BlocBuilder<RadioCubit, RadioState>(
                builder: (context, state) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      children: [
                        // Station Info Card
                        const StationInfoCard(),

                        SizedBox(height: 32.h),

                        // Radio Controls
                        const RadioControls(),

                        SizedBox(height: 32.h),

                        // Status Information
                        _buildStatusInfo(state),

                        SizedBox(height: 100.h), // Bottom padding for nav bar
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildStatusInfo(RadioState state) {
    String statusText;
    Color statusColor;
    IconData statusIcon;

    if (state is RadioInitial) {
      statusText = 'Ready to stream';
      statusColor = textColor;
      statusIcon = Icons.radio;
    } else if (state is RadioLoading) {
      statusText = 'Connecting to station...';
      statusColor = Colors.orange;
      statusIcon = Icons.connecting_airports;
    } else if (state is RadioBuffering) {
      statusText = 'Buffering...';
      statusColor = Colors.orange;
      statusIcon = Icons.hourglass_empty;
    } else if (state is RadioPlaying) {
      statusText = 'Now streaming';
      statusColor = Colors.green;
      statusIcon = Icons.radio;
    } else if (state is RadioPaused) {
      statusText = 'Paused';
      statusColor = Colors.blue;
      statusIcon = Icons.pause_circle;
    } else if (state is RadioStopped) {
      statusText = 'Stopped';
      statusColor = textColor;
      statusIcon = Icons.stop_circle;
    } else if (state is RadioError) {
      statusText = 'Error: ${state.message}';
      statusColor = Colors.red;
      statusIcon = Icons.error;
    } else {
      statusText = 'Unknown status';
      statusColor = textColor;
      statusIcon = Icons.help;
    }

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(statusIcon, color: statusColor, size: 20.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              statusText,
              style: GoogleFonts.poppins(
                color: statusColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
