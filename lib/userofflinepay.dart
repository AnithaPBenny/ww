import 'package:flutter/material.dart';

class UserOfflinePayPage extends StatefulWidget {
  @override
  _UserOfflinePayPageState createState() => _UserOfflinePayPageState();
}

class _UserOfflinePayPageState extends State<UserOfflinePayPage> {
  TextEditingController _emailController = TextEditingController();

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
    // Perform necessary actions with the worker's email
    // e.g., validate email, pass it to the next page, etc.
    // For now, let's assume workerEmail cannot be empty

    if (workerEmail.isEmpty) {
      _showAlertDialog(context, 'Please enter a valid worker email.');
    } else if (workerEmail != 'worker@example.com') {
      _showAlertDialog(context, 'No worker found with the provided email.');
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmationPage(workerEmail: workerEmail),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cash on Collection'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
  final String workerEmail;

  const ConfirmationPage({required this.workerEmail});

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
            Text('Worker\'s Email: $workerEmail'),
            const SizedBox(height: 20.0),
            ElevatedButton(
              child: const Text('Confirm'),
              onPressed: () {
                // Perform the final confirmation and other necessary actions
              },
            ),
          ],
        ),
      ),
    );
  }
}
