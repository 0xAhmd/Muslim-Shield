// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'surah.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Surah _$SurahFromJson(Map<String, dynamic> json) => Surah(
  number: (json['number'] as num).toInt(),
  name: json['name'] as String,
  englishName: json['englishName'] as String,
  englishNameTranslation: json['englishNameTranslation'] as String,
  numberOfAyahs: (json['numberOfAyahs'] as num).toInt(),
  revelationType: json['revelationType'] as String,
);

Map<String, dynamic> _$SurahToJson(Surah instance) => <String, dynamic>{
  'number': instance.number,
  'name': instance.name,
  'englishName': instance.englishName,
  'englishNameTranslation': instance.englishNameTranslation,
  'numberOfAyahs': instance.numberOfAyahs,
  'revelationType': instance.revelationType,
};

SurahsResponse _$SurahsResponseFromJson(Map<String, dynamic> json) =>
    SurahsResponse(
      code: (json['code'] as num).toInt(),
      status: json['status'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => Surah.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SurahsResponseToJson(SurahsResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'status': instance.status,
      'data': instance.data,
    };

Ayah _$AyahFromJson(Map<String, dynamic> json) => Ayah(
  number: (json['number'] as num).toInt(),
  text: json['text'] as String,
  numberInSurah: (json['numberInSurah'] as num).toInt(),
  juz: (json['juz'] as num).toInt(),
  manzil: (json['manzil'] as num).toInt(),
  page: (json['page'] as num).toInt(),
  ruku: (json['ruku'] as num).toInt(),
  hizbQuarter: (json['hizbQuarter'] as num).toInt(),
  sajda: json['sajda'] as bool,
);

Map<String, dynamic> _$AyahToJson(Ayah instance) => <String, dynamic>{
  'number': instance.number,
  'text': instance.text,
  'numberInSurah': instance.numberInSurah,
  'juz': instance.juz,
  'manzil': instance.manzil,
  'page': instance.page,
  'ruku': instance.ruku,
  'hizbQuarter': instance.hizbQuarter,
  'sajda': instance.sajda,
};

SurahDetail _$SurahDetailFromJson(Map<String, dynamic> json) => SurahDetail(
  number: (json['number'] as num).toInt(),
  name: json['name'] as String,
  englishName: json['englishName'] as String,
  englishNameTranslation: json['englishNameTranslation'] as String,
  revelationType: json['revelationType'] as String,
  numberOfAyahs: (json['numberOfAyahs'] as num).toInt(),
  ayahs: (json['ayahs'] as List<dynamic>)
      .map((e) => Ayah.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SurahDetailToJson(SurahDetail instance) =>
    <String, dynamic>{
      'number': instance.number,
      'name': instance.name,
      'englishName': instance.englishName,
      'englishNameTranslation': instance.englishNameTranslation,
      'revelationType': instance.revelationType,
      'numberOfAyahs': instance.numberOfAyahs,
      'ayahs': instance.ayahs,
    };

SurahDetailResponse _$SurahDetailResponseFromJson(Map<String, dynamic> json) =>
    SurahDetailResponse(
      code: (json['code'] as num).toInt(),
      status: json['status'] as String,
      data: SurahDetail.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SurahDetailResponseToJson(
  SurahDetailResponse instance,
) => <String, dynamic>{
  'code': instance.code,
  'status': instance.status,
  'data': instance.data,
};

Reciter _$ReciterFromJson(Map<String, dynamic> json) => Reciter(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  style: json['style'] as String?,
  url: json['url'] as String?,
  fileFormats: (json['fileFormats'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$ReciterToJson(Reciter instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'style': instance.style,
  'url': instance.url,
  'fileFormats': instance.fileFormats,
};

AudioAyah _$AudioAyahFromJson(Map<String, dynamic> json) => AudioAyah(
  verse: (json['verse'] as num).toInt(),
  url: json['url'] as String,
);

Map<String, dynamic> _$AudioAyahToJson(AudioAyah instance) => <String, dynamic>{
  'verse': instance.verse,
  'url': instance.url,
};

SurahAudioData _$SurahAudioDataFromJson(Map<String, dynamic> json) =>
    SurahAudioData(
      chapter: (json['chapter'] as num).toInt(),
      verses: (json['verses'] as List<dynamic>)
          .map((e) => AudioAyah.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SurahAudioDataToJson(SurahAudioData instance) =>
    <String, dynamic>{'chapter': instance.chapter, 'verses': instance.verses};

SurahAudioResponse _$SurahAudioResponseFromJson(Map<String, dynamic> json) =>
    SurahAudioResponse(
      success: json['success'] as bool,
      data: SurahAudioData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SurahAudioResponseToJson(SurahAudioResponse instance) =>
    <String, dynamic>{'success': instance.success, 'data': instance.data};
