import 'package:flutter/material.dart';
import 'package:waste_wise/adminanalytics.dart';
import 'package:waste_wise/admincalender.dart';
import 'package:waste_wise/userprofile.dart';
import 'package:waste_wise/workercollection.dart';
import 'package:waste_wise/settings.dart';
import 'package:waste_wise/userhome.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  _WasteWiseHomePageState createState() => _WasteWiseHomePageState();
}

class _WasteWiseHomePageState extends State<AdminHomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    const AdminHomePage(),
    const ProfilePage(
      email: '',
      name: '',
      phone: '',
      photoUrl: '',
    ),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to the selected page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => _pages[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WasteWise'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Hello, Admin!',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminCalendarPage()),
                );
              },
              child: const Text('Calendar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AdminAnalyticsPage(
                            animate: true,
                            seriesList: [],
                          )),
                );
              },
              child: const Text('Analytics'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WorkerCollection()),
                );
              },
              child: const Text('Compalints'),
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
