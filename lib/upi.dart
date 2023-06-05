import 'package:flutter/material.dart';
//import 'package:google_pay_flutter/google_pay_flutter.dart';

class UpiPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<UpiPage> {
  String? selectedPaymentMethod;

  @override
  void initState() {
    super.initState();
    selectedPaymentMethod = 'Google Pay';
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
              'Select Payment Method',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            ListTile(
              title: const Text('Google Pay'),
              leading: Radio<String?>(
                value: 'Google Pay',
                groupValue: selectedPaymentMethod,
                onChanged: (String? value) {
                  setState(() {
                    selectedPaymentMethod = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('PhonePe'),
              leading: Radio<String?>(
                value: 'PhonePe',
                groupValue: selectedPaymentMethod,
                onChanged: (String? value) {
                  setState(() {
                    selectedPaymentMethod = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Paytm'),
              leading: Radio<String?>(
                value: 'Paytm',
                groupValue: selectedPaymentMethod,
                onChanged: (String? value) {
                  setState(() {
                    selectedPaymentMethod = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              child: const Text('Pay'),
              onPressed: () async {
                /*final isAvailable = await GooglePayFlutter.isAvailable();

    if (isAvailable) {
      final paymentItem = GooglePayPaymentItem(
        totalPrice: '50.00',
        currencyCode: 'Rs'
      );

      try {
        final token = await GooglePayFlutter.makePayment(paymentItem);

        // Handle the payment token received from Google Pay
        // You can send the token to your backend server for processing

        // Navigate to a success page or perform any other action
      } catch (error) {
        // Handle any errors that occurred during the payment process
      }
    } else {
      // Google Pay is not available on this device
    }*/
              },
            )
          ],
        ),
      ),
    );
  }
}
