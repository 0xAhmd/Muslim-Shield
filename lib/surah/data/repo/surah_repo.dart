import 'package:azkar/surah/data/models/surah.dart';
import 'package:azkar/surah/data/service/dio_client.dart';
import 'package:azkar/juzz/data/models/juzz.dart';
import 'package:azkar/juzz/data/models/juzz_summary.dart';
import 'package:flutter/material.dart';

class SurahRepository {
  final _apiService = DioClient().apiService;
  final _audioApiService = DioClient().audioApiService;

  // Existing Surah methods...
  Future<List<Surah>> getSurahs() async {
    try {
      final response = await _apiService.getSurahs();
      return response.data;
    } catch (e) {
      debugPrint('Error in getSurahs: $e');
      throw Exception('Failed to fetch surahs: $e');
    }
  }

  Future<SurahDetail> getSurah(int number) async {
    try {
      final response = await _apiService.getSurah(number);
      return response.data;
    } catch (e) {
      debugPrint('Error in getSurah: $e');
      throw Exception('Failed to fetch surah: $e');
    }
  }

  Future<SurahDetail> getSurahWithAudio(int number) async {
    try {
      final response = await _apiService.getSurahWithAudio(number);
      return response.data;
    } catch (e) {
      debugPrint('Error in getSurahWithAudio: $e');
      throw Exception('Failed to fetch surah with audio: $e');
    }
  }

  // New Juzz methods
  Future<List<JuzzSummary>> getAllJuzzSummaries() async {
    try {
      // Return pre-defined summaries for performance
      // In production, you might want to cache full juzz data
      return JuzzSummary.getAllJuzzSummaries();
    } catch (e) {
      debugPrint('Error in getAllJuzzSummaries: $e');
      throw Exception('Failed to fetch juzz summaries: $e');
    }
  }

  Future<Juzz> getJuzz(int number) async {
    try {
      if (number < 1 || number > 30) {
        throw Exception('Invalid Juzz number. Must be between 1 and 30');
      }

      debugPrint('Fetching Juzz $number...');
      final response = await _apiService.getJuzz(number);
      debugPrint(
        'Successfully fetched Juzz $number with ${response.data.totalAyahs} ayahs',
      );
      return response.data;
    } catch (e) {
      debugPrint('Error in getJuzz($number): $e');
      throw Exception('Failed to fetch juzz $number: $e');
    }
  }

  // Batch load multiple Juzz (useful for offline caching)
  Future<List<Juzz>> getMultipleJuzz(List<int> numbers) async {
    try {
      final List<Juzz> juzzList = [];

      for (int number in numbers) {
        if (number >= 1 && number <= 30) {
          try {
            final juzz = await getJuzz(number);
            juzzList.add(juzz);
            debugPrint('Loaded Juzz $number');
          } catch (e) {
            debugPrint('Failed to load Juzz $number: $e');
            // Continue with other Juzz even if one fails
          }
        }
      }

      return juzzList;
    } catch (e) {
      debugPrint('Error in getMultipleJuzz: $e');
      throw Exception('Failed to fetch multiple juzz: $e');
    }
  }

  // Existing Audio methods...
  Future<List<Reciter>> getReciters() async {
    try {
      debugPrint('Calling audioApiService.getRecitersRaw()...');
      final Map<String, String> reciterMap = await _audioApiService
          .getRecitersRaw();
      debugPrint('Raw API response: $reciterMap');

      final List<Reciter> reciters = [];

      // List of reciter names to exclude (case-insensitive)
      final Set<String> excludedNames = {
        'hani ar rifai',
        'hani rifai',
        'hani al rifai',
        'hani al-rifai',
        'hani ar-rifai',
      };

      reciterMap.forEach((id, name) {
        try {
          // Check if this reciter should be excluded
          final normalizedName = name.toLowerCase().trim();
          if (excludedNames.contains(normalizedName)) {
            debugPrint('Excluding reciter: $name (ID: $id)');
            return; // Skip this reciter
          }

          final reciter = Reciter.fromApiResponse(id, name);
          reciters.add(reciter);
          debugPrint('Added reciter: ${reciter.name} (ID: ${reciter.id})');
        } catch (e) {
          debugPrint('Error parsing reciter ID $id, name $name: $e');
        }
      });

      reciters.sort((a, b) => a.id.compareTo(b.id));

      debugPrint(
        'Successfully loaded ${reciters.length} reciters (after exclusions)',
      );
      return reciters;
    } catch (e, stackTrace) {
      debugPrint('Error in getReciters: $e');
      debugPrint('Stack trace: $stackTrace');
      throw Exception('Failed to fetch reciters: $e');
    }
  }

