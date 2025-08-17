import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// This screen shows the main menu with buttons to different features
class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Background gradient colors (same as WelcomeScreen)
    final user = FirebaseAuth.instance.currentUser;

    // Background gradient colors
    final bgGradient = const LinearGradient(
      colors: [
        Color(0xFFD1E8E5), // Light mint
        Color(0xFFA7E9D0), // Soft green
        Color(0xFF6BB3A8), // Deep teal
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    // Style for all the menu buttons
    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF5EAAA8), // Teal color
      foregroundColor: Colors.white, // Text color
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      padding: const EdgeInsets.symmetric(vertical: 18),
      textStyle: const TextStyle(
        fontFamily: 'NunitoSans',
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );

    // List of menu items with title, icon, and route
    final menuItems = [
      _MenuItem('Add Ingredients', Icons.add, '/add-ingredients'),
      _MenuItem('Recipe Mixer', Icons.fastfood, '/recipe-mixer'),
      _MenuItem('Magic Recommendations', Icons.auto_awesome, '/magic-recommendations'),
      _MenuItem('NutriPal', Icons.local_hospital, '/nutripal'),
      _MenuItem('Groceries Around You', Icons.store, '/shop-around'),
      _MenuItem('Settings', Icons.settings, '/settings'),
    ];

    Future<void> signOut() async {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, '/login');
    }

    return Scaffold(
      // Main layout of the screen
      body: Container(
        decoration: BoxDecoration(gradient: bgGradient), // Apply background
        child: SafeArea(
          child: Column(
            children: [
              // Top bar with logout button and title
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back button
                    IconButton(
                      icon: const Icon(Icons.logout, color: Color(0xFF1E3D36)),
                      tooltip: 'Sign out',
                      onPressed: signOut,
                    ),
                    // Title text
                    const Text(
                      'Main Menu',
                      style: TextStyle(
                        fontFamily: 'Pacifico',
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E3D36),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              // Personalized welcome message
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    user?.displayName != null && user!.displayName!.isNotEmpty
                        ? 'Hey, ${user.displayName}!'
                        : 'Hey there!',
                    style: const TextStyle(
                      fontFamily: 'NunitoSans',
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E3D36),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // List of menu buttons
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: menuItems.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final item = menuItems[i];
                    return ElevatedButton(
                      style: buttonStyle,
                      onPressed: () => Navigator.pushNamed(context, item.route),
                      child: Row(
                        children: [
                          Icon(item.icon, size: 28, color: const Color(0xFF1E3D36)),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              item.title,
                              style: const TextStyle(
                                fontFamily: 'NunitoSans',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E3D36),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Helper class to store each menu item’s info
class _MenuItem {
  final String title;
  final IconData icon;
  final String route;

  _MenuItem(this.title, this.icon, this.route);
}
