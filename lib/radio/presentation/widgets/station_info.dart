import 'package:azkar/radio/presentation/cubit/radio_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/radio_cubit.dart';
import '../../../constants.dart';

class StationInfoCard extends StatelessWidget {
  const StationInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RadioCubit, RadioState>(
      builder: (context, state) {
        final cubit = context.read<RadioCubit>();
        final station =
            cubit.currentStation; // Use current station instead of default
        final stationCount = cubit.availableStations.length;
        final currentIndex =
            cubit.currentStationIndex + 1; // 1-based index for display

        return Container(
          // margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: grey,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: primary.withOpacity(0.3), width: 1),
          ),
          child: Column(
            children: [
              // Station counter
              if (stationCount > 1)
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Station $currentIndex of $stationCount',
                    style: TextStyle(
                      color: primary.withOpacity(0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

              // Station name
              Text(
                station.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              // Description
              Text(
                station.description,
                style: TextStyle(
                  color: textColor.withOpacity(0.8),
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // Bottom row with language and station switching hint
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Language badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      station.language,
                      style: const TextStyle(
                        color: primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  // Station switching hint (only show if multiple stations available)
                  if (stationCount > 1)
                    Row(
                      children: [
                        Icon(
                          Icons.swipe_left,
                          color: textColor.withOpacity(0.5),
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Switch stations',
                          style: TextStyle(
                            color: textColor.withOpacity(0.5),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
