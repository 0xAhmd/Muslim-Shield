
import 'package:azkar/tasbih/data/data_source/tasbih_data_source.dart';
import 'package:azkar/tasbih/data/models/tasbih.dart';

class TasbihRepository {
  final TasbihLocalDatasource _localDatasource;

  TasbihRepository(this._localDatasource);

  Future<void> initialize() async {
    await _localDatasource.init();
  }

  List<TasbihModel> getAllTasbih() {
    return _localDatasource.getAllTasbih();
  }

  TasbihModel? getTasbihById(String id) {
    return _localDatasource.getTasbihById(id);
  }

  Future<void> incrementCount(String id) async {
    final tasbih = _localDatasource.getTasbihById(id);
    if (tasbih != null) {
      await _localDatasource.updateTasbihCount(id, tasbih.currentCount + 1);
    }
  }

  Future<void> resetCount(String id) async {
    await _localDatasource.resetTasbihCount(id);
  }

  Future<void> resetAllCounts() async {
    await _localDatasource.resetAllCounts();
  }

  Future<void> setCustomCount(String id, int count) async {
    await _localDatasource.updateTasbihCount(id, count);
  }
}
