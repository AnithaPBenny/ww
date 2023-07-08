import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class UserStatusPage extends StatefulWidget {
  @override
  _UserStatusPageState createState() => _UserStatusPageState();
}

class _UserStatusPageState extends State<UserStatusPage> {
  List<MonthStatus> months = [
    MonthStatus('January'),
    MonthStatus('February'),
    MonthStatus('March'),
    MonthStatus('April'),
    MonthStatus('May'),
    MonthStatus('June'),
    MonthStatus('July'),
    MonthStatus('August'),
    MonthStatus('September'),
    MonthStatus('October'),
    MonthStatus('November'),
    MonthStatus('December'),
  ];

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final DatabaseReference databaseReference =
      FirebaseDatabase.instance.reference().child('payments');

  late String currentUserID;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    loadDataFromDatabase();
  }

  void getCurrentUser() {
    final User? user = _firebaseAuth.currentUser;
    if (user != null) {
      currentUserID = user.uid;
    }
  }

  void loadDataFromDatabase() {
    DatabaseReference collectionRef = FirebaseDatabase.instance
        .reference()
        .child('payments')
        .child('collection')
        .child(currentUserID);

    DatabaseReference paymentRef =
        FirebaseDatabase.instance.reference().child('payments');

    collectionRef.once().then((event) {
      final collectionData = event.snapshot.value as Map<dynamic, dynamic>;
      if (collectionData != null) {
        collectionData.forEach((key, value) {
          final monthStatus = months.firstWhere(
            (month) => month.name == key,
            orElse: () => MonthStatus(''),
          );
          if (monthStatus != null) {
            monthStatus.collection = value ?? false;
          }
        });
      }

      paymentRef.once().then((event) {
        final paymentData = event.snapshot.value as Map<dynamic, dynamic>;
        paymentData.forEach((key, value) {
          final monthStatus = months.firstWhere(
            (month) => month.name == value['month'],
            orElse: () => MonthStatus(''),
          );
          if (value['user_id'] == currentUserID) {
            monthStatus.payment = true;
          } else {
            monthStatus.payment = false;
          }
        });

        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Status'),
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        itemCount: months.length,
        itemBuilder: (context, index) {
          final month = months[index];

          return ListTile(
            title: Text(month.name),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Collection:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Checkbox(
                  value: month.collection,
                  onChanged: (value) {
                    setState(() {
                      month.collection = value ?? false;
                    });
                  },
                ),
                const Text(
                  'Payment:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Checkbox(
                  value: month.payment,
                  onChanged: null, // Disable checkbox for payment
                ),
              ],
            ),
          );
        },
      ),
      persistentFooterButtons: [
        ElevatedButton(
          onPressed: () {
            saveDataToDatabase();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  void saveDataToDatabase() {
    DatabaseReference paymentsRef =
        FirebaseDatabase.instance.reference().child('payments');

    Map<String, dynamic> collectionData = {};
    for (var month in months) {
      collectionData[month.name] = month.collection;
    }

    paymentsRef.child('collection').child(currentUserID).update(collectionData);

    // Show a success message or perform any other actions after saving the data.
  }
}

class MonthStatus {
  String name;
  bool payment;
  bool collection;

  MonthStatus(this.name, {this.payment = false, this.collection = false});
}
