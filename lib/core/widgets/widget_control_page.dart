import 'package:azkar/core/widgets/home_widget_service.dart';
import 'package:azkar/core/widgets/next_prayer_widget_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  bool _isRefreshingPrayer = false; // Separate state for refresh operation
  late PrayerTimesCubit _prayerCubit;

  @override
  void initState() {
    super.initState();
    // Create a dedicated cubit instance for this page
    _prayerCubit = PrayerTimesCubit(
      PrayerRepositoryImpl(PrayerApiServiceFactory.create()),
    );
  }

  @override
  void dispose() {
    _prayerCubit.close();
    super.dispose();
  }

  Future<void> _updateDuaWidget() async {
    if (_isUpdatingDua) return; // Prevent multiple simultaneous updates
    
    setState(() {
      _isUpdatingDua = true;
    });

    try {
      debugPrint('WidgetControlPage: Updating Dua widget...');
      await WidgetService.updateWidgetWithRandomDua();
      
      // Also trigger Android widget update
      await _triggerAndroidWidgetUpdate();

      if (mounted) {
        _showNotification(
          message: 'Dua widget updated successfully!',
          icon: Icons.check_circle,
          color: primary,
        );
      }
      debugPrint('WidgetControlPage: Dua widget updated successfully');
    } catch (e) {
      debugPrint('WidgetControlPage: Error updating Dua widget: $e');
      if (mounted) {
        _showNotification(
          message: 'Failed to update Dua widget: ${e.toString()}',
          icon: Icons.error,
          color: Colors.red,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUpdatingDua = false;
        });
      }
    }
  }

  Future<void> _updateNextPrayerWidget() async {
    if (_isUpdatingPrayer) return; // Prevent multiple simultaneous updates
    
    setState(() {
      _isUpdatingPrayer = true;
    });

    try {
      debugPrint('WidgetControlPage: Updating Next Prayer widget with existing data...');
      final currentState = _prayerCubit.state;

      if (currentState is PrayerTimesLoaded) {
        // Use existing prayer data
        debugPrint('WidgetControlPage: Found loaded prayer data, updating widget...');
        debugPrint('WidgetControlPage: Current next prayer: ${currentState.nextPrayer?.name} at ${currentState.nextPrayer?.time}');
        debugPrint('WidgetControlPage: Location: ${currentState.location.cityName}, ${currentState.location.countryName}');
        debugPrint('WidgetControlPage: Prayer list length: ${currentState.prayersList.length}');
        
        // Log all prayers for debugging
        for (int i = 0; i < currentState.prayersList.length; i++) {
          debugPrint('WidgetControlPage: Prayer $i: ${currentState.prayersList[i].name} at ${currentState.prayersList[i].time}');
        }
        
        // Update widget with the EXACT same data that's in the state
        await NextPrayerWidgetService.updateWidgetWithNextPrayer(
          nextPrayer: currentState.nextPrayer,
          location: '${currentState.location.cityName}, ${currentState.location.countryName}',
          lastUpdated: DateTime.now().toIso8601String(),
        );

        if (mounted) {
          _showNotification(
            message: 'Next Prayer widget updated with current data!',
            icon: Icons.check_circle,
            color: primary,
          );
        }
        debugPrint('WidgetControlPage: Next Prayer widget updated successfully');
      } else {
        // No prayer data available, show appropriate message
        debugPrint('WidgetControlPage: No prayer data available, current state: ${currentState.runtimeType}');
        if (mounted) {
          _showNotification(
            message: 'Please click "Refresh" first to load prayer data',
            icon: Icons.info,
            color: orange,
          );
        }
      }
    } catch (e) {
      debugPrint('WidgetControlPage: Error updating Next Prayer widget: $e');
      if (mounted) {
        _showNotification(
          message: 'Failed to update Next Prayer widget: ${e.toString()}',
          icon: Icons.error,
          color: Colors.red,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUpdatingPrayer = false;
        });
      }
    }
  }

  Future<void> _refreshPrayerData() async {
    if (_isRefreshingPrayer) return; // Prevent multiple simultaneous refreshes
    
    setState(() {
      _isRefreshingPrayer = true;
    });

    try {
      debugPrint('WidgetControlPage: Starting prayer data refresh...');
      
      // Force refresh prayer times
      await _prayerCubit.fetchPrayerTimes();

      // Since we're using BlocBuilder, we don't need to manually wait for state changes
      // The UI will automatically update when the state changes
      
      debugPrint('WidgetControlPage: Prayer refresh request sent');
      
    } catch (e) {
      debugPrint('WidgetControlPage: Exception during prayer refresh: $e');
      if (mounted) {
        setState(() {
          _isRefreshingPrayer = false;
        });
        _showNotification(
          message: 'Failed to refresh prayer data: ${e.toString()}',
          icon: Icons.error,
          color: Colors.red,
        );
      }
    }
    // Note: We don't set _isRefreshingPrayer = false here because the BlocListener will handle it
  }

  Future<void> _triggerAndroidWidgetUpdate() async {
    try {
      const platform = MethodChannel('com.example.azkar/widget_service');
      await platform.invokeMethod('updateDuaWidget');
      debugPrint('WidgetControlPage: Android widget update triggered');
    } catch (e) {
      debugPrint('WidgetControlPage: Error triggering Android widget update: $e');
    }
  }

  void _showNotification({
    required String message,
    required IconData icon,
    required Color color,
  }) {
    debugPrint('WidgetControlPage: Showing notification: $message');
    
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontSize: 14),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.fixed,
        duration: const Duration(seconds: 4),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
        ),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _prayerCubit,
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: const Text('Widget Settings'),
        ),
        body: BlocListener<PrayerTimesCubit, PrayerTimesState>(
          listener: (context, state) {
            // Handle state changes for refresh operation
            if (state is PrayerTimesLoaded && _isRefreshingPrayer) {
              setState(() {
                _isRefreshingPrayer = false;
              });
              
              debugPrint('WidgetControlPage: Prayer data refresh completed successfully');
              _showNotification(
                message: 'Prayer times refreshed and widget updated!',
                icon: Icons.refresh,
                color: primary,
              );
              
            } else if (state is PrayerTimesError && _isRefreshingPrayer) {
              setState(() {
                _isRefreshingPrayer = false;
              });
              
              debugPrint('WidgetControlPage: Prayer data refresh failed: ${state.message}');
              _showNotification(
                message: 'Failed to fetch prayer times: ${state.message}',
                icon: Icons.error,
                color: Colors.red,
              );
            }
          },
          child: SingleChildScrollView(
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
                _buildDuaWidgetCard(),
                const SizedBox(height: 16),

                // Next Prayer Widget Card
                _buildPrayerWidgetCard(),
                const SizedBox(height: 24),

                // Info Card
                _buildInfoCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDuaWidgetCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
            'Random Dua Widget',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            '(Auto-Updates Every 10min)',
            style: TextStyle(color: primary, fontSize: 12),
          ),
          const SizedBox(height: 8),
          const Text(
            'Displays random Duas on your home screen and automatically updates with new content every 10 minutes',
            style: TextStyle(color: textColor, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isUpdatingDua ? null : _updateDuaWidget,
              icon: _isUpdatingDua
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                  : const Icon(Icons.refresh),
              label: Text(_isUpdatingDua ? 'Updating...' : 'Update Now'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
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
    );
  }

  Widget _buildPrayerWidgetCard() {
    return Container(
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

          // Prayer Status Display
          BlocBuilder<PrayerTimesCubit, PrayerTimesState>(
            builder: (context, state) {
              return _buildPrayerStatusCard(state);
            },
          ),

          const SizedBox(height: 16),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: (_isUpdatingPrayer || _isRefreshingPrayer) ? null : _updateNextPrayerWidget,
                  icon: _isUpdatingPrayer
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : const Icon(Icons.update),
                  label: Text(_isUpdatingPrayer ? 'Updating...' : 'Update'),
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
                  onPressed: (_isUpdatingPrayer || _isRefreshingPrayer) ? null : _refreshPrayerData,
                  icon: _isRefreshingPrayer 
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : const Icon(Icons.refresh),
                  label: Text(_isRefreshingPrayer ? 'Refreshing...' : 'Refresh'),
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
    );
  }

  Widget _buildPrayerStatusCard(PrayerTimesState state) {
    if (state is PrayerTimesLoaded) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.green.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Next: ${state.nextPrayer?.name ?? 'Unknown'} at ${state.nextPrayer?.time ?? 'Unknown'}',
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '📍 ${state.location.cityName}, ${state.location.countryName}',
              style: TextStyle(
                color: Colors.green.withOpacity(0.8),
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Total prayers loaded: ${state.prayersList.length}',
              style: TextStyle(
                color: Colors.green.withOpacity(0.6),
                fontSize: 10,
              ),
            ),
          ],
        ),
      );
    } else if (state is PrayerTimesError) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.error, color: Colors.red, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Error: ${state.message}',
                style: const TextStyle(color: Colors.red, fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    } else if (state is PrayerTimesLoading) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue.withOpacity(0.3)),
        ),
        child: const Row(
          children: [
            SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(Colors.blue),
              ),
            ),
            SizedBox(width: 8),
            Text(
              'Loading prayer data...',
              style: TextStyle(color: Colors.blue, fontSize: 12),
            ),
          ],
        ),
      );
    }

    // Initial state - no data loaded yet
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: const Row(
        children: [
          Icon(Icons.info, color: Colors.orange, size: 16),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'No prayer data loaded. Click "Refresh" to load prayer times.',
              style: TextStyle(color: Colors.orange, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
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
                style: TextStyle(color: orange, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            '• Dua widget updates automatically every 10 minutes with fresh content\n'
            '• Next Prayer widget shows countdown to next prayer\n'
            '• Widgets continue updating even when app is closed\n'
            '• Manual updates available through this page\n\n'
            '🔄 Troubleshooting:\n'
            '• If widgets aren\'t updating, try clicking "Update Now"\n'
            '• For prayer widget, click "Refresh" first to load fresh data\n'
            '• Ensure location services are enabled for accurate prayer times',
            style: TextStyle(color: textColor, fontSize: 14, height: 1.4),
          ),
        ],
      ),
    );
  }
}