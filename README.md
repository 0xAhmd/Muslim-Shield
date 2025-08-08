<div align="center">

# **بسم الله الرحمن الرحيم**

</div>


# 🛡️ Muslim Shield

**Muslim Shield** is a comprehensive Islamic application built with **Flutter** using **clean architecture**. It offers essential tools for Muslims, including access to the full Quran with audio, prayer times with adhan notifications, Qiblah direction, Duaa collections, live Quran radio, nearby masjid finder, Islamic calendar with reminders, prayer tracking with streak system, morning & evening adhkar, zakat calculator, hadith collections, digital tasbih, and the 99 names of Allah — all packed in a beautifully designed and secure mobile experience.

> ⚠️ This app does **not** run on jailbroken or rooted devices or emulators.

---

## ✨ Features

### 📖 Quran
- Access the complete **Quran** with a clean and readable UI
- Multiple font and readability enhancements
- **Audio playbook** for verses with a choice of reciters

### 🧩 Juzz View
- View the Quran segmented by **Juzz**
- Get contextual info and access all verses under each Juzz

### 🔶 Hizb View
- Explore the Quran divided by **Hizbs**
- View associated info and read directly from this section

### 🤲 Sajda View
- Comprehensive list of all **Sajdas** (prostrations) in the Quran
- Detailed information about each sajda including verse context
- Easy navigation to sajda verses with complete metadata

### 🏷️ Last Read Tracking
- Bookmark your **last read** Ayah
- View a **progress card** with your recent reading stats and info

### 🔎 Powerful Search
- Search by **Ayah**, **Surah**, or any keyword in the Quran

### 📻 Quran Radio
- Live **Quran Radio** streaming from Egypt
- Beautiful audio controls with play, pause, and volume adjustment
- **Cool sound wave animations** during playbook
- Seamless background listening experience

### 🕋 Prayer Support & Tracking
- Auto-detect location to provide **accurate prayer times**
- **Adhan notifications** with authentic call to prayer sounds
- **Prayer tracker** with completion marking and streak system
- Track daily prayers (Fajr, Dhuhr, Asr, Maghrib, Isha)
- **Streak counter** to monitor consistency in prayers
- Local storage of prayer history and statistics
- **Qiblah compass** support
- **Sunnah prayer guidance** and explanations

### 🕌 Masjid Finder
- **Location-based masjid detection**
- Discover nearby masjids in your area
- Detailed masjid information and directions
- Interactive map integration

### 🤲 Duaa Collection
- Sectioned and categorized **Duaas**
- Includes source, metadata, and detailed info for each duaa

### 🌅 Morning & Evening Adhkar
- Complete collection of **morning adhkar** (أذكار الصباح)
- Comprehensive **evening adhkar** (أذكار المساء)
- Tap-to-track completion system
- Beautiful Arabic text with transliteration and translation
- Audio recitation support
- Progress tracking for daily adhkar completion

### 💰 Zakat Calculator
- Comprehensive **zakat calculation** tool
- Support for multiple asset types:
  - Cash on hand
  - Bank savings
  - Gold (grams)
  - Silver (grams)
  - Investments & stocks
- **Debts & liabilities** consideration
- Accurate nisab calculations based on current rates
- Detailed zakat amount breakdown

### 📚 Hadith Collection
- Extensive **hadith library** with authentic collections
- Multiple hadith books including:
  - **Sahih Bukhari** (7236 hadiths, 99 chapters)
  - **Jami' At-Tirmidhi** (3956 hadiths, 50 chapters)
  - **Sunan Abu Dawood** (5274 hadiths, 43 chapters)
  - **Sunan Ibn-e-Majah** (4341 hadiths, 38 chapters)
  - **Sunan An-Nasa'i** (5758 hadiths, 52 chapters)
  - **Mishkat Al-Masabih** (6062 hadiths)
- Search functionality across all hadith collections
- Arabic text with English translations
- Hadith grading and authenticity information
- Bookmark favorite hadiths

### 📿 Digital Tasbih
- **Digital prayer beads** counter
- Customizable dhikr phrases including:
  - سُبْحَانَ اللّٰهِ (Subhan Allah)
  - الْحَمْدُ لِلّٰهِ (Alhamdulillahi)
  - And more traditional phrases
- **Tap counter** with beautiful animations
- Reset functionality
- Track your daily dhikr progress

### 🕊️ Names of Allah (Asma ul Husna)
- Complete collection of **99 Beautiful Names of Allah**
- Each name includes:
  - **Arabic calligraphy** (الرَّحْمٰنُ, الرَّحِيمُ, الْمَلِكُ)
  - **Transliteration** (Ar-Rahman, Ar-Raheem, Al-Malik)
  - **Detailed meanings** and explanations
  - **Benefits and significance** of each name
- Beautiful card-based interface
- Tap for detailed information
- Perfect for learning and reflection

