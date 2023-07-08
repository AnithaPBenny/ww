import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class WorkerPayment extends StatefulWidget {
  const WorkerPayment({Key? key}) : super(key: key);

  @override
  _WorkerPaymentState createState() => _WorkerPaymentState();
}

class _WorkerPaymentState extends State<WorkerPayment> {
  String selectedWard = '';
  List<bool> checkedItems = [];
  List<String> usernames = [];

  DatabaseReference databaseRef = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();
    checkedItems = [];
    fetchUsernames();
  }

  Future<void> fetchUsernames() async {
    // Fetch the current worker's ward from the database
    DatabaseReference wardRef =
        databaseRef.child('workers').child('currentWorker').child('ward');
    DatabaseEvent wardEvent = await wardRef.once();
    DataSnapshot wardSnapshot = wardEvent.snapshot;

    setState(() {
      selectedWard = wardSnapshot.value.toString();
    });

    // Fetch usernames from the "users" node matching the current worker's ward
    DatabaseReference usersRef = databaseRef.child('users');
    DatabaseEvent usersEvent = await usersRef.once();
    DataSnapshot usersSnapshot = usersEvent.snapshot;

    Map<dynamic, dynamic>? usersData =
        usersSnapshot.value as Map<dynamic, dynamic>?;

    List<String> matchedUsernames = [];

    if (usersData != null) {
      usersData.forEach((key, value) {
        if (value['ward'] == selectedWard) {
          matchedUsernames.add(value['username']);
        }
      });
    }

    setState(() {
      usernames = matchedUsernames;
      checkedItems = List<bool>.filled(usernames.length, false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Payment Status'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: usernames.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(usernames[index]),
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
                    saveCheckedItems();
                  },
                  child: const Text('Save'),
                ),
                const SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () {
                    // Perform submit action
                  },
                  child: const Text('Submit'),
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
        savedItems.add(usernames[i]);
      }
    }

    DatabaseReference paymentsRef =
        databaseRef.child('payments').child(selectedWard);

    paymentsRef.set(savedItems).then((value) {
      print('Checked items saved to Realtime Database');
    }).catchError((error) {
      print('Error saving checked items to Realtime Database: $error');
    });
  }
}
