import 'package:flutter/material.dart';
import 'package:waste_wise/adminanalytics.dart';
import 'package:waste_wise/workerprofile.dart';
import 'package:waste_wise/workersettings.dart';
import 'package:waste_wise/workercalendar.dart';

class WorkerHomePage extends StatefulWidget {
  const WorkerHomePage({super.key});

  @override
  _WasteWiseHomePageState createState() => _WasteWiseHomePageState();
}

class _WasteWiseHomePageState extends State<WorkerHomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    const WorkerHomePage(),
    WorkerProfilePage(),
    const WorkerSettingsPage(),
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
        automaticallyImplyLeading: false,
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
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 10), // Add vertical spacing
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WorkerCalendarPage(
                        workerEmail: '',
                        workerWard: '',
                      ),
                    ),
                  );
                },
                icon: Icon(Icons.calendar_today),
                label: const Text('Calendar'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 10), // Add vertical spacing
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminAnalyticsPage(
                        onSelectAnalyticsType: (String) {},
                      ),
                    ),
                  );
                },
                icon: Icon(Icons.analytics),
                label: const Text('Analytics'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: TextStyle(fontSize: 20),
                  primary: Colors.green,
                  onPrimary: Colors.white,
                  elevation: 2,
                ),
              ),
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
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
