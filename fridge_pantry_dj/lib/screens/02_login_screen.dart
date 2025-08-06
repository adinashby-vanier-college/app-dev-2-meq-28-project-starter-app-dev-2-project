// Login screen of our app
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
        // Keeps content inside safe screen area
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Back arrow to return to the previous screen
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Color(0xFF1E3D36)),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(height: 16),

                // Logo inside a frosted-glass circle
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12.withOpacity(0.12),
                        blurRadius: 14,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Image.asset('assets/logoo.png'),
                  ),
                ),

                const SizedBox(height: 24),

                // Big title text
                const Text(
                  'Login',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Pacifico',
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3D36),
                  ),
                ),
                const SizedBox(height: 8),

                // Small subtitle text
                const Text(
                  'Sign in to continue',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'NunitoSans',
                    fontSize: 16,
                    color: Color(0xFF1E3D36),
                  ),
                ),

                const SizedBox(height: 32),

                // Email label
                const Text(
                  'EMAIL',
                  style: TextStyle(
                    fontFamily: 'NunitoSans',
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E3D36),
                  ),
                ),
                const SizedBox(height: 8),

                // Email input field
                TextField(
                  decoration: InputDecoration(
                    hintText: 'hello@world.com',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 24),

                // Password label
                const Text(
                  'PASSWORD',
                  style: TextStyle(
                    fontFamily: 'NunitoSans',
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E3D36),
                  ),
                ),
                const SizedBox(height: 8),

                // Password input field (hidden text)
                TextField(
                  decoration: InputDecoration(
                    hintText: '••••••',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  obscureText: true, // hides password characters
                ),

                const SizedBox(height: 32),

                // Sign in button
                ElevatedButton(
                  onPressed: () {
                    // TODO: connect to Firebase authentication
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5EAAA8),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    textStyle: const TextStyle(
                      fontFamily: 'NunitoSans',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text('sign in'),
                ),

                const SizedBox(height: 16),

                // Link to registration screen
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontFamily: 'NunitoSans',
                        color: Color(0xFF1E3D36),
                      ),
                      children: [
                        const TextSpan(text: 'Don’t have an account? '),
                        TextSpan(
                          text: 'Sign up',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          recognizer: null, // You can add a tap gesture later
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Divider with "or" in the middle
                Row(
                  children: const [
                    Expanded(child: Divider(color: Color(0xFF1E3D36))),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        'or',
                        style: TextStyle(
                          fontFamily: 'NunitoSans',
                          color: Color(0xFF1E3D36),
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: Color(0xFF1E3D36))),
                  ],
                ),

                const SizedBox(height: 24),

                // TODO :add social login buttons
              ],
            ),
          ),
        ),
      ),
    );
  }
}
