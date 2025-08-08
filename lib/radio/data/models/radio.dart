class RadioModel {
  final String name;
  final String url;
  final String description;
  final String language;

  const RadioModel({
    required this.name,
    required this.url,
    required this.description,
    required this.language,
  });

  factory RadioModel.fromJson(Map<String, dynamic> json) {
    return RadioModel(
      name: json['name'] ?? '',
      url: json['url'] ?? '',
      description: json['description'] ?? '',
      language: json['language'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
      'description': description,
      'language': language,
    };
  }
}

