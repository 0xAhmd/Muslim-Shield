class ZakatResult {
  final double totalAssets;
  final double totalDebts;
  final double netWealth;
  final double nisabThreshold;
  final bool isZakatDue;
  final double zakatAmount;
  final double goldValue;
  final double silverValue;

  ZakatResult({
    required this.totalAssets,
    required this.totalDebts,
    required this.netWealth,
    required this.nisabThreshold,
    required this.isZakatDue,
    required this.zakatAmount,
    required this.goldValue,
    required this.silverValue,
  });

  String get formattedZakatAmount => '\${zakatAmount.toStringAsFixed(2)}';
  String get formattedNetWealth => '\${netWealth.toStringAsFixed(2)}';
  String get formattedNisabThreshold => '\${nisabThreshold.toStringAsFixed(2)}';
}