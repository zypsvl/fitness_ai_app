# 🏋️ GymGenius - AI Fitness Coaching App

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.9.2-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.9.2-0175C2?logo=dart)
![Platform](https://img.shields.io/badge/Platform-Android%20|%20iOS%20|%20Windows-success)
![License](https://img.shields.io/badge/License-Private-red)

**AI-powered fitness coaching app with personalized workout plans**

[Features](#-features) • [Installation](#-installation) • [Usage](#-usage) • [Architecture](#-architecture)

</div>

---

## 📋 Table of Contents

- [Features](#-features)
- [Screenshots](#-screenshots)
- [Installation](#-installation)
- [Configuration](#-configuration)
- [Usage](#-usage)
- [Architecture](#-architecture)
- [Dependencies](#-dependencies)
- [Development](#-development)
- [Contributing](#-contributing)

## ✨ Features

### 🤖 AI-Powered Workout Generation
- **Gemini AI Integration**: Leverages Google's Gemini API to create personalized workout programs
- **Smart Exercise Selection**: Automatically selects exercises based on your goals, level, and available equipment
- **Adaptive Programs**: Plans adjust to your fitness level (Beginner, Intermediate, Advanced)

### 💪 Comprehensive Workout Management
- **Multiple Training Programs**: Create unlimited workout programs for different goals
- **Manual Program Creation**: Build custom workout routines exercise by exercise
- **Exercise Library**: 850+ exercises with animated GIFs and detailed instructions
- **Real-time Tracking**: Track sets, reps, and weights during your workout
- **Rest Timer**: Built-in rest timer with customizable durations
-
 **Progress Monitoring**: Calendar view of workout history and completion stats

### 🎯 Goal-Oriented Training
Support for various fitness goals:
- 💪 Muscle Building (Hypertrophy)
- 🔥 Fat Loss
- 💪 Strength Training
- 🏃 General Fitness
- 🏋️ Bodybuilding
- ⚡ Athletic Performance

### 🌍 Multi-Language Support
- 🇬🇧 English
- 🇹🇷 Turkish
- Automatic language detection based on system settings

### 🎨 Premium UI/UX
- **Modern Glass Morphism Design**: Beautiful frosted glass effects
- **Animated Gradients**: Dynamic, eye-catching backgrounds
- **Smooth Animations**: Powered by Flutter Animate
- **Dark Theme**: Optimized for low-light conditions
- **Responsive Layout**: Works perfectly on all screen sizes

## 📱 Screenshots

*Coming soon*

## 🚀 Installation

### Prerequisites
- Flutter SDK >= 3.9.2
- Dart SDK >= 3.9.2
- Android Studio / VS Code with Flutter extensions
- Git

### Steps

1. **Clone the repository**
```bash
git clone <repository-url>
cd fitness_ai_app
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Configure API Key** (see [Configuration](#-configuration))

4. **Run the app**
```bash
# Development mode
flutter run

# Release mode (Android)
flutter build apk --release

# Release mode (iOS)
flutter build ios --release

# Release mode (Windows)
flutter build windows --release
```

## ⚙️ Configuration

### API Key Setup

The app requires a Gemini API key to generate workout programs.

1. Create a `.env` file in the project root:
```bash
GEMINI_API_KEY=your_api_key_here
```

2. Get your API key:
   - Visit [Google AI Studio](https://makersuite.google.com/app/apikey)
   - Create a new API key
   - Copy and paste it into the `.env` file

> **Note**: Never commit your `.env` file to version control. It's already included in `.gitignore`.

## 📖 Usage

### Creating Your First Program

1. **Launch the app** - You'll see the home dashboard
2. **Tap "Create New Program"** - Choose between AI-generated or manual program
3. **For AI-generated**:
   - Select your gender
   - Choose your goal (Muscle Building, Fat Loss, etc.)
   - Set your fitness level
   - Choose days per week (3-6)
   - Select location (Gym or Home)
   - Let AI generate your perfect program
4. **For Manual**:
   - Set program name and days
   - Add exercises for each workout day
   - Customize sets and reps

### Starting a Workout

1. Go to **"My Programs"**
2. Select a program
3. Choose a workout day
4. Tap **"Start Workout"**
5. Track your sets with the built-in tracker
6. Complete the workout and view your progress

### Tracking Progress

- View workout calendar in the **Progress** screen
- See completion stats (weekly/monthly)
- Track personal records for exercises

## 🏗️ Architecture

```
lib/
├── main.dart                 # App entry point
├── theme_config.dart         # App theme and styling
├── models/                   # Data models
│   ├── exercise_model.dart
│   ├── weekly_plan_model.dart
│   ├── saved_program_model.dart
│   ├── workout_session_model.dart
│   └── workout_progress_model.dart
├── providers/                # State management
│   └── workout_provider.dart
├── screens/                  # UI screens
│   ├── home_dashboard_screen.dart
│   ├── onboarding_screen.dart
│   ├── result_screen.dart
│   ├── my_programs_screen.dart
│   ├── active_workout_screen.dart
│   ├── progress_screen.dart
│   ├── create_manual_program_screen.dart
│   ├── edit_program_screen.dart
│   └── exercise_picker_screen.dart
├── widgets/                  # Reusable components
│   ├── glass_container.dart
│   ├── animated_gradient_background.dart
│   ├── premium_button.dart
│   ├── program_card.dart
│   ├── set_tracker_widget.dart
│   └── ...
├── services/                 # Business logic & APIs
│   ├── gemini_service.dart
│   └── ai_service_interface.dart
├── utils/                    # Utilities
│   └── app_strings.dart
└── l10n/                     # Localization files
    ├── app_en.arb
    └── app_tr.arb
```

### Design Patterns

- **Provider Pattern**: State management with ChangeNotifier
- **Repository Pattern**: Data persistence with SharedPreferences
- **Service Layer**: AI integration abstracted behind interfaces
- **Component-based UI**: Reusable widgets for consistency

## 📦 Dependencies

### Core
- `flutter_localizations` - Internationalization support
- `provider` (^6.1.5) - State management
- `shared_preferences` (^2.5.3) - Local data persistence

### AI & Data
- `google_generative_ai` (^0.4.7) - Gemini AI integration
- `http` (^1.6.0) - HTTP requests
- `flutter_dotenv` (^6.0.0) - Environment configuration

### UI/UX
- `google_fonts` (^6.3.2) - Typography
- `flutter_animate` (^4.5.0) - Smooth animations
- `cupertino_icons` (^1.0.8) - iOS-style icons

### Utilities
- `uuid` (^4.5.1) - Unique ID generation

### Development
- `flutter_test` - Testing framework
- `flutter_lints` (^5.0.0) - Code quality
- `flutter_launcher_icons` (^0.14.4) - App icon generation

## 🛠️ Development

### Running Tests
```bash
flutter test
```

### Code Analysis
```bash
flutter analyze
```

### Generate App Icons
```bash
flutter pub run flutter_launcher_icons
```

### Format Code
```bash
dart format lib/
```

### Build Configurations

**Development**
```bash
flutter run --debug
```

**Profile** (Performance testing)
```bash
flutter run --profile
```

**Production**
```bash
flutter build apk --release --split-per-abi  # Android (smaller APKs)
flutter build appbundle                       # Android App Bundle
flutter build ios --release                   # iOS
flutter build windows --release               # Windows
```

## 🎨 Customization

### Color Scheme
Edit `lib/theme_config.dart` to customize:
- Primary colors (purple, pink gradient)
- Secondary colors (cyan, blue)
- Accent colors (orange, yellow)
- Background colors

### Exercise Database
- Exercises are loaded from `assets/data/exercises.json`
- Add/modify exercises by editing this file
- Format: `{ "id", "name", "target", "bodyPart", "equipment", "gifUrl", ... }`

## 🤝 Contributing

This is a private project. If you have access and want to contribute:

1. Create a feature branch (`git checkout -b feature/AmazingFeature`)
2. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
3. Push to the branch (`git push origin feature/AmazingFeature`)
4. Open a Pull Request

## 📄 License

This project is private and proprietary. All rights reserved.

## 🐛 Known Issues

- None currently tracked

## 🗺️ Roadmap

- [ ] Social features (share workouts)
- [ ] Nutrition tracking
- [ ] Exercise video tutorials
- [ ] Wearable device integration
- [ ] Cloud sync across devices
- [ ] Workout templates marketplace

## 💬 Support

For questions or issues, please contact the development team.

---

<div align="center">
Made with ❤️ using Flutter

**GymGenius** - Your AI-powered fitness companion
</div>
