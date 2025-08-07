import 'package:azkar/radio/presentation/cubit/radio_state.dart';
import 'package:azkar/radio/presentation/widgets/wave_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../cubit/radio_cubit.dart';
import '../widgets/radio_controls.dart';
import '../widgets/station_info.dart';
import '../../../constants.dart';

class RadioPage extends StatelessWidget {
  const RadioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RadioCubit(),
      child: const RadioPageContent(),
    );
  }
}

class RadioPageContent extends StatelessWidget {
  const RadioPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: scaffoldBackgroundColor,
        elevation: 0,
        title: BlocBuilder<RadioCubit, RadioState>(
          builder: (context, state) {
            return _buildStatusText(state);
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(color: scaffoldBackgroundColor),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Station info
                  const StationInfo(),
                  SizedBox(height: 20.h),
                  // Waveform animation or Islamic pattern
                  const WaveformAnimation(),
                  SizedBox(height: 50.h),
                  // Radio controls
                  const RadioControls(),
                  SizedBox(height: 85.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusText(RadioState state) {
    String statusText = '';
    Color statusColor = textColor;

    if (state is RadioLoading || state is RadioBuffering) {
      statusText = 'Connecting...';
      statusColor = orange;
    } else if (state is RadioPlaying) {
      statusText = 'Live • Now Playing';
      statusColor = primary;
    } else if (state is RadioPaused) {
      statusText = 'Paused';
      statusColor = textColor;
    } else if (state is RadioError) {
      statusText = 'Connection Error';
      statusColor = Colors.red;
    } else {
      statusText = 'Ready to play';
      statusColor = textColor;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (state is RadioPlaying)
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(right: 8),
            decoration: const BoxDecoration(
              color: primary,
              shape: BoxShape.circle,
            ),
          ),
        Text(
          statusText,
          style: TextStyle(
            color: statusColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