  Future<SurahAudioResponse> getSurahAudio(
    int reciterId,
    int chapterNumber,
  ) async {
    try {
      debugPrint(
        'Getting audio for reciter $reciterId, chapter $chapterNumber',
      );

      // Get surah details to know how many ayahs there are
      final surahDetail = await getSurah(chapterNumber);
      final totalAyahs = surahDetail.numberOfAyahs;

      debugPrint('Total ayahs in chapter $chapterNumber: $totalAyahs');

      List<AudioAyah> verses = [];

      // Use EveryAyah.com URLs which are more reliable
      // Map reciter IDs to EveryAyah folder names (excluding Hani Rifai - ID 5)
      Map<int, String> reciterFolders = {
        1: 'Alafasy_128kbps',
        2: 'Abu_Bakr_Ash-Shaatree_128kbps',
        3: 'Nasser_Alqatami_128kbps',
        4: 'Yasser_Ad-Dussary_128kbps',
        // 5: 'Hani_Rifai_128kbps', // Excluded
      };

      String? folderName = reciterFolders[reciterId];

      if (folderName != null) {
        // Generate URLs for all ayahs
        for (int ayahNumber = 1; ayahNumber <= totalAyahs; ayahNumber++) {
          // Format with leading zeros: 001001, 001002, etc.
          String formattedChapter = chapterNumber.toString().padLeft(3, '0');
          String formattedAyah = ayahNumber.toString().padLeft(3, '0');

          String audioUrl =
              'https://everyayah.com/data/$folderName/$formattedChapter$formattedAyah.mp3';

          verses.add(AudioAyah(verse: ayahNumber, url: audioUrl));

          debugPrint('Generated URL for ayah $ayahNumber: $audioUrl');
        }
      } else {
        // Fallback to the Quran-Audio project URLs
        debugPrint('Unknown reciter ID: $reciterId, using fallback URLs');
        for (int ayahNumber = 1; ayahNumber <= totalAyahs; ayahNumber++) {
          String audioUrl =
              'https://the-quran-project.github.io/Quran-Audio/Data/$reciterId/${chapterNumber}_$ayahNumber.mp3';

          verses.add(AudioAyah(verse: ayahNumber, url: audioUrl));

          debugPrint('Generated fallback URL for ayah $ayahNumber: $audioUrl');
        }
      }

      final audioResponse = SurahAudioResponse(
        success: verses.isNotEmpty,
        data: SurahAudioData(chapter: chapterNumber, verses: verses),
      );

      debugPrint('✅ Audio response created with ${verses.length} verses');
      return audioResponse;
    } catch (e, stackTrace) {
      debugPrint('❌ Error in getSurahAudio: $e');
      debugPrint('Stack trace: $stackTrace');

      return SurahAudioResponse(
        success: false,
        data: SurahAudioData(chapter: chapterNumber, verses: []),
      );
    }
  }

  // Method to get audio for all ayahs in a chapter
  Future<SurahAudioResponse> getFullChapterAudio(
    int reciterId,
    int chapterNumber,
  ) async {
    try {
      debugPrint(
        'Getting full chapter audio for reciter $reciterId, chapter $chapterNumber',
      );

      // First get the surah details to know how many ayahs there are
      final surahDetail = await getSurah(chapterNumber);
      final totalAyahs = surahDetail.numberOfAyahs;

      debugPrint('Total ayahs in chapter $chapterNumber: $totalAyahs');

      List<AudioAyah> verses = [];
      final dio = DioClient().audioDio;

      // Get audio for each ayah in the chapter
      for (int ayahNumber = 1; ayahNumber <= totalAyahs; ayahNumber++) {
        try {
          debugPrint('Fetching audio for ayah $ayahNumber...');
          final response = await dio.get('/$reciterId/$chapterNumber.json');

          if (response.data != null && response.data is Map<String, dynamic>) {
            final data = response.data as Map<String, dynamic>;

            if (data.containsKey('audio') && data['audio'] is Map) {
              final audioMap = data['audio'] as Map<String, dynamic>;
              final reciterAudio = audioMap[reciterId.toString()];

              if (reciterAudio != null &&
                  reciterAudio is Map<String, dynamic>) {
                final audioUrl = reciterAudio['url'] as String?;

                if (audioUrl != null) {
                  verses.add(AudioAyah(verse: ayahNumber, url: audioUrl));
                  debugPrint('Added audio for ayah $ayahNumber: $audioUrl');
                }
              }
            }
          }
        } catch (e) {
          debugPrint('Error loading audio for ayah $ayahNumber: $e');
          // Continue with other ayahs even if one fails
        }
      }

      final audioResponse = SurahAudioResponse(
        success: verses.isNotEmpty,
        data: SurahAudioData(chapter: chapterNumber, verses: verses),
      );

      debugPrint(
        'Full chapter audio response created with ${verses.length} verses',
      );
      return audioResponse;
    } catch (e, stackTrace) {
      debugPrint('Error in getFullChapterAudio: $e');
      debugPrint('Stack trace: $stackTrace');
      throw Exception('Failed to fetch full chapter audio: $e');
    }
  }
}
