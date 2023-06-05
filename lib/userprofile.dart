import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final String name;
  final String photoUrl;
  final String email;
  final String phone;

  // ignore: use_key_in_widget_constructors
  const ProfilePage({
    required this.name,
    required this.photoUrl,
    required this.email,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(photoUrl),
            ),
            const SizedBox(height: 16),
            Text(
              name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(email),
            const SizedBox(height: 8),
            Text(phone),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Implement logout functionality here
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
