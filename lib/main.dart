import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/auth_service.dart';
import 'providers/workout_provider.dart';
import 'providers/user_profile_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/nutrition_provider.dart';
import 'screens/home_dashboard_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/leaderboard_screen.dart';
import 'screens/friends_screen.dart';
import 'screens/search_users_screen.dart';
import 'services/notification_service.dart';
import 'widgets/main_navigation.dart';
import 'theme_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print(".env bulunamadı: $e");
  }

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('🔥 Firebase initialized successfully');

  // Auto sign-in (Anonymous)
  final authService = AuthService();
  if (authService.currentUser == null) {
    await authService.signInAnonymously();
    print('✅ Anonymous user created: ${authService.currentUser?.uid}');
  } else {
    print('✅ Existing user: ${authService.currentUser?.uid}');
  }

  // Initialize notification service
  final notificationService = NotificationService();
  await notificationService.initialize();
  await notificationService.requestPermissions();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            final provider = WorkoutProvider();
            provider.loadData();
            return provider;
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            final provider = UserProfileProvider();
            provider.loadData();
            return provider;
          },
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => NutritionProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GymGenius',
      themeMode: ThemeMode.dark,
      darkTheme: AppTheme.darkTheme,
      
      // Localization support
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('tr', ''), // Turkish
      ],
      
      // Check if first time user
      home:const WelcomeScreen(),
      routes: {
        '/home': (context) => const MainNavigation(),
        '/welcome': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
      },
    );
  }
}
