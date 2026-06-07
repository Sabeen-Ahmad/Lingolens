# LingoLens – My Vocabulary Feature

A vocabulary saving app built with Flutter, Firebase, and Node.js.
Users can save words they want to learn with meaning and translation.

---


---

## Project Structure

```
LingoLens/
├── flutter-app/          # Flutter frontend (Clean Architecture + BLoC)
├── backend/              # Node.js + Express API
├── screenshots/          # App screenshots
└── README.md
```

---

## Architecture

### Flutter App

```
lib/
├── core/
│   ├── di/               # GetIt service locator
│   ├── error/            # Failure classes
│   ├── network/          # Dio API client
│   └── theme/            # AppTheme (dark theme, color palette, typography)
└── features/
    └── vocabulary/
        ├── data/
        │   ├── datasources/
        │   │   ├── vocabulary_remote_datasource.dart   ← GET /words API
        │   │   └── vocabulary_local_datasource.dart    ← Firestore reads/writes
        │   ├── models/           ← WordModel (JSON + Firestore serialization)
        │   └── repositories/     ← VocabularyRepositoryImpl
        ├── domain/
        │   ├── entities/         ← Word entity
        │   ├── repositories/     ← abstract VocabularyRepository
        │   └── usecases/         ← GetWordsUseCase, SaveWordUseCase
        └── presentation/
            ├── bloc/             ← VocabularyBloc (events + states)
            ├── pages/            ← VocabularyPage
            └── widgets/
                ├── word_card.dart
                ├── word_card_skeleton.dart
                ├── empty_vocabulary_state.dart
                ├── error_state.dart
                └── add_word_bottom_sheet.dart
```

---

### State Management (BLoC)

| Event | States Produced |
|-------|----------------|
| LoadWordsEvent | VocabularyLoading → VocabularyLoaded / VocabularyError |
| SaveWordEvent | WordSaving → WordSaved / WordSaveError |

---

### Data Flow

```
Flutter reads:
  VocabularyBloc → GetWordsUseCase → VocabularyRepositoryImpl
    → VocabularyRemoteDataSource (GET /words Node API)
    → [fallback] VocabularyLocalDataSource (Firestore)

Flutter writes:
  VocabularyBloc → SaveWordUseCase → VocabularyRepositoryImpl
    → VocabularyLocalDataSource (Firestore direct write)

Node.js reads:
  GET /words → WordsController → WordsService → Firebase Admin → Firestore
```

---

## Setup

### 1. Firebase

1. Go to [console.firebase.google.com](https://console.firebase.google.com)
2. Create a project
3. Enable **Firestore Database** in test mode
4. Go to Project Settings → Service Accounts → Generate new private key
5. Save as `backend/serviceAccountKey.json`

### 2. Flutter App

```bash
cd flutter-app

dart pub global activate flutterfire_cli
flutterfire configure

flutter pub get
flutter run
```

### 3. Backend

```bash
cd backend
npm install
cp .env.example .env

# Place serviceAccountKey.json in backend/ folder

npm run dev
```

Server runs at `http://localhost:3000`

Update base URL in `lib/core/network/api_client.dart`:
```dart
static const String _baseUrl = 'http://10.0.2.2:3000'; // Android emulator
```

---

## API Reference

### GET /words

```json
{
  "success": true,
  "count": 1,
  "data": [
    {
      "id": "abc123",
      "word": "Apple",
      "meaning": "A fruit",
      "translation": "Manzana",
      "createdAt": "2026-06-07T12:00:00.000Z"
    }
  ]
}
```

### POST /words

```json
{
  "word": "Apple",
  "meaning": "A fruit",
  "translation": "Manzana"
}
```

---

## UI States

| State | Behavior |
|-------|----------|
| Loading | Shimmer skeleton cards |
| Empty | Illustration + Add First Word CTA |
| Error | Error icon + retry button |
| Filled | Animated word cards |

Pull-to-refresh supported on filled list.

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Frontend | Flutter + BLoC |
| State Management | flutter_bloc |
| Backend | Node.js + Express |
| Database | Firebase Firestore |
| DI | GetIt |
| Networking | Dio |
| UI | Google Fonts + Shimmer |

---

## Estimated AI Contribution

```
UI/UX design decisions:  Manual
Widget structure:        Manual
Clean Architecture:      Manual
Boilerplate code:        AI-assisted (~60%)
Backend API:             AI-assisted (~70%)
Firebase integration:    AI-assisted (~50%)
```

---

## Notes

- Backend runs locally — update `_baseUrl` for production deployment
- Never commit `serviceAccountKey.json` or `firebase_options.dart`
- Firestore rules set to test mode for development
