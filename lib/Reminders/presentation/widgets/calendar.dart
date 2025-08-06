import 'package:azkar/Reminders/data/models/muslim_event.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:azkar/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class IslamicCalendarWidget extends StatefulWidget {
  final List<MuslimEvent> events;
  final Function(DateTime) onDaySelected;

  const IslamicCalendarWidget({
    super.key,
    required this.events,
    required this.onDaySelected,
  });

  @override
  State<IslamicCalendarWidget> createState() => _IslamicCalendarWidgetState();
}

class _IslamicCalendarWidgetState extends State<IslamicCalendarWidget> {
  late final ValueNotifier<List<MuslimEvent>> _selectedEvents;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<MuslimEvent> _getEventsForDay(DateTime day) {
    return widget.events.where((event) {
      return isSameDay(event.date, day);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: gray,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TableCalendar<MuslimEvent>(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        eventLoader: _getEventsForDay,
        calendarFormat: CalendarFormat.month,
        startingDayOfWeek: StartingDayOfWeek.sunday,
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          weekendTextStyle: GoogleFonts.poppins(color: textColor),
          holidayTextStyle: GoogleFonts.poppins(color: primary),
          defaultTextStyle: GoogleFonts.poppins(color: textColor),
          selectedTextStyle: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          todayTextStyle: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          selectedDecoration: const BoxDecoration(
            color: primary,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: primary.withOpacity(0.7),
            shape: BoxShape.circle,
          ),
          markerDecoration: const BoxDecoration(
            color: orange,
            shape: BoxShape.circle,
          ),
          tableBorder: TableBorder.all(color: Colors.transparent),
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          leftChevronIcon: const Icon(Icons.chevron_left, color: textColor),
          rightChevronIcon: const Icon(Icons.chevron_right, color: textColor),
          decoration: const BoxDecoration(color: Colors.transparent),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: GoogleFonts.poppins(color: textColor),
          weekendStyle: GoogleFonts.poppins(color: textColor),
        ),
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, day, events) {
            if (events.isNotEmpty) {
              return _buildEventMarkers(events.cast<MuslimEvent>());
            }
            return null;
          },
        ),
        onDaySelected: (selectedDay, focusedDay) {
          if (!isSameDay(_selectedDay, selectedDay)) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
            _selectedEvents.value = _getEventsForDay(selectedDay);
            widget.onDaySelected(selectedDay);
          }
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
      ),
    );
  }

  Widget _buildEventMarkers(List<MuslimEvent> events) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: events.take(3).map((event) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 1),
            child: _getEventIcon(event.type),
          );
        }).toList(),
      ),
    );
  }

  Widget _getEventIcon(MuslimEventType type) {
    IconData iconData;
    Color iconColor;

    switch (type) {
      case MuslimEventType.friday:
        iconData = Icons.star;
        iconColor = Colors.amber;
        break;
      case MuslimEventType.eidFitr:
      case MuslimEventType.eidAdha:
        iconData = Icons.celebration;
        iconColor = Colors.green;
        break;
      case MuslimEventType.ramadan:
        iconData = Icons.nightlight_round;
        iconColor = Colors.blue;
        break;
      default:
        iconData = Icons.event;
        iconColor = orange;
    }

    return Icon(iconData, size: 8, color: iconColor);
  }
}
