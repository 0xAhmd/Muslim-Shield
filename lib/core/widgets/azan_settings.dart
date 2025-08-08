import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constants.dart';
import '../../Reminders/data/services/notification_service.dart';

class AdhanSettingsWidget extends StatefulWidget {
  const AdhanSettingsWidget({super.key});

  @override
  State<AdhanSettingsWidget> createState() => _AdhanSettingsWidgetState();
}

class _AdhanSettingsWidgetState extends State<AdhanSettingsWidget> {
  final NotificationService _notificationService = NotificationService();
  bool _isAdhanEnabled = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAdhanStatus();
  }

  Future<void> _loadAdhanStatus() async {
    try {
      // Initialize the service first
      await _notificationService.initialize();
      
      final isEnabled = await _notificationService.isAdhanEnabled();
      if (mounted) {
        setState(() {
          _isAdhanEnabled = isEnabled;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        
        // Show a less intrusive error message
        print('Could not load Adhan status: $e');
      }
    }
  }

  Future<void> _toggleAdhan(bool enabled) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Ensure service is initialized
      await _notificationService.initialize();
      
      if (enabled) {
        await _notificationService.enableAdhanNotifications();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white, size: 16),
                  SizedBox(width: 8),
                  Text('Adhan notifications enabled'),
                ],
              ),
              backgroundColor: Colors.green.withOpacity(0.9),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } else {
        await _notificationService.disableAdhanNotifications();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.notifications_off, color: Colors.white, size: 16),
                  SizedBox(width: 8),
                  Text('Adhan notifications disabled'),
                ],
              ),
              backgroundColor: Colors.orange.withOpacity(0.9),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }

      if (mounted) {
        setState(() {
          _isAdhanEnabled = enabled;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Permission required. Please allow notifications in system settings.'),
            backgroundColor: Colors.orange.withOpacity(0.9),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'Settings',
              textColor: Colors.white,
              onPressed: () {
                // This would ideally open app settings
                print('Open app settings for notifications');
              },
            ),
          ),
        );
      }
    }
  }

  Future<void> _testAdhan() async {
    try {
      await _notificationService.testAdhanNotification();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.volume_up, color: Colors.white, size: 16),
                SizedBox(width: 8),
                Text('Test Adhan notification sent'),
              ],
            ),
            backgroundColor: primary.withOpacity(0.9),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error testing Adhan: ${e.toString()}'),
            backgroundColor: Colors.red.withOpacity(0.9),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(24.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: grey,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.volume_up,
                  color: primary,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                'Adhan Notifications',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Description
          Text(
            'Get notified with Adhan call at each prayer time. The app will play the Adhan sound when prayer time arrives.',
            style: TextStyle(
              color: textColor.withOpacity(0.8),
              fontSize: 14.sp,
              height: 1.4,
            ),
          ),

          SizedBox(height: 20.h),

          // Enable/Disable Toggle
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: _isAdhanEnabled ? primary.withOpacity(0.3) : Colors.transparent,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enable Adhan',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      _isAdhanEnabled ? 'Active' : 'Disabled',
                      style: TextStyle(
                        color: _isAdhanEnabled ? Colors.green : textColor.withOpacity(0.7),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                _isLoading
                    ? SizedBox(
                        width: 20.w,
                        height: 20.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:  AlwaysStoppedAnimation<Color>(primary),
                        ),
                      )
                    : Switch(
                        value: _isAdhanEnabled,
                        onChanged: _toggleAdhan,
                        activeColor: primary,
                        activeTrackColor: primary.withOpacity(0.3),
                        inactiveThumbColor: textColor.withOpacity(0.5),
                        inactiveTrackColor: textColor.withOpacity(0.1),
                      ),
              ],
            ),
          ),

          SizedBox(height: 16.h),

          // Test Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isAdhanEnabled ? _testAdhan : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isAdhanEnabled 
                    ? primary.withOpacity(0.9)
                    : textColor.withOpacity(0.1),
                foregroundColor: _isAdhanEnabled ? Colors.white : textColor.withOpacity(0.5),
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
              ),
              icon: Icon(Icons.play_arrow, size: 18.sp),
              label: Text(
                'Test Adhan Sound',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          SizedBox(height: 12.h),

          // Info note
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: Colors.blue.withOpacity(0.2),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.blue,
                  size: 16.sp,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'Adhan will play automatically at prayer times even when the app is closed. Make sure your device allows notifications.',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 12.sp,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}