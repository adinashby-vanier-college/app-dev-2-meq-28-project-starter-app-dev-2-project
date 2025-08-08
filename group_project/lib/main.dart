import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/chat_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const SkillSwapApp());
}

class SkillSwapApp extends StatelessWidget {
  const SkillSwapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkillSwap',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
        debugShowCheckedModeBanner: false,
      home: ChatScreen(), // Replace with splash/home screen later
    );
  }
}
