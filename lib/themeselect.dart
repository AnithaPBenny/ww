import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Theme Demo',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: ThemeSelectionPage(),
    );
  }
}

class ThemeSelectionPage extends StatefulWidget {
  const ThemeSelectionPage({Key? key}) : super(key: key);

  @override
  _ThemeSelectionPageState createState() => _ThemeSelectionPageState();
}

class _ThemeSelectionPageState extends State<ThemeSelectionPage> {
  bool _isDarkThemeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Theme'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Select Theme:',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Dark Theme'),
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
    final theme = _isDarkThemeEnabled ? ThemeData.dark() : ThemeData.light();
    // Update the theme for the entire app
    MaterialApp app = MaterialApp(
      theme: theme,
      darkTheme: theme,
      // Add other MaterialApp properties as needed
      home: ThemeSelectionPage(),
    );

    // Reload the app with the updated theme
    runApp(app);
  }
}
