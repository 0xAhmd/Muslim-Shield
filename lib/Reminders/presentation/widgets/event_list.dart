import 'package:azkar/Reminders/data/models/muslim_event.dart';
import 'package:flutter/material.dart';
import 'package:azkar/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class EventsListWidget extends StatelessWidget {
  final List<MuslimEvent> events;

  const EventsListWidget({
    super.key,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              Icons.event_available,
              size: 48,
              color: textColor.withOpacity(0.5),
            ),
            const SizedBox(height: 12),
            Text(
              'No events today',
              style: GoogleFonts.poppins(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: events.map((event) => _buildEventCard(event)).toList(),
    );
  }

  Widget _buildEventCard(MuslimEvent event) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: gray,
        borderRadius: BorderRadius.circular(12),
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
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _getEventColor(event.type).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _getEventIcon(event.type),
              color: _getEventColor(event.type),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  event.description,
                  style: GoogleFonts.poppins(
                    color: textColor,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 12,
                      color: textColor.withOpacity(0.7),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('MMM dd, yyyy').format(event.date),
                      style: GoogleFonts.poppins(
                        color: textColor.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getEventColor(MuslimEventType type) {
    switch (type) {
      case MuslimEventType.friday:
        return Colors.amber;
      case MuslimEventType.eidFitr:
      case MuslimEventType.eidAdha:
        return Colors.green;
      case MuslimEventType.ramadan:
        return Colors.blue;
      case MuslimEventType.hajj:
        return Colors.purple;
      default:
        return primary;
    }
  }

  IconData _getEventIcon(MuslimEventType type) {
    switch (type) {
      case MuslimEventType.friday:
        return Icons.star;
      case MuslimEventType.eidFitr:
      case MuslimEventType.eidAdha:
        return Icons.celebration;
      case MuslimEventType.ramadan:
        return Icons.nightlight_round;
      case MuslimEventType.hajj:
        return Icons.location_on;
      default:
        return Icons.event;
    }
  }
}