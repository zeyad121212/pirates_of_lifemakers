import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;
  const ProfileScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _emailController;
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'en';
  bool _loading = true;
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _loadPrefs();
  }

  Future<void> _fetchUserData() async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(widget.userId).get();
    if (doc.exists) {
      setState(() {
        _userData = doc.data();
        _emailController = TextEditingController(text: _userData?['email'] ?? '');
        _loading = false;
      });
    }
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
      _selectedLanguage = prefs.getString('language') ?? 'en';
    });
  }

  Future<void> _saveProfile() async {
    // Only allow email update if not updated before
    if (_userData?['emailUpdated'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email can only be updated once.')));
      return;
    }
    await FirebaseFirestore.instance.collection('users').doc(widget.userId).update({
      'email': _emailController.text.trim(),
      'emailUpdated': true,
    });
    setState(() {
      _userData?['email'] = _emailController.text.trim();
      _userData?['emailUpdated'] = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated.')));
  }

  Future<void> _toggleNotifications(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', enabled);
    setState(() => _notificationsEnabled = enabled);
  }

  Future<void> _changeLanguage(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', lang);
    setState(() => _selectedLanguage = lang);
    // TODO: Trigger app-wide language change
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: _userData?['profilePictureUrl'] != null
                  ? NetworkImage(_userData!['profilePictureUrl'])
                  : null,
              child: _userData?['profilePictureUrl'] == null ? const Icon(Icons.person, size: 40) : null,
            ),
            const SizedBox(height: 16),
            Text('Name: ${_userData?['name'] ?? ''}'),
            Text('Code: ${_userData?['code'] ?? ''}'),
            Text('Role: ${_userData?['role'] ?? ''}'),
            Text('Province: ${_userData?['province'] ?? ''}'),
            Text('Last Activity: ${_userData?['lastActivity'] ?? ''}'),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              enabled: !(_userData?['emailUpdated'] ?? false),
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Language:'),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  value: _selectedLanguage,
                  items: const [
                    DropdownMenuItem(value: 'en', child: Text('English')),
                    DropdownMenuItem(value: 'ar', child: Text('العربية')),
                  ],
                  onChanged: (lang) {
                    if (lang != null) _changeLanguage(lang);
                  },
                ),
              ],
            ),
            SwitchListTile(
              value: _notificationsEnabled,
              onChanged: _toggleNotifications,
              title: const Text('Enable Notifications'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveProfile,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
