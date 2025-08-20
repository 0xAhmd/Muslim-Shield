class SunnahPrayer {
  final String name;
  final int rakaat;
  final String timing;
  final String description;

  const SunnahPrayer({
    required this.name,
    required this.rakaat,
    required this.timing,
    required this.description,
  });
}

class SunnahPrayersConstants {
  static const List<SunnahPrayer> sunnahPrayers = [
    SunnahPrayer(
      name: 'Sunnah before Fajr',
      rakaat: 2,
      timing: 'Before Fajr',
      description: 'Two light Rak\'ah before the Fajr prayer',
    ),
    SunnahPrayer(
      name: 'Sunnah before Dhuhr',
      rakaat: 4,
      timing: 'Before Dhuhr',
      description: 'Four Rak\'ah before the Dhuhr prayer',
    ),
    SunnahPrayer(
      name: 'Sunnah after Dhuhr',
      rakaat: 2,
      timing: 'After Dhuhr',
      description: 'Two Rak\'ah after the Dhuhr prayer',
    ),
    SunnahPrayer(
      name: 'Sunnah after Maghrib',
      rakaat: 2,
      timing: 'After Maghrib',
      description: 'Two Rak\'ah after the Maghrib prayer',
    ),
    SunnahPrayer(
      name: 'Sunnah after Isha',
      rakaat: 2,
      timing: 'After Isha',
      description: 'Two Rak\'ah after the Isha prayer',
    ),
    SunnahPrayer(
      name: 'Witr Prayer',
      rakaat: 3,
      timing: 'After Isha',
      description: 'Three Rak\'ah Witr prayer (odd number)',
    ),
    SunnahPrayer(
      name: 'Tahajjud',
      rakaat: 8,
      timing: 'Last third of night',
      description: 'Night prayer performed in the last third of the night',
    ),
  ];

  static List<SunnahPrayer> getSunnahPrayersForTime(String obligatoryPrayer) {
    switch (obligatoryPrayer.toLowerCase()) {
      case 'fajr':
        return sunnahPrayers
            .where((p) => p.timing.contains('Before Fajr'))
            .toList();
      case 'dhuhr':
        return sunnahPrayers.where((p) => p.timing.contains('Dhuhr')).toList();
      case 'maghrib':
        return sunnahPrayers
            .where((p) => p.timing.contains('After Maghrib'))
            .toList();
      case 'isha':
        return sunnahPrayers
            .where((p) => p.timing.contains('After Isha'))
            .toList();
      default:
        return [];
    }
  }
}
