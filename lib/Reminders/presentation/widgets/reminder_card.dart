import '../../data/models/reminder_card.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ReminderCardWidget extends StatelessWidget {
  final ReminderCard reminder;
  final VoidCallback? onTap;
  final VoidCallback? onMarkAsRead;

  const ReminderCardWidget({
    super.key,
    required this.reminder,
    this.onTap,
    this.onMarkAsRead,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: grey,
              borderRadius: BorderRadius.circular(12),
              border: reminder.isRead
                  ? null
                  : Border.all(color: _getReminderColor(), width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getReminderColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getReminderIcon(),
                    color: _getReminderColor(),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reminder.title,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        reminder.message,
                        style: GoogleFonts.poppins(
                          color: textColor,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        DateFormat('HH:mm').format(reminder.createdAt),
                        style: GoogleFonts.poppins(
                          color: textColor.withOpacity(0.7),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                if (reminder.actionText != null) ...[
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: onTap,
                    style: TextButton.styleFrom(
                      backgroundColor: _getReminderColor().withOpacity(0.1),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      reminder.actionText!,
                      style: GoogleFonts.poppins(
                        color: _getReminderColor(),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
                if (!reminder.isRead && onMarkAsRead != null) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: onMarkAsRead,
                    icon: const Icon(Icons.check, color: textColor, size: 16),
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getReminderColor() {
    switch (reminder.type) {
      case ReminderType.prayerPassed:
        return Colors.orange;
      case ReminderType.prayerUpcoming:
        return primary;
      case ReminderType.fridaySurah:
        return Colors.amber;
      case ReminderType.eidGreeting:
        return Colors.green;
      case ReminderType.ramadanIftar:
        return Colors.blue;
      case ReminderType.general:
        return textColor;
    }
  }

  IconData _getReminderIcon() {
    switch (reminder.type) {
      case ReminderType.prayerPassed:
        return Icons.access_time;
      case ReminderType.prayerUpcoming:
        return Icons.notifications_active;
      case ReminderType.fridaySurah:
        return Icons.star;
      case ReminderType.eidGreeting:
        return Icons.celebration;
      case ReminderType.ramadanIftar:
        return Icons.nightlight_round;
      case ReminderType.general:
        return Icons.info_outline;
    }
  }
}