### 📅 Islamic Reminders & Calendar
- Interactive **Islamic calendar** with event markers
- **Automatic reminders** for Islamic events including:
  - Eid celebrations
  - Jumaa (Friday prayers)
  - Islamic holidays and observances
- **Local scheduled notifications** for important dates
- Customizable reminder settings

### 📌 Bookmarks
- Save any **Ayah**, **Duaa**, or **Hadith** locally using **Hive**
- Offline access to all your saved items
- Organized bookmark management

---

## 🛠️ Tech Stack

- **Flutter** with Clean Architecture
- **State Management**: `flutter_bloc`
- **Local Storage**: `hive`, `shared_preferences`
- **Networking**: `dio`, `retrofit`
- **UI Enhancements**: `flutter_screenutil`, `google_fonts`, `flutter_svg`, `animated_text_kit`
- **Audio & Radio**: `audioplayers`, `just_audio` (for radio streaming), `audio_service`
- **Location & Compass**: `geolocator`, `geocoding`, `flutter_qiblah`
- **Maps & Places**: `google_maps_flutter`, `places_api`
- **Notifications**: `flutter_local_notifications`
- **Calendar**: `table_calendar`, `hijri_calendar`
- **Security**: `jailbreak_root_detection`, `safe_device`
- **Pagination**: `infinite_scroll_pagination`

### 📦 Dependencies

```yaml
dependencies:
  animated_text_kit: ^4.2.3
  audio_service: ^0.18.18
  audioplayers: ^6.5.0
  bloc: ^9.0.0
  connectivity_plus: ^6.1.4
  cupertino_icons: ^1.0.8
  dio: ^5.8.0+1
  equatable: ^2.0.7
  flutter:
    sdk: flutter
  flutter_bloc: ^9.1.1
  flutter_dotenv: ^5.2.1
  flutter_local_notifications: ^17.2.3
  flutter_qiblah: ^3.1.0+1
  flutter_screenutil: ^5.9.3
  flutter_svg: ^2.2.0
  geocoding: ^4.0.0
  geolocator: ^13.0.4
  google_fonts: ^6.3.0
  hijri: ^3.0.0
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  http: ^1.4.0
  infinite_scroll_pagination: ^5.1.0
  intl: ^0.20.2
  jailbreak_root_detection: ^1.1.6
  json_annotation: ^4.9.0
  just_audio: ^0.10.4
  meta: ^1.16.0
  package_info_plus: ^8.3.0
  permission_handler: ^12.0.1
  quickalert: ^1.1.0
  rename: ^3.1.0
  retrofit: ^4.7.0
  safe_device: ^1.3.5
  shared_preferences: ^2.5.3
  shimmer: ^3.0.0
  table_calendar: ^3.2.0
  timezone: ^0.9.4
  url_launcher: ^6.3.2
```

---

## 🚀 Getting Started

To run this project locally:

```bash
git clone https://github.com/0xAhmd/muslim-shield.git
cd muslim-shield
flutter pub get
flutter run
```

### 📋 Prerequisites
- Flutter SDK installed
- A physical (non-rooted/non-jailbroken) device connected
- Location permissions for prayer times and masjid finder
- Notification permissions for adhan calls and Islamic reminders
- Internet connection for radio streaming, hadith data, and masjid information
- Storage permissions for bookmarks and prayer tracking data

---

## 🔧 Permissions Required

This app requires the following permissions:
- **Location**: For prayer times, Qiblah direction, and nearby masjid detection
- **Notifications**: For adhan calls, Islamic event reminders, and prayer time alerts
- **Internet**: For radio streaming, hadith collections, and real-time data
- **Storage**: For bookmarks, prayer tracking, and offline content
- **Audio**: For adhan playbook and Quran recitation

---

## 📱 App Features Overview

The Muslim Shield app provides a complete Islamic companion with:

- **📖 Complete Quran** with audio and bookmarking
- **🕋 Prayer times** with adhan notifications and tracking
- **🤲 Morning/Evening Adhkar** with progress tracking
- **💰 Zakat Calculator** for accurate charitable giving
- **📚 Hadith Collections** from authentic sources
- **📿 Digital Tasbih** for dhikr counting
- **🕊️ 99 Names of Allah** with detailed explanations
- **📻 Live Quran Radio** streaming
- **🕌 Masjid Finder** with location services
- **📅 Islamic Calendar** with automatic reminders

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!

1. Fork the repo
2. Create your feature branch: `git checkout -b feature/new-feature`
3. Commit your changes: `git commit -m 'Add new feature'`
4. Push to the branch: `git push origin feature/new-feature`
5. Open a Pull Request

---

<div align="center">

**Made with ❤️ for the Muslim community using Flutter**

*"And whoever relies upon Allah - then He is sufficient for him. Indeed, Allah will accomplish His purpose."* - **Quran 65:3**

</div>