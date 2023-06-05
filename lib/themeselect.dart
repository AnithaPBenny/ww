import 'package:flutter/material.dart';

class ThemeSelectionPage extends StatefulWidget {
  @override
  _ThemeSelectionPageState createState() => _ThemeSelectionPageState();
}

class _ThemeSelectionPageState extends State<ThemeSelectionPage> {
  bool _isDarkThemeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Theme'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Select Theme:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16),
            SwitchListTile(
              title: Text('Dark Theme'),
              value: _isDarkThemeEnabled,
              onChanged: (value) {
                setState(() {
                  _isDarkThemeEnabled = value;
                });
                _changeTheme();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _changeTheme() {
    final ThemeData newTheme =
        _isDarkThemeEnabled ? ThemeData.dark() : ThemeData.light();
    // You can customize the theme further if needed

    // Apply the new theme to the app
    final MaterialApp app = MaterialApp(
      theme: newTheme,
      // Add other MaterialApp properties as needed
    );
    // Push a new route with the updated theme
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => app),
      (Route<dynamic> route) => false,
    );
  }
}
