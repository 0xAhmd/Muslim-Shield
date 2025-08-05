import 'package:shared_preferences/shared_preferences.dart';

class AudioPreferences {
  int _selectedReciterId = 1;
  String _selectedReciterName = 'AbdulBaset AbdulSamad';

  int get selectedReciterId => _selectedReciterId;
  String get selectedReciterName => _selectedReciterName;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedReciterId = prefs.getInt('selected_reciter_id') ?? 1;
    _selectedReciterName =
        prefs.getString('selected_reciter_name') ?? 'AbdulBaset AbdulSamad';
  }

  Future<void> setReciter(int reciterId, String reciterName) async {
    _selectedReciterId = reciterId;
    _selectedReciterName = reciterName;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selected_reciter_id', reciterId);
    await prefs.setString('selected_reciter_name', reciterName);
  }
}
