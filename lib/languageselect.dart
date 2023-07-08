import 'package:flutter/material.dart';

class LanguageSelectionPage extends StatefulWidget {
  const LanguageSelectionPage({super.key});

  @override
  _LanguageSelectionPageState createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
  late String selectedLanguage;

  @override
  void initState() {
    super.initState();
    // Set English as the default language
    selectedLanguage = 'en';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Language Selection'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('English'),
            leading: Radio(
              value: 'en',
              groupValue: selectedLanguage,
              onChanged: (value) {
                setState(() {
                  selectedLanguage = value!;
                });
              },
            ),
          ),
          /* ListTile(
            title: const Text('Malayalam'),
            leading: Radio(
              value: 'ml',
              groupValue: selectedLanguage,
              onChanged: (value) {
                setState(() {
                  selectedLanguage = value!;
                });
              },
            ),
          ),*/
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Save the selected language and navigate back
          Navigator.pop(context, selectedLanguage);
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
