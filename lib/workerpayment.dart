import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class WorkerPayment extends StatefulWidget {
  @override
  _CollectionBoxState createState() => _CollectionBoxState();
}

class _CollectionBoxState extends State<WorkerPayment> {
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

  DatabaseReference databaseRef = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();
    checkedItems = List<bool>.filled(wardList.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Payment Status'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
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
            SizedBox(height: 16.0),
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
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    saveCheckedItems();
                  },
                  child: Text('Save'),
                ),
                SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () {
                    // Perform submit action
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void saveCheckedItems() {
    List<String> savedItems = [];

    for (int i = 0; i < checkedItems.length; i++) {
      if (checkedItems[i]) {
        savedItems.add(wardTextMap[selectedWard]?[i] ?? '');
      }
    }

    databaseRef
        .child('payments')
        .child(selectedWard)
        .set(savedItems)
        .then((value) {
      print('Checked items saved to Realtime Database');
    }).catchError((error) {
      print('Error saving checked items to Realtime Database: $error');
    });
  }
}
