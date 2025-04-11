import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _statusMessage;
  bool _isLoading = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    final user = _auth.currentUser;
    if (user == null) return;

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _statusMessage = null;
      _isLoading = true;
    });

    final cred = EmailAuthProvider.credential(
      email: user.email!,
      password: _currentPasswordController.text.trim(),
    );

    try {
      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(_newPasswordController.text.trim());

      setState(() {
        _statusMessage = 'Password updated successfully';
      });

      _currentPasswordController.clear();
      _newPasswordController.clear();
    } on FirebaseAuthException catch (e) {
      setState(() {
        _statusMessage = 'Error: ${e.message}';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _signOut() async {
    await _auth.signOut();
    if (context.mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userEmail = _auth.currentUser?.email ?? 'No Email';

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Text('Signed in as: $userEmail', style: const TextStyle(fontSize: 16)),
            SizedBox(height: 24),
            Text('Change Password', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _currentPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Current Password',
                    ),
                    validator: (value) => value!.isEmpty ? 'Enter current password' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _newPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'New Password',
                    ),
                    validator: (value) =>
                        value != null && value.length >= 6 ? null : 'Minimum 6 characters',
                  ),
                  SizedBox(height: 12),
                  _isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _changePassword,
                          child: const Text('Update Password'),
                        ),
                  if (_statusMessage != null) ...[
                    SizedBox(height: 10),
                    Text(
                      _statusMessage!,
                      style: TextStyle(
                        color: _statusMessage!.startsWith('Error') ? Colors.red : Colors.green,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Divider(height: 40),
            ElevatedButton.icon(
              onPressed: _signOut,
              icon: const Icon(Icons.logout),
              label: const Text('Log Out'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
