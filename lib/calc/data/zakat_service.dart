import 'dart:math' as math;

import 'package:azkar/calc/data/nisab.dart';
import 'package:azkar/calc/data/zakat.dart';

class ZakatService {
  // Nisab thresholds (in grams)
  static const double goldNisab = 87.48; // grams
  static const double silverNisab = 612.36; // grams
  
  // Current prices (these could be fetched from an API in future)
  static const double goldPricePerGram = 60.0; // USD per gram
  static const double silverPricePerGram = 0.8; // USD per gram
  static const double zakatRate = 0.025; // 2.5%

  /// Calculate the total zakat amount based on provided assets and debts
  static ZakatResult calculateZakat({
    required double cash,
    required double savings,
    required double goldGrams,
    required double silverGrams,
    required double investments,
    required double debts,
  }) {
    // Convert precious metals to monetary value
    final double goldValue = goldGrams * goldPricePerGram;
    final double silverValue = silverGrams * silverPricePerGram;
    
    // Calculate total wealth
    final double totalAssets = cash + savings + goldValue + silverValue + investments;
    final double netWealth = math.max(0, totalAssets - debts);
    
    // Calculate nisab threshold (use the lower of gold or silver nisab)
    const double goldNisabValue = goldNisab * goldPricePerGram;
    const double silverNisabValue = silverNisab * silverPricePerGram;
    final double nisabThreshold = math.min(goldNisabValue, silverNisabValue);
    
    // Determine if zakat is due
    final bool isZakatDue = netWealth >= nisabThreshold;
    final double zakatAmount = isZakatDue ? netWealth * zakatRate : 0.0;
    
    return ZakatResult(
      totalAssets: totalAssets,
      totalDebts: debts,
      netWealth: netWealth,
      nisabThreshold: nisabThreshold,
      isZakatDue: isZakatDue,
      zakatAmount: zakatAmount,
      goldValue: goldValue,
      silverValue: silverValue,
    );
  }

  /// Get information about current nisab thresholds
  static NisabInfo getNisabInfo() {
    return NisabInfo(
      goldNisabGrams: goldNisab,
      silverNisabGrams: silverNisab,
      goldNisabValue: goldNisab * goldPricePerGram,
      silverNisabValue: silverNisab * silverPricePerGram,
      goldPricePerGram: goldPricePerGram,
      silverPricePerGram: silverPricePerGram,
    );
  }
}
