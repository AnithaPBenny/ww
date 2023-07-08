import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:waste_wise/userhome.dart';
import 'package:waste_wise/userlogin.dart';
import 'package:waste_wise/usersettings.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<UserProfilePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const UserHomePage(),
    const UserProfilePage(),
    const UserSettingsPage(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => _pages[index]),
    );
  }

  late DatabaseReference _userRef;
  late User _currentUser;
  String name = '';
  String ward = '';
  String panchayth = '';

  @override
  void initState() {
    super.initState();
    _userRef = FirebaseDatabase.instance.reference().child('users');
    _currentUser = FirebaseAuth.instance.currentUser!;
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    _userRef.child(_currentUser.uid).onValue.listen((event) {
      final snapshot = event.snapshot;
      final data = snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        setState(() {
          name = data['username'] as String? ?? '';
          ward = data['ward'] as String? ?? '';
          panchayth = data['panchayath'] as String? ?? '';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              child: Text(
                name.isNotEmpty ? name[0] : '',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'ward:$ward',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              panchayth,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserLoginPage(),
                  ),
                );
                // Implement logout functionality here
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
