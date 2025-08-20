class DuaModel {
  final String id;
  final String title;
  final String arabic;
  final String? transliteration;
  final String translation;
  final String? reference;
  final String category;

  const DuaModel({
    required this.id,
    required this.title,
    required this.arabic,
    this.transliteration,
    required this.translation,
    this.reference,
    required this.category,
  });

  // CopyWith method for immutability
  DuaModel copyWith({
    String? id,
    String? title,
    String? arabic,
    String? transliteration,
    String? translation,
    String? reference,
    String? category,
  }) {
    return DuaModel(
      id: id ?? this.id,
      title: title ?? this.title,
      arabic: arabic ?? this.arabic,
      transliteration: transliteration ?? this.transliteration,
      translation: translation ?? this.translation,
      reference: reference ?? this.reference,
      category: category ?? this.category,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DuaModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'DuaModel(id: $id, title: $title, category: $category)';
  }
}
