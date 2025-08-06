
import 'dua_model.dart';

class DuasData {
  static const List<String> categories = [
    'Morning & Evening',
    'Before/After Salah',
    'Daily Duas',
    'Protection Duas',
    'Travel Duas',
  ];

  static const List<DuaModel> duas = [
    // Morning & Evening Duas
    DuaModel(
      id: 'morning_1',
      title: 'Morning Dhikr',
      category: 'Morning & Evening',
      arabic: 'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
      transliteration: 'AṣbaḥnĀ wa aṣbaḥa-l-mulku lillĀhi, wa-l-ḥamdu lillĀhi, lĀ ilĀha illĀ-llĀhu waḥdahu lĀ sharīka lahu, lahu-l-mulku wa lahu-l-ḥamdu wa huwa ʿalĀ kulli shay\'in qadīr',
      translation: 'We have reached the morning and with it Allah\'s dominion. All praise is for Allah. There is no god but Allah alone, with no partner. To Him belongs the dominion, to Him belongs all praise, and He has power over everything.',
      reference: 'Abu Dawud 4/317',
    ),
    DuaModel(
      id: 'morning_2',
      title: 'Seeking Allah\'s Protection',
      category: 'Morning & Evening',
      arabic: 'أَعُوذُ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ، اللهُ لاَ إِلَهَ إِلاَّ هُوَ الْحَيُّ الْقَيُّومُ',
      transliteration: 'Aʿūdhu billĀhi mina-sh-shayṭĀni-r-rajīm, AllĀhu lĀ ilĀha illĀ huwa-l-ḥayyu-l-qayyūm',
      translation: 'I seek refuge in Allah from Satan the accursed. Allah - there is no deity except Him, the Ever-Living, the Sustainer.',
      reference: 'Quran 2:255',
    ),
    DuaModel(
      id: 'evening_1',
      title: 'Evening Protection',
      category: 'Morning & Evening',
      arabic: 'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ',
      transliteration: 'AmsaynĀ wa amsĀ-l-mulku lillĀhi, wa-l-ḥamdu lillĀhi, lĀ ilĀha illĀ-llĀhu waḥdahu lĀ sharīka lahu',
      translation: 'We have reached the evening and with it Allah\'s dominion. All praise is for Allah. There is no god but Allah alone, with no partner.',
      reference: 'Muslim 4/2088',
    ),

    // Before/After Salah Duas
    DuaModel(
      id: 'salah_1',
      title: 'Before Prayer',
      category: 'Before/After Salah',
      arabic: 'اللَّهُمَّ بَاعِدْ بَيْنِي وَبَيْنَ خَطَايَايَ كَمَا بَاعَدْتَ بَيْنَ الْمَشْرِقِ وَالْمَغْرِبِ',
      transliteration: 'AllĀhumma bĀʿid baynī wa bayna khaṭĀyĀya kamĀ bĀʿadta bayna-l-mashriqi wa-l-maghrib',
      translation: 'O Allah, distance me from my sins as You have distanced the East from the West.',
      reference: 'Bukhari 1/181',
    ),
    DuaModel(
      id: 'salah_2',
      title: 'After Salah',
      category: 'Before/After Salah',
      arabic: 'أَسْتَغْفِرُ اللَّهَ، أَسْتَغْفِرُ اللَّهَ، أَسْتَغْفِرُ اللَّهَ، اللَّهُمَّ أَنْتَ السَّلَامُ وَمِنْكَ السَّلَامُ',
      transliteration: 'Astaghfiru-llĀh (3x), AllĀhumma anta-s-salĀmu wa minka-s-salĀm',
      translation: 'I seek Allah\'s forgiveness (3x). O Allah, You are Peace and from You comes peace.',
      reference: 'Muslim 1/414',
    ),
    DuaModel(
      id: 'salah_3',
      title: 'Tasbih after Prayer',
      category: 'Before/After Salah',
      arabic: 'سُبْحَانَ اللَّهِ وَالْحَمْدُ لِلَّهِ وَاللَّهُ أَكْبَرُ',
      transliteration: 'SubḥĀna-llĀhi wa-l-ḥamdu lillĀhi wa-llĀhu akbar',
      translation: 'Glory be to Allah, praise be to Allah, and Allah is the Greatest.',
      reference: 'Muslim 1/418',
    ),

    // Daily Duas
    DuaModel(
      id: 'daily_1',
      title: 'Before Eating',
      category: 'Daily Duas',
      arabic: 'بِسْمِ اللَّهِ',
      transliteration: 'Bismi-llĀh',
      translation: 'In the name of Allah.',
      reference: 'Abu Dawud 3/347',
    ),
    DuaModel(
      id: 'daily_2',
      title: 'After Eating',
      category: 'Daily Duas',
      arabic: 'الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنِي هَذَا وَرَزَقَنِيهِ مِنْ غَيْرِ حَوْلٍ مِنِّي وَلَا قُوَّةٍ',
      transliteration: 'Al-ḥamdu lillĀhi-lladhī aṭʿamanī hĀdhĀ wa razaqanīhi min ghayri ḥawlin minnī wa lĀ quwwah',
      translation: 'Praise be to Allah who has fed me this food and provided it for me without any effort or power from myself.',
      reference: 'Tirmidhi 5/507',
    ),
    DuaModel(
      id: 'daily_3',
      title: 'Before Sleep',
      category: 'Daily Duas',
      arabic: 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
      transliteration: 'Bismika-llĀhumma amūtu wa aḥyĀ',
      translation: 'In Your name, O Allah, I die and I live.',
      reference: 'Bukhari 11/113',
    ),
    DuaModel(
      id: 'daily_4',
      title: 'Upon Waking Up',
      category: 'Daily Duas',
      arabic: 'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ',
      transliteration: 'Al-ḥamdu lillĀhi-lladhī aḥyĀnĀ baʿda mĀ amĀtanĀ wa ilayhi-n-nushūr',
      translation: 'Praise be to Allah who has brought us back to life after causing us to die, and to Him is the resurrection.',
      reference: 'Bukhari 11/113',
    ),

    // Protection Duas
    DuaModel(
      id: 'protection_1',
      title: 'Ayat al-Kursi',
      category: 'Protection Duas',
      arabic: 'اللَّهُ لَا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ',
      transliteration: 'AllĀhu lĀ ilĀha illĀ huwa-l-ḥayyu-l-qayyūm, lĀ ta\'khudhuhu sinatun wa lā nawm',
      translation: 'Allah - there is no deity except Him, the Ever-Living, the Sustainer. Neither drowsiness overtakes Him nor sleep.',
      reference: 'Quran 2:255',
    ),
    DuaModel(
      id: 'protection_2',
      title: 'Seeking Refuge from Evil',
      category: 'Protection Duas',
      arabic: 'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ',
      transliteration: 'Aʿūdhu bi-kalimĀti-llĀhi-t-tĀmmĀti min sharri mĀ khalaq',
      translation: 'I seek refuge in the perfect words of Allah from the evil of what He has created.',
      reference: 'Muslim 4/2080',
    ),
    DuaModel(
      id: 'protection_3',
      title: 'Protection from Harm',
      category: 'Protection Duas',
      arabic: 'بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ',
      transliteration: 'Bismi-llĀhi-lladhī lĀ yaḍurru maʿa-smihi shay\'un fī-l-arḍi wa lĀ fī-s-samĀ\'i wa huwa-s-samīʿu-l-ʿalīm',
      translation: 'In the name of Allah, with whose name nothing in the earth or the heavens can cause harm, and He is the All-Hearing, All-Knowing.',
      reference: 'Abu Dawud 4/323',
    ),

    // Travel Duas
    DuaModel(
      id: 'travel_1',
      title: 'Before Journey',
      category: 'Travel Duas',
      arabic: 'سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ وَإِنَّا إِلَى رَبِّنَا لَمُنْقَلِبُونَ',
      transliteration: 'SubḥĀna-lladhī sakhkhara lanĀ hĀdhĀ wa mĀ kunnā lahu muqrinīn, wa innā ilĀ rabbinĀ la-munqalibūn',
      translation: 'Glory be to Him who has subjected this to us, and we could never have it by our efforts. Surely, to our Lord we shall return.',
      reference: 'Quran 43:13-14',
    ),
    DuaModel(
      id: 'travel_2',
      title: 'During Journey',
      category: 'Travel Duas',
      arabic: 'اللَّهُمَّ إِنَّا نَسْأَلُكَ فِي سَفَرِنَا هَذَا الْبِرَّ وَالتَّقْوَى وَمِنَ الْعَمَلِ مَا تَرْضَى',
      transliteration: 'AllĀhumma innā nas\'aluka fī safarinĀ hĀdha-l-birra wa-t-taqwĀ wa mina-l-ʿamali mĀ tarḍĀ',
      translation: 'O Allah, we ask You in this journey of ours for righteousness, piety, and such deeds as are pleasing to You.',
      reference: 'Tirmidhi 5/500',
    ),
    DuaModel(
      id: 'travel_3',
      title: 'Safe Return',
      category: 'Travel Duas',
      arabic: 'آيِبُونَ تَائِبُونَ عَابِدُونَ لِرَبِّنَا حَامِدُونَ',
      transliteration: 'Āyibūna tā\'ibūna ʿābidūna li-rabbinĀ ḥāmidūn',
      translation: 'We return, repentant, worshipping, and praising our Lord.',
      reference: 'Bukhari 4/1799',
    ),
  ];

  static List<DuaModel> getDuasByCategory(String category) {
    return duas.where((dua) => dua.category == category).toList();
  }

  static List<DuaModel> searchDuas(String query) {
    if (query.isEmpty) return duas;
    
    return duas.where((dua) {
      final searchQuery = query.toLowerCase();
      return dua.title.toLowerCase().contains(searchQuery) ||
             dua.translation.toLowerCase().contains(searchQuery) ||
             (dua.transliteration?.toLowerCase().contains(searchQuery) ?? false) ||
             dua.category.toLowerCase().contains(searchQuery);
    }).toList();
  }

  static Map<String, List<DuaModel>> getDuasGroupedByCategory() {
    final Map<String, List<DuaModel>> groupedDuas = {};
    
    for (final category in categories) {
      groupedDuas[category] = getDuasByCategory(category);
    }
    
    return groupedDuas;
  }
}