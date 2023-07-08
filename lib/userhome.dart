import 'package:flutter/material.dart';
import 'package:waste_wise/usersettings.dart';
import 'package:waste_wise/usercalendar.dart';
import 'package:waste_wise/usercomplaint.dart';
import 'package:waste_wise/userpayment.dart';
import 'package:waste_wise/userprofile.dart';
import 'package:waste_wise/userstatus.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({Key? key});

  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
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
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Hello, User!',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserCalendarPage(
                      userWard: '',
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.calendar_today),
              label: const Text('  Calendar  '),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PaymentPage1(),
                  ),
                );
              },
              icon: const Icon(Icons.payment),
              label: const Text('  Payment  '),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ComplaintScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.warning),
              label: const Text(' Complaint '),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserStatusPage(),
                  ),
                );
              },
              icon: const Icon(Icons.analytics_outlined),
              label: const Text('     Status     '),
            ),
          ],
        ),
      ),
      //body: _pages[_selectedIndex],
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

class CalendarPage extends StatelessWidget {
  const CalendarPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar Page'),
      ),
      body: const Center(
        child: Text('Calendar Page'),
      ),
    );
  }
}
