import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Controllers for text fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController postcodeController = TextEditingController();

  // Original values to restore on cancel
  String originalName = '';
  String originalEmail = '';
  String originalPostcode = '';

  @override
  void initState() {
    super.initState();
    // Load current user data (replace with actual database call)
    _loadUserData();
  }

  void _loadUserData() {
    // TODO: Replace with actual user data from Firebase/database
    originalName = 'Hello World';
    originalEmail = 'hello@world.com';
    originalPostcode = 'H2U 8I9';

    nameController.text = originalName;
    emailController.text = originalEmail;
    postcodeController.text = originalPostcode;
  }

  void _saveChanges() {
    // TODO: Save to Firebase/database
    setState(() {
      originalName = nameController.text;
      originalEmail = emailController.text;
      originalPostcode = postcodeController.text;
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings saved successfully!'),
        backgroundColor: Color(0xFF5EAAA8),
      ),
    );

    Navigator.pop(context);
  }

  void _cancelChanges() {
    // Restore original values
    setState(() {
      nameController.text = originalName;
      emailController.text = originalEmail;
      postcodeController.text = originalPostcode;
    });

    Navigator.pop(context);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    postcodeController.dispose();
    super.dispose();
  }

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
              // Top bar with back button and title
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
                      'Settings',
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

              // Content Area
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Welcome message with dynamic user name
                      Text(
                        'Hey, ${nameController.text.isEmpty ? 'User' : nameController.text}',
                        style: const TextStyle(
                          fontFamily: 'NunitoSans',
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E3D36),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Edit Your Personal Information',
                        style: TextStyle(
                          fontFamily: 'NunitoSans',
                          fontSize: 16,
                          color: Color(0xFF1E3D36),
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Name field
                      const Text(
                        'NAME',
                        style: TextStyle(
                          fontFamily: 'NunitoSans',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E3D36),
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFB8D4E3),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: TextField(
                          controller: nameController,
                          onChanged: (value) =>
                              setState(() {}), // Update greeting dynamically
                          style: const TextStyle(
                            fontFamily: 'NunitoSans',
                            fontSize: 16,
                            color: Color(0xFF1E3D36),
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Email field
                      const Text(
                        'EMAIL',
                        style: TextStyle(
                          fontFamily: 'NunitoSans',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E3D36),
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFB8D4E3),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: TextField(
                          controller: emailController,
                          style: const TextStyle(
                            fontFamily: 'NunitoSans',
                            fontSize: 16,
                            color: Color(0xFF1E3D36),
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Postcode field
                      const Text(
                        'POSTCODE',
                        style: TextStyle(
                          fontFamily: 'NunitoSans',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E3D36),
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFB8D4E3),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: TextField(
                          controller: postcodeController,
                          style: const TextStyle(
                            fontFamily: 'NunitoSans',
                            fontSize: 16,
                            color: Color(0xFF1E3D36),
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 60), // Extra space before buttons
                      // Save and Cancel buttons
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Row(
                          children: [
                            // Save button
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF5EAAA8),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                ),
                                onPressed: _saveChanges,
                                child: const Text(
                                  'Save',
                                  style: TextStyle(
                                    fontFamily: 'NunitoSans',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Cancel button
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[400],
                                  foregroundColor: const Color(0xFF1E3D36),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                ),
                                onPressed: _cancelChanges,
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontFamily: 'NunitoSans',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
