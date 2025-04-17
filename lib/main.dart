import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/registration_screen.dart';
import 'screens/login_screen.dart'; // Add this import
import 'screens/profile_screen.dart';
import 'widgets/auth_wrapper.dart';
import 'utils/theme.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase with the configuration
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gaming Player Card',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: AuthWrapper(),
      routes: {
        '/register': (context) => RegistrationScreen(),
        '/login': (context) => LoginScreen(), // Add this route
        '/profile': (context) => ProfileScreen(),
      },
    );
  }
}