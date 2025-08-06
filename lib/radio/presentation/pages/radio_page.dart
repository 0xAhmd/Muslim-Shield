import 'package:azkar/radio/presentation/cubit/radio_state.dart';
import 'package:azkar/radio/presentation/widgets/wave_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [scaffoldBackgroundColor, primary.withOpacity(0.1)],
            ),
          ),
          child: Column(
            children: [
              // Header
              _buildHeader(),

              // Main content
              Expanded(
                child: BlocBuilder<RadioCubit, RadioState>(
                  builder: (context, state) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Station info
                        const StationInfo(),

                        const SizedBox(height: 40),

                        // Waveform animation or Islamic pattern
                        const WaveformAnimation(),

                        const SizedBox(height: 60),

                        // Radio controls
                        const RadioControls(),

                        const SizedBox(height: 40),

                        // Status text
                        _buildStatusText(state),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Icon(Icons.radio, color: primary, size: 32),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Radio',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Live Quran broadcast',
                  style: TextStyle(color: textColor, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (state is RadioPlaying)
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(color: primary, shape: BoxShape.circle),
          ),
        Text(
          statusText,
          style: TextStyle(
            color: statusColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
