import 'package:flutter/material.dart';

class CardPage extends StatefulWidget {
  @override
  _CardPageState createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expiryController = TextEditingController();
  TextEditingController cardholderNameController = TextEditingController();
  TextEditingController ccvController = TextEditingController();

  @override
  void dispose() {
    cardNumberController.dispose();
    expiryController.dispose();
    cardholderNameController.dispose();
    ccvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              'Enter Card Details',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              controller: cardNumberController,
              decoration: const InputDecoration(
                labelText: 'Card Number',
              ),
            ),
            const SizedBox(height: 10.0),
            TextFormField(
              controller: expiryController,
              decoration: const InputDecoration(
                labelText: 'Expiry',
              ),
            ),
            const SizedBox(height: 10.0),
            TextFormField(
              controller: cardholderNameController,
              decoration: const InputDecoration(
                labelText: 'Cardholder Name',
              ),
            ),
            const SizedBox(height: 10.0),
            TextFormField(
              controller: ccvController,
              decoration: const InputDecoration(
                labelText: 'CCV',
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              child: const Text('Pay'),
              onPressed: () {
                // Get the entered card details
                String cardNumber = cardNumberController.text;
                String expiry = expiryController.text;
                String cardholderName = cardholderNameController.text;
                String ccv = ccvController.text;

                // Implement payment logic here
                // You can navigate to a success page or perform any other action

                // Clear the entered card details
                cardNumberController.clear();
                expiryController.clear();
                cardholderNameController.clear();
                ccvController.clear();
              },
            ),
          ],
        ),
      ),
    );
  }
}
