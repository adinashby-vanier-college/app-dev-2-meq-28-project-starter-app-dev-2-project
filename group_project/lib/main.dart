import 'package:flutter/material.dart';
import 'screens/chat_screen.dart';

void main() {
  runApp(SkillSwapApp());
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
      home: ChatScreen(), // Replace with splash/home screen later
    );
  }
}
