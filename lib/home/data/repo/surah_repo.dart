// lib/home/data/repo/surah_repo.dart
import 'package:azkar/home/data/models/surah.dart';
import 'package:azkar/home/data/service/dio_client.dart';
import 'package:dio/dio.dart';

class SurahRepository {
  final _apiService = DioClient().apiService;
  final _audioApiService = DioClient().audioApiService;

  Future<List<Surah>> getSurahs() async {
    try {
      final response = await _apiService.getSurahs();
      return response.data;
    } catch (e) {
      print('Error in getSurahs: $e');
      throw Exception('Failed to fetch surahs: $e');
    }
  }

  Future<SurahDetail> getSurah(int number) async {
    try {
      final response = await _apiService.getSurah(number);
      return response.data;
    } catch (e) {
      print('Error in getSurah: $e');
      throw Exception('Failed to fetch surah: $e');
    }
  }

  Future<SurahDetail> getSurahWithAudio(int number) async {
    try {
      final response = await _apiService.getSurahWithAudio(number);
      return response.data;
    } catch (e) {
      print('Error in getSurahWithAudio: $e');
      throw Exception('Failed to fetch surah with audio: $e');
    }
  }

  Future<List<Reciter>> getReciters() async {
    try {
      print('Calling audioApiService.getRecitersRaw()...');
      final Map<String, String> reciterMap = await _audioApiService
          .getRecitersRaw();
      print('Raw API response: $reciterMap');

      final List<Reciter> reciters = [];

      reciterMap.forEach((id, name) {
        try {
          final reciter = Reciter.fromApiResponse(id, name);
          reciters.add(reciter);
          print('Added reciter: ${reciter.name} (ID: ${reciter.id})');
        } catch (e) {
          print('Error parsing reciter ID $id, name $name: $e');
        }
      });

      reciters.sort((a, b) => a.id.compareTo(b.id));

      print('Successfully loaded ${reciters.length} reciters');
      return reciters;
    } catch (e, stackTrace) {
      print('Error in getReciters: $e');
      print('Stack trace: $stackTrace');
      throw Exception('Failed to fetch reciters: $e');
    }
  }

  Future<SurahAudioResponse> getSurahAudio(
    int reciterId,
    int chapterNumber,
  ) async {
    try {
      print('Getting audio for reciter $reciterId, chapter $chapterNumber');

      // Get surah details to know how many ayahs there are
      final surahDetail = await getSurah(chapterNumber);
      final totalAyahs = surahDetail.numberOfAyahs;

      print('Total ayahs in chapter $chapterNumber: $totalAyahs');

      List<AudioAyah> verses = [];

      // Use EveryAyah.com URLs which are more reliable
      // Map reciter IDs to EveryAyah folder names
      Map<int, String> reciterFolders = {
        1: 'Alafasy_128kbps',
        2: 'Abu_Bakr_Ash-Shaatree_128kbps',
        3: 'Nasser_Alqatami_128kbps',
        4: 'Yasser_Ad-Dussary_128kbps',
        5: 'Hani_Rifai_128kbps',
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

          print('Generated URL for ayah $ayahNumber: $audioUrl');
        }
      } else {
        // Fallback to the Quran-Audio project URLs
        print('Unknown reciter ID: $reciterId, using fallback URLs');
        for (int ayahNumber = 1; ayahNumber <= totalAyahs; ayahNumber++) {
          String audioUrl =
              'https://the-quran-project.github.io/Quran-Audio/Data/$reciterId/${chapterNumber}_$ayahNumber.mp3';

          verses.add(AudioAyah(verse: ayahNumber, url: audioUrl));

          print('Generated fallback URL for ayah $ayahNumber: $audioUrl');
        }
      }

      final audioResponse = SurahAudioResponse(
        success: verses.isNotEmpty,
        data: SurahAudioData(chapter: chapterNumber, verses: verses),
      );

      print('✅ Audio response created with ${verses.length} verses');
      return audioResponse;
    } catch (e, stackTrace) {
      print('❌ Error in getSurahAudio: $e');
      print('Stack trace: $stackTrace');

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
      print(
        'Getting full chapter audio for reciter $reciterId, chapter $chapterNumber',
      );

      // First get the surah details to know how many ayahs there are
      final surahDetail = await getSurah(chapterNumber);
      final totalAyahs = surahDetail.numberOfAyahs;

      print('Total ayahs in chapter $chapterNumber: $totalAyahs');

      List<AudioAyah> verses = [];
      final dio = DioClient().audioDio;

      // Get audio for each ayah in the chapter
      for (int ayahNumber = 1; ayahNumber <= totalAyahs; ayahNumber++) {
        try {
          print('Fetching audio for ayah $ayahNumber...');
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
                  print('Added audio for ayah $ayahNumber: $audioUrl');
                }
              }
            }
          }
        } catch (e) {
          print('Error loading audio for ayah $ayahNumber: $e');
          // Continue with other ayahs even if one fails
        }
      }

      final audioResponse = SurahAudioResponse(
        success: verses.isNotEmpty,
        data: SurahAudioData(chapter: chapterNumber, verses: verses),
      );

      print('Full chapter audio response created with ${verses.length} verses');
      return audioResponse;
    } catch (e, stackTrace) {
      print('Error in getFullChapterAudio: $e');
      print('Stack trace: $stackTrace');
      throw Exception('Failed to fetch full chapter audio: $e');
    }
  }
}
