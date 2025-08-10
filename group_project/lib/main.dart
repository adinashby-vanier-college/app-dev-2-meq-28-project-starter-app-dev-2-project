import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'screens/sign_in_screen.dart';
import 'screens/conversations_screen.dart';
import 'screens/archived_chats_screen.dart';

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
      home: const AuthGate(),
      routes: {
        '/signIn': (context) => const SignInScreen(),
        '/conversations': (context) => const ConversationsScreen(),
        '/archivedChats': (context) => const ArchivedChatsScreen(),
      },
    );
  }
}

/// Decides which screen to show based on FirebaseAuth state
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading spinner while checking auth state
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData) {
          // User is signed in
          return const ConversationsScreen();
        } else {
          // User is not signed in
          return const SignInScreen();
        }
      },
    );
  }
}
