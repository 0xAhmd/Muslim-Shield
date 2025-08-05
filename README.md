
# 🛡️ Muslim Shield

**Muslim Shield** is a comprehensive Islamic application built with **Flutter** using **clean architecture**. It offers essential tools for Muslims, including access to the full Quran with audio, prayer times, Qiblah direction, Duaa collections, and more — all packed in a beautifully designed and secure mobile experience.

> ⚠️ For security reasons, this app does **not** run on jailbroken or rooted devices or emulators.

---

## ✨ Features

### 📖 Quran
- Access the complete **Quran** with a clean and readable UI
- Multiple font and readability enhancements
- **Audio playback** for verses with a choice of reciters

### 🧩 Juzz View
- View the Quran segmented by **Juzz**
- Get contextual info and access all verses under each Juzz

### 🔶 Hizb View
- Explore the Quran divided by **Hizbs**
- View associated info and read directly from this section

### 🏷️ Last Read Tracking
- Bookmark your **last read** Ayah
- View a **progress card** with your recent reading stats and info

### 🔎 Powerful Search
- Search by **Ayah**, **Surah**, or any keyword in the Quran

### 🕋 Prayer Support
- Auto-detect location to provide **accurate prayer times**
- **Qiblah compass** support
- **Sunnah prayer guidance** and explanations

### 🤲 Duaa Collection
- Sectioned and categorized **Duaas**
- Includes source, metadata, and detailed info for each duaa

### 📌 Bookmarks
- Save any **Ayah** or **Duaa** locally using **Hive**
- Offline access to all your saved items

---

## 🛠️ Tech Stack

- **Flutter** with Clean Architecture
- **State Management**: `flutter_bloc`
- **Local Storage**: `hive`, `shared_preferences`
- **Networking**: `dio`, `retrofit`
- **UI Enhancements**: `flutter_screenutil`, `google_fonts`, `flutter_svg`, `animated_text_kit`
- **Audio**: `audioplayers`
- **Location & Compass**: `geolocator`, `geocoding`, `flutter_qiblah`
- **Security**: `jailbreak_root_detection`

### 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^9.1.1
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  dio: ^5.8.0+1
  retrofit: ^4.7.0
  shared_preferences: ^2.5.3
  google_fonts: ^6.3.0
  audioplayers: ^6.5.0
  flutter_qiblah: ^3.1.0+1
  flutter_screenutil: ^5.9.3
  flutter_svg: ^2.2.0
  geolocator: ^13.0.4
  geocoding: ^4.0.0
  animated_text_kit: ^4.2.3
  package_info_plus:
  permission_handler: ^12.0.1
  jailbreak_root_detection: ^1.1.6
  cupertino_icons: ^1.0.8
  json_annotation: ^4.9.0
  quickalert: ^1.1.0
  rename: ^3.1.0
````

---

## 🚫 Security

This app enforces **strict security policies**:

* ❌ **Not runnable** on rooted or jailbroken devices
* ❌ **Not supported** on emulators or virtual machines

This ensures the authenticity of use and protects sensitive features such as location and personal bookmarks.

---


## 🚀 Getting Started

To run this project locally:

```bash
git clone https://github.com/0xAhmd/muslim-shield.git
cd muslim-shield
flutter pub get
flutter run
```

Ensure you have Flutter SDK installed and a physical (non-rooted) device connected.

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!

1. Fork the repo
2. Create your feature branch: `git checkout -b feature/new-feature`
3. Commit your changes: `git commit -m 'Add new feature'`
4. Push to the branch: `git push origin feature/new-feature`
5. Open a Pull Request

---


Made with ❤️ using Flutter
