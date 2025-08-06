import '../models/muslim_event.dart';
import 'package:intl/intl.dart';

class LocalEventsService {
  // Fixed Islamic dates (these would normally come from an Islamic calendar API)
  static List<MuslimEvent> getLocalEvents(int year) {
    return [
      // Eid al-Fitr (example date - should be calculated based on lunar calendar)
      MuslimEvent(
        id: 'eid_fitr_$year',
        title: 'Eid al-Fitr',
        description: 'Festival of Breaking the Fast',
        date: DateTime(year, 4, 21), // Example date
        type: MuslimEventType.eidFitr,
        iconName: 'celebration',
      ),

      // Eid al-Adha (example date)
      MuslimEvent(
        id: 'eid_adha_$year',
        title: 'Eid al-Adha',
        description: 'Festival of Sacrifice',
        date: DateTime(year, 6, 28), // Example date
        type: MuslimEventType.eidAdha,
        iconName: 'sheep',
      ),

      // Ramadan start (example date)
      MuslimEvent(
        id: 'ramadan_start_$year',
        title: 'Ramadan Begins',
        description: 'Holy month of fasting begins',
        date: DateTime(year, 3, 23), // Example date
        type: MuslimEventType.ramadan,
        iconName: 'crescent_moon',
      ),
    ];
  }

  static List<MuslimEvent> getFridayEvents() {
    final now = DateTime.now();
    final fridays = <MuslimEvent>[];

    // Generate next 12 Fridays
    for (int i = 0; i < 12; i++) {
      final friday = _getNextFriday(now.add(Duration(days: i * 7)));
      fridays.add(
        MuslimEvent(
          id: 'friday_${DateFormat('yyyy_MM_dd').format(friday)}',
          title: 'Jumu\'ah',
          description: 'Read Surah Al-Kahf',
          date: friday,
          type: MuslimEventType.friday,
          iconName: 'star',
          isRecurring: true,
          recurrenceType: RecurrenceType.weekly,
        ),
      );
    }

    return fridays;
  }

  static DateTime _getNextFriday(DateTime from) {
    final daysUntilFriday = (DateTime.friday - from.weekday) % 7;
    return from.add(Duration(days: daysUntilFriday));
  }
}
