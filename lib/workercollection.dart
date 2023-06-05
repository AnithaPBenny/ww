import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class WorkerCollection extends StatefulWidget {
  @override
  _WorkerCollectionState createState() => _WorkerCollectionState();
}

class _WorkerCollectionState extends State<WorkerCollection> {
  String selectedWard = '';
  String selectedText = '';
  List<bool> checkedItems = [];

  List<String> wardList = [
    'Ward 1',
    'Ward 2',
    'Ward 3',
  ];

  Map<String, List<String>> wardTextMap = {
    'Ward 1': ['House 1', 'House 2', 'House 3'],
    'Ward 2': ['House 1', 'House 2', 'House 3'],
    'Ward 3': ['House 1', 'House 2', 'House 3'],
  };

  @override
  void initState() {
    super.initState();
    checkedItems = List<bool>.filled(wardList.length, false);
    initializeFirebase();
  }

  void initializeFirebase() async {
    // Initialize Firebase
    await Firebase.initializeApp();
  }

  void submitDataToAdmin() {
    DatabaseReference databaseRef = FirebaseDatabase.instance.reference();

    // Create a data structure to store the updated data
    Map<String, dynamic> updatedData = {
      'ward': selectedWard,
      'checkedItems': checkedItems,
    };

    // Send the updated data to the admin node in the database
    databaseRef.child('admin').set(updatedData).then((_) {
      // Data successfully sent to the admin
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data submitted to admin successfully!'),
        ),
      );
    }).catchError((error) {
      // Error occurred while sending data to the admin
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit data to admin. Error: $error'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Collection'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: selectedWard.isNotEmpty ? selectedWard : null,
              items: wardList.map((ward) {
                return DropdownMenuItem<String>(
                  value: ward,
                  child: Text(ward),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedWard = value ?? '';
                  selectedText = '';

                  // Update the checkedItems list when the selected ward changes
                  checkedItems = List<bool>.filled(
                      wardTextMap[selectedWard]?.length ?? 0, false);
                });
              },
              decoration: const InputDecoration(
                labelText: 'Ward',
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: wardTextMap[selectedWard]?.length ?? 0,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(wardTextMap[selectedWard]?[index] ?? ''),
                    leading: Checkbox(
                      value: checkedItems[index],
                      onChanged: (value) {
                        setState(() {
                          checkedItems[index] = value ?? false;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Perform save action
                  },
                  child: const Text('Save'),
                ),
                const SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: submitDataToAdmin,
                  child: const Text('Submit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
