import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController postcodeController = TextEditingController();
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String originalName = '';
  String originalEmail = '';
  String originalPostcode = '';

  bool _isEditingInfo = false;
  bool _isChangingPassword = false;
  bool _isLoading = false;
  bool _showCurrentPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;
  bool _showDeletePassword = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      originalName = user.displayName ?? 'User';
      originalEmail = user.email ?? '';
      
      // Load postcode from FBRD
      try {
        final database = FirebaseDatabase.instance;
        final userRef = database.ref('users/${user.uid}');
        final snapshot = await userRef.get();
        
        if (snapshot.exists) {
          final userData = snapshot.value as Map<dynamic, dynamic>;
          originalPostcode = userData['postcode'] ?? '';
        }
      } catch (e) {
        originalPostcode = '';
      }
    } else {

      originalName = 'Hello World';
      originalEmail = 'hello@world.com';
      originalPostcode = '';
    }

    nameController.text = originalName;
    emailController.text = originalEmail;
    postcodeController.text = originalPostcode;
    
    if (mounted) setState(() {});
  }

  void _toggleEditInfo() {
    setState(() {
      if (_isEditingInfo) {
        nameController.text = originalName;
        emailController.text = originalEmail;
        postcodeController.text = originalPostcode;
      }
      _isEditingInfo = !_isEditingInfo;
      _isChangingPassword = false;
    });
  }

  void _toggleChangePassword() {
    setState(() {
      _isChangingPassword = !_isChangingPassword;
      _isEditingInfo = false;

      currentPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();
    });
  }

  Future<void> _saveUserInfo() async {
    setState(() => _isLoading = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {

        if (nameController.text.trim() != originalName) {
          await user.updateDisplayName(nameController.text.trim());
        }


        if (emailController.text.trim() != originalEmail) {
          await user.verifyBeforeUpdateEmail(emailController.text.trim());
        }

        // Save postcode FBRT
        final database = FirebaseDatabase.instance;
        final userRef = database.ref('users/${user.uid}');
        await userRef.update({'postcode': postcodeController.text.trim()});


        setState(() {
          originalName = nameController.text.trim();
          originalEmail = emailController.text.trim();
          originalPostcode = postcodeController.text.trim();
          _isEditingInfo = false;
        });

        _showSuccessMessage('Profile updated successfully!');
      }
    } on FirebaseAuthException catch (e) {
      _showErrorMessage('Failed to update profile: ${e.message}');
    } catch (e) {
      _showErrorMessage('An error occurred while updating profile');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _changePassword() async {
    if (newPasswordController.text != confirmPasswordController.text) {
      _showErrorMessage('New passwords do not match');
      return;
    }

    if (newPasswordController.text.length < 6) {
      _showErrorMessage('New password must be at least 6 characters');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {


        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPasswordController.text,
        );
        await user.reauthenticateWithCredential(credential);


        await user.updatePassword(newPasswordController.text);

        setState(() => _isChangingPassword = false);
        currentPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();

        _showSuccessMessage('Password changed successfully!');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        _showErrorMessage('Current password is incorrect');
      } else {
        _showErrorMessage('Failed to change password: ${e.message}');
      }
    } catch (e) {
      _showErrorMessage('An error occurred while changing password');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _logout() async {
    final shouldLogout = await _showConfirmationDialog(
      'Logout',
      'Are you sure you want to logout?',
    );

    if (shouldLogout) {
      try {
        await FirebaseAuth.instance.signOut();
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
            (route) => false,
          );
        }
      } catch (e) {
        _showErrorMessage('Failed to logout');
      }
    }
  }

  Future<void> _deleteAccount() async {
    final shouldDelete = await _showConfirmationDialog(
      'Delete Account',
      'Are you sure you want to permanently delete your account? This action cannot be undone.',
      isDestructive: true,
    );
    //Ask password when deleting
    if (shouldDelete) {

      final password = await _showPasswordDialog();
      if (password != null) {
        setState(() => _isLoading = true);
        try {
          final user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            // Re-authenticate before deleting
            final credential = EmailAuthProvider.credential(
              email: user.email!,
              password: password,
            );
            await user.reauthenticateWithCredential(credential);

            // Delete user from FBRD
            final database = FirebaseDatabase.instance;
            final userRef = database.ref('users/${user.uid}');
            await userRef.remove();

            await user.delete();

            if (mounted) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            }
          }
        } on FirebaseAuthException catch (e) {
          if (e.code == 'wrong-password') {
            _showErrorMessage('Incorrect password');
          } else {
            _showErrorMessage('Failed to delete account: ${e.message}');
          }
        } catch (e) {
          _showErrorMessage('An error occurred while deleting account');
        } finally {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  Future<bool> _showConfirmationDialog(
    String title,
    String content, {
    bool isDestructive = false,
  }) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: const Color.fromARGB(255, 235, 253, 251),
            title: Text(
              title,
              style: const TextStyle(
                fontFamily: 'NunitoSans',
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3D36),
              ),
            ),
            content: Text(
              content,
              style: const TextStyle(
                fontFamily: 'NunitoSans',
                color: Color(0xFF1E3D36),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Color.fromARGB(255, 146, 148, 148)),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  isDestructive ? 'Delete' : 'Confirm',
                  style: TextStyle(
                    color: isDestructive
                        ? Colors.red[700]
                        : const Color.fromARGB(255, 20, 170, 165),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<String?> _showPasswordDialog() async {
    final TextEditingController passwordController = TextEditingController();
    return await showDialog<String>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFFD1E8E5),
          title: const Text(
            'Enter Password',
            style: TextStyle(
              fontFamily: 'NunitoSans',
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E3D36),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Enter password to delete account:',
                style: TextStyle(
                  fontFamily: 'NunitoSans',
                  color: Color(0xFF1E3D36),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: !_showDeletePassword,
                decoration: InputDecoration(
                  hintText: 'Password',
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.7),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showDeletePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: const Color(0xFF1E3D36),
                    ),
                    onPressed: () {
                      setDialogState(() {
                        _showDeletePassword = !_showDeletePassword;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _showDeletePassword =
                    false;
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Color(0xFF5EAAA8)),
              ),
            ),
            TextButton(
              onPressed: () {
                _showDeletePassword =
                    false;
                Navigator.pop(context, passwordController.text);
              },
              child: Text(
                'Confirm',
                style: TextStyle(
                  color: Colors.red[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF5EAAA8),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red[600]),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    postcodeController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
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

                      Text(
                        'Hey, ${originalName.isEmpty ? 'User' : originalName}',
                        style: const TextStyle(
                          fontFamily: 'NunitoSans',
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E3D36),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Manage Your Account',
                        style: TextStyle(
                          fontFamily: 'NunitoSans',
                          fontSize: 16,
                          color: Color(0xFF1E3D36),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // User Information Section
                      if (_isEditingInfo) ...[
                        _buildEditInfoSection(),
                      ] else ...[
                        _buildInfoDisplaySection(),
                      ],

                      const SizedBox(height: 24),

                      // Change Password Section
                      if (_isChangingPassword) ...[
                        _buildChangePasswordSection(),
                      ] else ...[
                        _buildPasswordButton(),
                      ],

                      const SizedBox(height: 32),

                      // Account Actions Section
                      _buildAccountActionsSection(),
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

  Widget _buildInfoDisplaySection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Personal Information',
            style: TextStyle(
              fontFamily: 'NunitoSans',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E3D36),
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Name', nameController.text),
          _buildInfoRow('Email', emailController.text),
          _buildInfoRow('Postcode', postcodeController.text),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _toggleEditInfo,
            icon: const Icon(Icons.edit, size: 18),
            label: const Text('Edit Information'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5EAAA8),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontFamily: 'NunitoSans',
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E3D36),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: 'NunitoSans',
                color: Color(0xFF1E3D36),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditInfoSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Edit Personal Information',
            style: TextStyle(
              fontFamily: 'NunitoSans',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E3D36),
            ),
          ),
          const SizedBox(height: 20),

          // Name field
          _buildEditField('NAME', nameController),
          const SizedBox(height: 16),

          // Email field
          _buildEditField('EMAIL', emailController),
          const SizedBox(height: 16),

          // Postcode field
          _buildEditField('POSTCODE', postcodeController),
          const SizedBox(height: 20),

          // Save and Cancel buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveUserInfo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5EAAA8),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text('Save Changes'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _toggleEditInfo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[400],
                    foregroundColor: const Color(0xFF1E3D36),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEditField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
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
            controller: controller,
            onChanged: (value) => setState(() {}),
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
      ],
    );
  }

  Widget _buildPasswordButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Security',
            style: TextStyle(
              fontFamily: 'NunitoSans',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E3D36),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _toggleChangePassword,
            icon: const Icon(Icons.lock_outline, size: 18),
            label: const Text('Change Password'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5EAAA8),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChangePasswordSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Change Password',
            style: TextStyle(
              fontFamily: 'NunitoSans',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E3D36),
            ),
          ),
          const SizedBox(height: 20),

          // Current password field
          _buildPasswordField(
            'CURRENT PASSWORD',
            currentPasswordController,
            fieldType: 'current',
          ),

          // New password field
          _buildPasswordField(
            'NEW PASSWORD',
            newPasswordController,
            fieldType: 'new',
          ),

          // Confirm new password field
          _buildPasswordField(
            'CONFIRM NEW PASSWORD',
            confirmPasswordController,
            fieldType: 'confirm',
          ),
          const SizedBox(height: 20),

          // Change and Cancel buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _changePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5EAAA8),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text('Change Password'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _toggleChangePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[400],
                    foregroundColor: const Color(0xFF1E3D36),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField(
    String label,
    TextEditingController controller, {
    String? fieldType,
  }) {
    bool showPassword = false;
    VoidCallback toggleVisibility = () {};

    // toogle password visibility
    switch (fieldType) {
      case 'current':
        showPassword = _showCurrentPassword;
        toggleVisibility = () =>
            setState(() => _showCurrentPassword = !_showCurrentPassword);
        break;
      case 'new':
        showPassword = _showNewPassword;
        toggleVisibility = () =>
            setState(() => _showNewPassword = !_showNewPassword);
        break;
      case 'confirm':
        showPassword = _showConfirmPassword;
        toggleVisibility = () =>
            setState(() => _showConfirmPassword = !_showConfirmPassword);
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
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
            controller: controller,
            obscureText: !showPassword,
            style: const TextStyle(
              fontFamily: 'NunitoSans',
              fontSize: 16,
              color: Color(0xFF1E3D36),
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  showPassword ? Icons.visibility_off : Icons.visibility,
                  color: const Color(0xFF1E3D36),
                ),
                onPressed: toggleVisibility,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAccountActionsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Account Actions',
            style: TextStyle(
              fontFamily: 'NunitoSans',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E3D36),
            ),
          ),
          const SizedBox(height: 16),

          // Logout button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _logout,
              icon: const Icon(Icons.logout, size: 18),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[600],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Delete account button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isLoading ? null : _deleteAccount,
              icon: const Icon(Icons.delete_forever, size: 18),
              label: const Text('Delete Account'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[600],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
