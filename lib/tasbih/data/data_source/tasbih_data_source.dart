import '../models/tasbih.dart';
import 'package:hive/hive.dart';

class TasbihLocalDatasource {
  static const String _boxName = 'tasbih_box';
  late Box<TasbihModel> _box;

  Future<void> init() async {
    _box = await Hive.openBox<TasbihModel>(_boxName);
    
    // Initialize with default dhikr if empty
    if (_box.isEmpty) {
      await _initializeDefaultTasbih();
    }
  }

  Future<void> _initializeDefaultTasbih() async {
    final defaultTasbih = [
      TasbihModel(
        id: '1',
        title: 'Subhan Allah',
        arabicText: 'سُبْحَانَ اللّٰهِ',
        transliteration: 'Subhan Allah',
        translation: 'Glory be to Allah',
        targetCount: 33,
        lastUpdated: DateTime.now(),
      ),
      TasbihModel(
        id: '2',
        title: 'Alhamdulillah',
        arabicText: 'الْحَمْدُ لِلّٰهِ',
        transliteration: 'Alhamdulillahi',
        translation: 'All praise is due to Allah',
        targetCount: 33,
        lastUpdated: DateTime.now(),
      ),
      TasbihModel(
        id: '3',
        title: 'Allahu Akbar',
        arabicText: 'اللّٰهُ أَكْبَرُ',
        transliteration: 'Allahu Akbar',
        translation: 'Allah is the Greatest',
        targetCount: 34,
        lastUpdated: DateTime.now(),
      ),
      TasbihModel(
        id: '4',
        title: 'La ilaha illa Allah',
        arabicText: 'لَا إِلٰهَ إِلَّا اللّٰهُ',
        transliteration: 'La ilaha illa Allah',
        translation: 'There is no god but Allah',
        targetCount: 100,
        lastUpdated: DateTime.now(),
      ),
    ];

    for (final tasbih in defaultTasbih) {
      await _box.put(tasbih.id, tasbih);
    }
  }

  List<TasbihModel> getAllTasbih() {
    return _box.values.toList();
  }

  TasbihModel? getTasbihById(String id) {
    return _box.get(id);
  }

  Future<void> updateTasbihCount(String id, int newCount) async {
    final tasbih = _box.get(id);
    if (tasbih != null) {
      final updatedTasbih = tasbih.copyWith(
        currentCount: newCount,
        lastUpdated: DateTime.now(),
      );
      await _box.put(id, updatedTasbih);
    }
  }

  Future<void> resetTasbihCount(String id) async {
    await updateTasbihCount(id, 0);
  }

  Future<void> resetAllCounts() async {
    for (final tasbih in _box.values) {
      await updateTasbihCount(tasbih.id, 0);
    }
  }
}