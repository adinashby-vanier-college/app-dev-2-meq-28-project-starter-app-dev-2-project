# SkillSwap

**SkillSwap** is a mobile app where users can connect to teach and learn skills from one another. Built using **Flutter** and **Firebase**, the app includes real-time chat, user profiles, location-based discovery, and skill-based matchmaking.

This is a class project focused on professional mobile app architecture, modular design, and real-world features.

---

## 🚀 Features

- 🔐 **Authentication** (Firebase Auth)
- 👤 **User Profiles** (with skills, bio, and photo)
- 🧠 **Skills Management** (add/remove what you know and want to learn)
- 💬 **Real-time Chat** (via Firestore)
- 📍 **Map View** (find nearby users)
- 💘 **Recommended Matches** (based on skill compatibility)
- 🕓 **Match History** (see your past interactions)
- ⚙️ **Settings Screen**
- 🧱 **Modular Architecture** (clean folder structure with services, models, widgets, etc.)

---

## 📦 Project Structure

```
lib/
├── main.dart
├── models/         # Data models (e.g., User, Message, Match)
├── screens/        # UI screens (Chat, Map, Profile, etc.)
├── services/       # Firebase + business logic
├── utils/          # Helpers, constants, validators
├── widgets/        # Reusable components
```

---

## 🛠️ Getting Started

### 1. Clone the repository:

```bash
git clone https://github.com/your-username/skillswap.git
cd skillswap
```

### 2. Install dependencies:

```bash
flutter pub get
```

### 3. Firebase setup:

- Create a Firebase project in the console
- Add `google-services.json` (Android) and/or `GoogleService-Info.plist` (iOS)
- Set up Firebase Auth, Firestore, and (optionally) Cloud Storage

### 4. Run the app:

```bash
flutter run
```

---

## 🔧 Dependencies (WIP)

- `firebase_core`
- `firebase_auth`
- `cloud_firestore`
- `google_maps_flutter`
- `geolocator`
- `provider` (or Riverpod, TBD)
- `flutter_dotenv` (for environment configs)

---

## 🧩 Planned Screens

- `LoginScreen` / `SignupScreen`
- `ChatScreen`
- `ProfileScreen`
- `EditSkillsScreen`
- `MapScreen`
- `MatchScreen`
- `MatchHistoryScreen`
- `SettingsScreen`

---

## 🧪 TODO

- [ ] Firebase Auth integration
- [ ] Firestore data models (users, skills, matches, messages)
- [ ] Real-time chat sync
- [ ] Nearby user detection (via geolocation)
- [ ] Match recommendation logic
- [ ] Profile editing and skills tagging
- [ ] Navigation and routing setup
- [ ] Dark mode support

---

## 📖 License

This project is for educational purposes only as part of a mobile development course.