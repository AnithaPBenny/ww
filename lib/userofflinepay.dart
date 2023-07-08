import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class PaymentDetails {
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  final String month;
  final String paymentMode;
  final String workerEmail;
  PaymentDetails({
    required this.month,
    required this.paymentMode,
    required this.workerEmail,
  });
}

class UserOfflinePayPage extends StatefulWidget {
  const UserOfflinePayPage({Key? key, required String userId})
      : super(key: key);

  @override
  _UserOfflinePayPageState createState() => _UserOfflinePayPageState();
}

class _UserOfflinePayPageState extends State<UserOfflinePayPage> {
  final TextEditingController _emailController = TextEditingController();
  String _selectedMonth = 'January';
  String _selectedPaymentMode = 'Offline';

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _showAlertDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _proceedToConfirmation(BuildContext context, String workerEmail) {
    if (_selectedMonth.isEmpty) {
      _showAlertDialog(context, 'Please select a month.');
    } else if (workerEmail.isEmpty) {
      _showAlertDialog(context, 'Please enter a valid worker email.');
    } else {
      DatabaseReference workersRef =
          FirebaseDatabase.instance.reference().child('workers');

      workersRef.orderByChild('email').equalTo(workerEmail).onValue.listen(
        (event) {
          Map<dynamic, dynamic>? workers =
              event.snapshot.value as Map<dynamic, dynamic>?;

          if (workers == null) {
            _showAlertDialog(
                context, 'No worker found with the provided email.');
          } else {
            String workerKey = workers.keys.first;
            String workerEmail = workers[workerKey]['email'];
            PaymentDetails paymentDetails = PaymentDetails(
              month: _selectedMonth,
              paymentMode: _selectedPaymentMode,
              workerEmail: workerEmail,
            );

            _savePaymentDetails(paymentDetails);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ConfirmationPage(paymentDetails: paymentDetails),
              ),
            );
          }
        },
        onError: (error) {
          _showAlertDialog(context, 'Error retrieving worker details: $error');
        },
      );
    }
  }

  void _savePaymentDetails(PaymentDetails paymentDetails) {
    DatabaseReference paymentRef =
        FirebaseDatabase.instance.reference().child('payments');

    String? paymentId = paymentRef.push().key;

    if (paymentId != null) {
      paymentRef.child(paymentId).set({
        'user_id': paymentDetails.userId,
        'month': paymentDetails.month,
        'payment_mode': 'Offline',
        'worker_email': paymentDetails.workerEmail,
      }).then((_) {
        print('Payment details saved successfully.');
      }).catchError((error) {
        print('Failed to save payment details: $error');
      });
    } else {
      print('Failed to generate payment ID.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cash on Collection'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Month',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            DropdownButton<String>(
              value: _selectedMonth,
              hint: const Text('Select a month'),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedMonth = newValue!;
                });
              },
              items: <String>[
                'January',
                'February',
                'March',
                'April',
                'May',
                'June',
                'July',
                'August',
                'September',
                'October',
                'November',
                'December'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Enter Worker\'s Email',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: 'Worker\'s Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              child: const Text('Submit'),
              onPressed: () {
                String workerEmail = _emailController.text;
                _proceedToConfirmation(context, workerEmail);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ConfirmationPage extends StatelessWidget {
  final PaymentDetails paymentDetails;

  const ConfirmationPage({Key? key, required this.paymentDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Confirmation Page',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            Text('Month: ${paymentDetails.month}'),
            Text('Payment Mode: ${paymentDetails.paymentMode}'),
            Text('Worker\'s Email: ${paymentDetails.workerEmail}'),
            /*const SizedBox(height: 20.0),
            ElevatedButton(
              child: const Text('Confirm'),
              onPressed: () {
                // Perform the final confirmation and other necessary actions
              },
            ),*/
          ],
        ),
      ),
    );
  }
}
