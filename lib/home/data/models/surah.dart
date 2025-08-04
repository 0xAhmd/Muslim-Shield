import 'package:json_annotation/json_annotation.dart';

part 'surah.g.dart';

@JsonSerializable()
class Surah {
  final int number;
  final String name;
  final String englishName;
  final String englishNameTranslation;
  final int numberOfAyahs;
  final String revelationType;

  Surah({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.numberOfAyahs,
    required this.revelationType,
  });

  factory Surah.fromJson(Map<String, dynamic> json) => _$SurahFromJson(json);
  Map<String, dynamic> toJson() => _$SurahToJson(this);
}

@JsonSerializable()
class SurahsResponse {
  final int code;
  final String status;
  final List<Surah> data;

  SurahsResponse({
    required this.code,
    required this.status,
    required this.data,
  });

  factory SurahsResponse.fromJson(Map<String, dynamic> json) =>
      _$SurahsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SurahsResponseToJson(this);
}

@JsonSerializable()
class Ayah {
  final int number;
  final String text;
  final int numberInSurah;
  final int juz;
  final int manzil;
  final int page;
  final int ruku;
  final int hizbQuarter;
  final bool sajda;

  Ayah({
    required this.number,
    required this.text,
    required this.numberInSurah,
    required this.juz,
    required this.manzil,
    required this.page,
    required this.ruku,
    required this.hizbQuarter,
    required this.sajda,
  });

  factory Ayah.fromJson(Map<String, dynamic> json) => _$AyahFromJson(json);
  Map<String, dynamic> toJson() => _$AyahToJson(this);
}

@JsonSerializable()
class SurahDetail {
  final int number;
  final String name;
  final String englishName;
  final String englishNameTranslation;
  final String revelationType;
  final int numberOfAyahs;
  final List<Ayah> ayahs;

  SurahDetail({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.revelationType,
    required this.numberOfAyahs,
    required this.ayahs,
  });

  factory SurahDetail.fromJson(Map<String, dynamic> json) =>
      _$SurahDetailFromJson(json);
  Map<String, dynamic> toJson() => _$SurahDetailToJson(this);
}

@JsonSerializable()
class SurahDetailResponse {
  final int code;
  final String status;
  final SurahDetail data;

  SurahDetailResponse({
    required this.code,
    required this.status,
    required this.data,
  });

  factory SurahDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$SurahDetailResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SurahDetailResponseToJson(this);
}

// New models for audio support
@JsonSerializable()
class Reciter {
  final int id;
  final String name;
  final String style;
  final String url;
  @JsonKey(name: 'file_formats')
  final List<String> fileFormats;

  Reciter({
    required this.id,
    required this.name,
    required this.style,
    required this.url,
    required this.fileFormats,
  });

  factory Reciter.fromJson(Map<String, dynamic> json) {
    try {
      // Add debugging to see what's in the JSON
      print('Parsing reciter JSON: $json');
      print('JSON keys: ${json.keys}');
      print('ID type: ${json['id'].runtimeType}');
      print('Name type: ${json['name'].runtimeType}');

      return _$ReciterFromJson(json);
    } catch (e, stackTrace) {
      print('Error parsing Reciter JSON: $e');
      print('JSON was: $json');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => _$ReciterToJson(this);
}

@JsonSerializable()
class AudioAyah {
  final int verse;
  final String url;

  AudioAyah({required this.verse, required this.url});

  factory AudioAyah.fromJson(Map<String, dynamic> json) =>
      _$AudioAyahFromJson(json);
  Map<String, dynamic> toJson() => _$AudioAyahToJson(this);
}

@JsonSerializable()
class SurahAudioData {
  final int chapter;
  final List<AudioAyah> verses;

  SurahAudioData({required this.chapter, required this.verses});

  factory SurahAudioData.fromJson(Map<String, dynamic> json) =>
      _$SurahAudioDataFromJson(json);
  Map<String, dynamic> toJson() => _$SurahAudioDataToJson(this);
}

@JsonSerializable()
class SurahAudioResponse {
  final bool success;
  final SurahAudioData data;

  SurahAudioResponse({required this.success, required this.data});

  factory SurahAudioResponse.fromJson(Map<String, dynamic> json) =>
      _$SurahAudioResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SurahAudioResponseToJson(this);
}
