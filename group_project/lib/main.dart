import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:group_project/screens/conversations_screen.dart';
import 'package:group_project/screens/archived_chats_screen.dart';

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
      home: const ConversationsScreen(), // Start screen (replace as required)
      routes: {
        '/archivedChats': (context) => const ArchivedChatsScreen(),
        // Add other routes here if needed
      },
    );
  }
}
