import 'package:flutter/material.dart';
// These import your custom screens
import 'screens/01_welcome_screen.dart';
import 'screens/02_login_screen.dart';
import 'screens/03_register_screen.dart';
import 'screens/04_main_menu_screen.dart';

// where  app starts running
void main() {
  // runApp() tells Flutter to launch  app, starting with MyApp
  runApp(const MyApp());
}

// main widget for  whole application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This method builds the main structure
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fridge & Pantry',

      // The overall color theme of  app
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),

      // first screen users will see when the app opens
      home: const WelcomeScreen(),

      // named routes for navigation
      routes: {
        // navigate to '/login' ,show the LoginScreen
        '/login': (_) => const LoginScreen(),
        // navigate to '/register', show the RegisterScreen
        '/register': (_) => const RegisterScreen(),
        '/main-menu':  (_) => const MainMenuScreen(),
      },
    );
  }
}
