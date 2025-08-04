import 'package:flutter/material.dart';

class ShopAroundScreen extends StatelessWidget {
  const ShopAroundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: SafeArea(
          child: Column(
              children: [
          // App Bar
          Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back,
                  color: Color(0xFF1E3D36),
                  size: 28,
                ),
              ),
              const Text(
                'Shop Around',
                style: TextStyle(
                  fontFamily: 'Pacifico',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3D36),
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
        ),
        // Content Area
          ]
          ),
        ),
      ),
    );
  }
}