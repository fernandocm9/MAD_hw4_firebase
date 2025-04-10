import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _userRoleController = TextEditingController();

  String _email = '';
  String _userId = '';
  String _registrationDate = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    if (doc.exists) {
      final data = doc.data()!;
      _firstNameController.text = data['first_name'] ?? '';
      _lastNameController.text = data['last_name'] ?? '';
      _userRoleController.text = data['user_role'] ?? '';
      _email = data['email'] ?? user.email ?? '';
      _userId = data['user_id'] ?? user.uid;
      Timestamp? timestamp = data['registration_datetime'];
      _registrationDate = timestamp != null
          ? timestamp.toDate().toString()
          : 'Not recorded';
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'first_name': _firstNameController.text.trim(),
      'last_name': _lastNameController.text.trim(),
      'user_role': _userRoleController.text.trim(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated')),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _userRoleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Profile'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _firstNameController,
                      decoration: const InputDecoration(labelText: 'First Name'),
                      validator: (value) => value!.isEmpty ? 'Required' : null,
                    ),
                    TextFormField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(labelText: 'Last Name'),
                      validator: (value) => value!.isEmpty ? 'Required' : null,
                    ),
                    TextFormField(
                      controller: _userRoleController,
                      decoration: const InputDecoration(labelText: 'User Role'),
                      validator: (value) => value!.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 24),
                    Text('Email: $_email'),
                    const SizedBox(height: 8),
                    Text('User ID: $_userId'),
                    const SizedBox(height: 8),
                    Text('Registered: $_registrationDate'),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _saveProfile,
                      child: const Text('Save Changes'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
