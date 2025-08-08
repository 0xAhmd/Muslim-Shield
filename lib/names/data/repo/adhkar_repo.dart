import 'package:azkar/names/data/datasources/adhkar_datasources.dart';

import '../models/adhkar.dart';

class AdhkarRepository {
  List<Adhkar> getMorningAdhkar() {
    return AdhkarData.getMorningAdhkar();
  }

  List<Adhkar> getEveningAdhkar() {
    return AdhkarData.getEveningAdhkar();
  }

  List<Adhkar> searchAdhkar(List<Adhkar> adhkar, String query) {
    if (query.isEmpty) return adhkar;
    
    return adhkar.where((item) {
      return item.transliteration.toLowerCase().contains(query.toLowerCase()) ||
             item.translation.toLowerCase().contains(query.toLowerCase()) ||
             item.arabic.contains(query);
    }).toList();
  }
}

