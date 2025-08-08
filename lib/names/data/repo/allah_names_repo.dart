import 'package:azkar/names/data/datasources/names_datasources.dart';
import 'package:azkar/names/data/models/names.dart';


class AllahNamesRepository {
  List<AllahName> getAllNames() {
    return AllahNamesData.getAllNames();
  }

  List<AllahName> searchNames(String query) {
    if (query.isEmpty) return getAllNames();
    
    final allNames = getAllNames();
    return allNames.where((name) {
      return name.transliteration.toLowerCase().contains(query.toLowerCase()) ||
             name.meaning.toLowerCase().contains(query.toLowerCase()) ||
             name.arabic.contains(query);
    }).toList();
  }
}

