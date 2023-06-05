import 'package:flutter/material.dart';
import 'package:waste_wise/languageselect.dart';
import 'package:waste_wise/themeselect.dart';
import 'package:waste_wise/userfeedback.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Center(
        child: Container(
          width: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LanguageSelectionPage(),
                      ),
                    );
                  },
                  child: Text('Change Language'),
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ThemeSelectionPage(),
                      ),
                    );
                  },
                  child: Text('Change Theme'),
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RatingScreen(),
                      ),
                    );
                  },
                  child: Text('Rate App'),
                ),
              ),
              // Add more settings options as needed
            ],
          ),
        ),
      ),
    );
  }
}
