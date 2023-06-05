import 'package:flutter/material.dart';
import 'package:waste_wise/settings.dart';
import 'package:waste_wise/userprofile.dart';
import 'package:waste_wise/workercollection.dart';
import 'package:waste_wise/workerpayment.dart';

class WorkerHomePage extends StatefulWidget {
  @override
  _WasteWiseHomePageState createState() => _WasteWiseHomePageState();
}

class _WasteWiseHomePageState extends State<WorkerHomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    WorkerHomePage(),
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
        title: const Text('Waste Wise'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Hello, Worker!',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CalendarPage()),
                );
              },
              child: const Text('Calendar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WorkerPayment()),
                );
              },
              child: const Text('Payment'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AnalyticsPage()),
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
              child: const Text('Collection'),
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

class CalendarPage extends StatelessWidget {
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

class CollectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Collection Page'),
      ),
      body: const Center(
        child: Text('Collection Page'),
      ),
    );
  }
}

class PaymentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Page'),
      ),
      body: const Center(
        child: Text('Payment Page'),
      ),
    );
  }
}

class AnalyticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics Page'),
      ),
      body: const Center(
        child: Text('Analytics Page'),
      ),
    );
  }
}
