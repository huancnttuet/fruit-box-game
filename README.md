# 🍎 Fruit Box Game

A fun puzzle game built with **Flutter** and **Flame Engine**. Select apples that sum to 10 to score points!

![Flutter](https://img.shields.io/badge/Flutter-3.38.5-blue?logo=flutter)
![Flame](https://img.shields.io/badge/Flame-1.18.0-orange?logo=flame)
![License](https://img.shields.io/badge/License-MIT-green)

## 🎮 Game Rules

- Drag to select apples on the grid
- Selected apples must sum to exactly **10**
- Each apple collected = **1 point**
- You have **2 minutes** to score as many points as possible!

## 🚀 Live Demo

🔗 **Play Now**: [https://fruit-box-game.vercel.app](https://fruit-box-game.vercel.app)

## 📁 Project Structure

```
lib/
├── main.dart                    # App entry point
├── constants/
│   └── game_constants.dart      # Game settings & colors
├── models/
│   └── apple_data.dart          # Apple data model
├── components/
│   ├── apple_component.dart     # Flame apple component
│   └── selection_rect_component.dart
├── game/
│   └── fruit_box_game.dart      # Main Flame game logic
├── widgets/
│   ├── game_header.dart         # Score & timer
│   ├── game_instructions.dart   # Instructions bar
│   ├── start_screen.dart        # Start screen
│   └── game_over_overlay.dart   # Game over overlay
└── screens/
    └── game_screen.dart         # Main game screen
```

## 🛠️ Development Setup

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.10.4+)
- [Dart SDK](https://dart.dev/get-dart) (included with Flutter)
- IDE: [VS Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio)

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/Ngandaoha/fruit-box-game.git
   cd fruit-box-game
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Run the app**

   ```bash
   # Web (Chrome)
   flutter run -d chrome

   # Web Server (manual browser)
   flutter run -d web-server --web-port=8080

   # Windows Desktop
   flutter run -d windows

   # Android
   flutter run -d android
   ```

## 🌐 Deployment

### Deploy to Vercel

1. **Build the web version**

   ```bash
   flutter build web --release
   ```

2. **Install Vercel CLI**

   ```bash
   npm install -g vercel
   ```

3. **Login to Vercel**

   ```bash
   vercel login
   ```

4. **Deploy**

   ```bash
   cd build/web
   vercel --prod
   ```

   Or deploy with auto-accept defaults:

   ```bash
   cd build/web
   vercel --prod --yes
   ```

### Deploy to GitHub Pages

1. **Build the web version with base href**

   ```bash
   flutter build web --release --base-href "/fruit-box-game/"
   ```

2. **Push `build/web` contents to `gh-pages` branch**

   ```bash
   cd build/web
   git init
   git add .
   git commit -m "Deploy to GitHub Pages"
   git branch -M gh-pages
   git remote add origin https://github.com/Ngandaoha/fruit-box-game.git
   git push -f origin gh-pages
   ```

3. **Enable GitHub Pages** in repository Settings → Pages → Source: `gh-pages`

### Deploy to Firebase Hosting

1. **Install Firebase CLI**

   ```bash
   npm install -g firebase-tools
   ```

2. **Login and initialize**

   ```bash
   firebase login
   firebase init hosting
   ```

3. **Set public directory to `build/web`**

4. **Deploy**
   ```bash
   flutter build web --release
   firebase deploy
   ```

## 🔧 Configuration

Game settings can be modified in `lib/constants/game_constants.dart`:

```dart
class GameConstants {
  static const int gridRows = 10;
  static const int gridCols = 12;
  static const int targetSum = 10;
  static const int gameDuration = 120; // seconds
}
```

## 🏆 Cloud Leaderboard Setup (Firebase Firestore)

The game supports a global cloud leaderboard so all players can see rankings. To enable this feature:

### Step 1: Create a Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project" or "Add project"
3. Enter a project name (e.g., "fruit-box-game")
4. Follow the setup wizard (you can disable Google Analytics if not needed)

### Step 2: Enable Firestore Database

1. In your Firebase project, go to **Build** → **Firestore Database**
2. Click "Create database"
3. Choose "Start in **test mode**" (for development) or "production mode" (configure security rules later)
4. Select a location closest to your users
5. Click "Enable"

### Step 3: Add Web App to Firebase

1. In Firebase Console, click the **gear icon** (Settings) → **Project settings**
2. Scroll down to "Your apps" section
3. Click **"Add app"** and select **Web** (`</>`)
4. Register your app with a nickname (e.g., "fruit-box-web")
5. Copy the configuration values shown

### Step 4: Update Firebase Configuration

Edit `lib/firebase_options.dart` and replace the placeholder values with your actual Firebase config:

```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'AIzaSy...',           // Your API key
  appId: '1:123456789:web:abc',  // Your App ID
  messagingSenderId: '123456789', // Your Messaging Sender ID
  projectId: 'fruit-box-game',    // Your Project ID
  authDomain: 'fruit-box-game.firebaseapp.com',
  storageBucket: 'fruit-box-game.appspot.com',
);
```

### Step 5: Set Up Firestore Security Rules (Production)

For production, update your Firestore rules in Firebase Console → Firestore → Rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow anyone to read the leaderboard
    match /leaderboard/{document=**} {
      allow read: if true;
      // Allow anyone to add scores (with size limit)
      allow create: if request.resource.data.keys().hasAll(['name', 'score', 'dateTime'])
                    && request.resource.data.name is string
                    && request.resource.data.name.size() <= 20
                    && request.resource.data.score is int
                    && request.resource.data.score >= 0;
      // Don't allow updates or deletes
      allow update, delete: if false;
    }
  }
}
```

### Optional: Use FlutterFire CLI (Automated Setup)

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase (generates firebase_options.dart automatically)
flutterfire configure
```

### Fallback Behavior

If Firebase is not configured or unavailable, the game will automatically fall back to local storage using `shared_preferences`. Players can still save and view their own scores locally.

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built with [Flutter](https://flutter.dev/)
- Game engine: [Flame](https://flame-engine.org/)
- Inspired by the classic [Fruit Box game](https://en.gamesaien.com/game/fruit_box/)
