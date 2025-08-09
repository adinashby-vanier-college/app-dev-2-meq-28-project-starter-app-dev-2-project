import 'package:flutter/material.dart';

import '10_shop_around_screen.dart';
import '04_main_menu_screen.dart';


class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // screen background is a vertical gradient
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFD1E8E5), // Light mint
              Color(0xFFA7E9D0), // Soft green
              Color(0xFF6BB3A8), // Deep teal
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        // Keeps all content inside the safe, visible part of the screen
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                //app title
                const Text(
                  'FRIDGE\n&\nPANTRY',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Pacifico',
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3D36),
                    letterSpacing: 1,
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 40),
                // logo inside a circle with a "glass" effect and a white border
                Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12.withOpacity(0.12),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Image.asset('assets/logoo.png'),
                  ),
                ),
                const SizedBox(height: 70),
                // "Sign in" button –  to the login screen when pressed
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5EAAA8), // Button color
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        textStyle: const TextStyle(
                          fontFamily: 'NunitoSans',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text('Sign in'),
                    ),
                  ),
                ),
                // "Register" button –to the registration screen when pressed
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF5EAAA8), width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        backgroundColor: Colors.white.withOpacity(0.85),
                        textStyle: const TextStyle(
                          fontFamily: 'NunitoSans',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text(
                        'Register',
                        style: TextStyle(
                          color: Color(0xFF5EAAA8),
                        ),
                      ),
                    ),
                  ),
                ),
                // Test Magic Recommendations Screen button For Rishard (Will be deleted, Later - Test Purpose))
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ShopAroundScreen()),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.teal, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        backgroundColor: Colors.white.withOpacity(0.85),
                        textStyle: const TextStyle(
                          fontFamily: 'NunitoSans',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text(
                        '{Test Page-Rishard}',
                        style: TextStyle(color: Colors.teal),
                      ),
                    ),
                  ),
                ),
                // Test Main Menu Screen button (delete later)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      key: const Key('testMainMenuButton'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const MainMenuScreen()),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.teal, width: 2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        backgroundColor: Colors.white.withOpacity(0.85),
                        textStyle: const TextStyle(
                          fontFamily: 'NunitoSans',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text(
                        'Test Main Menu',
                        style: TextStyle(color: Colors.teal),
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
