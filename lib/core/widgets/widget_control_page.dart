import 'package:azkar/core/widgets/home_widget_service.dart';
import 'package:azkar/core/widgets/next_prayer_widget_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../constants.dart';
import '../../prayer/presentation/cubit/prayer_cubit.dart';
import '../../prayer/presentation/cubit/prayer_state.dart';
import '../../prayer/data/repo/prayer_repo.dart';
import '../../prayer/data/service/prayer_api_service.dart';

class WidgetControlPage extends StatefulWidget {
  const WidgetControlPage({super.key});

  @override
  State<WidgetControlPage> createState() => _WidgetControlPageState();
}

class _WidgetControlPageState extends State<WidgetControlPage> {
  bool _isUpdatingDua = false;
  bool _isUpdatingPrayer = false;

  Future<void> _updateDuaWidget() async {
    setState(() {
      _isUpdatingDua = true;
    });

    try {
      await WidgetService.updateWidgetWithRandomDua();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white, size: 16),
                SizedBox(width: 8),
                Text('Dua widget updated! Auto-updates every 10 minutes.'),
              ],
            ),
            backgroundColor: primary,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update Dua widget: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }

    setState(() {
      _isUpdatingDua = false;
    });
  }

  Future<void> _updateNextPrayerWidget() async {
    setState(() {
      _isUpdatingPrayer = true;
    });

    try {
      // Try to get current prayer data from the prayer cubit if available
      final prayerCubit = context.read<PrayerTimesCubit>();
      final currentState = prayerCubit.state;

      if (currentState is PrayerTimesLoaded) {
        // Use existing prayer data
        await prayerCubit.updateNextPrayerWidget();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white, size: 16),
                  SizedBox(width: 8),
                  Text('Next Prayer widget updated with current data!'),
                ],
              ),
              backgroundColor: primary,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } else {
        // No prayer data available, fetch it
        await prayerCubit.fetchPrayerTimes();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  Icon(Icons.info, color: Colors.white, size: 16),
                  SizedBox(width: 8),
                  Text('Fetching prayer times and updating widget...'),
                ],
              ),
              backgroundColor: orange,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      // If prayer cubit is not available or fails, update with default data
      try {
        await NextPrayerWidgetService.updateWidgetWithNextPrayer(
          nextPrayer: null,
          location: 'Please open Prayer Times first',
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  Icon(Icons.warning, color: Colors.white, size: 16),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Widget updated with default data. Please open Prayer Times for accurate information.',
                    ),
                  ),
                ],
              ),
              backgroundColor: orange,
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 4),
            ),
          );
        }
      } catch (e2) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to update Next Prayer widget: $e2'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }

    setState(() {
      _isUpdatingPrayer = false;
    });
  }

  Future<void> _refreshPrayerData() async {
    setState(() {
      _isUpdatingPrayer = true;
    });

    try {
      final prayerCubit = context.read<PrayerTimesCubit>();
      await prayerCubit.refreshPrayerTimes();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.refresh, color: Colors.white, size: 16),
                SizedBox(width: 8),
                Text('Prayer times refreshed and widget updated!'),
              ],
            ),
            backgroundColor: primary,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to refresh prayer data: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }

    setState(() {
      _isUpdatingPrayer = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PrayerTimesCubit(
        PrayerRepositoryImpl(PrayerApiServiceFactory.create()),
      ),
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: const Text('Widget Settings'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Home Screen Widgets',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Manage your home screen widgets. Update them with fresh content or refresh prayer times.',
                style: TextStyle(color: textColor, fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 32),

              // Dua Widget Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: grey,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: primary.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.auto_awesome, color: primary, size: 48),
                    const SizedBox(height: 16),
                    const Text(
                      'Random Dua Widget (Auto-Updates Every 10min)',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Displays random Duas on your home screen and automatically updates with new content every 10 minutes',
                      style: TextStyle(color: textColor, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                    ElevatedButton.icon(
                      onPressed: _isUpdatingDua ? null : _updateDuaWidget,
                      icon: _isUpdatingDua
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Icon(Icons.refresh),
                      label: Text(
                        _isUpdatingDua ? 'Updating...' : 'Update Now',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Next Prayer Widget Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: grey,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: orange.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.schedule, color: orange, size: 48),
                    const SizedBox(height: 16),
                    const Text(
                      'Next Prayer Widget',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Shows next prayer time with countdown on your home screen',
                      style: TextStyle(color: textColor, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                    // Show current prayer status
                    BlocBuilder<PrayerTimesCubit, PrayerTimesState>(
                      builder: (context, state) {
                        if (state is PrayerTimesLoaded) {
                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.green.withOpacity(0.3),
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Current: ${state.nextPrayer?.name ?? 'Unknown'} at ${state.nextPrayer?.time ?? 'Unknown'}',
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  '${state.location.cityName}, ${state.location.countryName}',
                                  style: TextStyle(
                                    color: Colors.green.withOpacity(0.8),
                                    fontSize: 10,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        } else if (state is PrayerTimesError) {
                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.red.withOpacity(0.3),
                              ),
                            ),
                            child: const Text(
                              'No prayer data available',
                              style: TextStyle(color: Colors.red, fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                          );
                        } else if (state is PrayerTimesLoading) {
                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.blue.withOpacity(0.3),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 12,
                                  height: 12,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation(
                                      Colors.blue,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Loading prayer data...',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _isUpdatingPrayer
                                ? null
                                : _updateNextPrayerWidget,
                            icon: _isUpdatingPrayer
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Icon(Icons.update),
                            label: Text(
                              _isUpdatingPrayer ? 'Updating...' : 'Update',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: orange,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _isUpdatingPrayer
                                ? null
                                : _refreshPrayerData,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Refresh'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info, color: orange, size: 16),
                        SizedBox(width: 8),
                        Text(
                          'Widget Features',
                          style: TextStyle(
                            color: orange,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      '• Dua widget updates automatically every 10 minutes with fresh content\n'
                      '• Next Prayer widget updates based on prayer times\n'
                      '• Widgets continue updating even when app is closed\n'
                      '• Manual updates available through this page\n\n'
                      'Note: For Next Prayer widget, make sure to open Prayer Times page first to get accurate prayer data.',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
