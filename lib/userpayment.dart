import 'package:flutter/material.dart';

class PaymentPage1 extends StatefulWidget {
  const PaymentPage1({Key? key}) : super(key: key);

  @override
  _PaymentPage1State createState() => _PaymentPage1State();
}

class _PaymentPage1State extends State<PaymentPage1> {
  bool isOnlinePayment = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Page'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Select Payment Mode:',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Radio<bool>(
                  value: true,
                  groupValue: isOnlinePayment,
                  onChanged: (bool? value) {
                    setState(() {
                      isOnlinePayment = true;
                    });
                  },
                ),
                const Text('Online'),
                Radio<bool>(
                  value: false,
                  groupValue: isOnlinePayment,
                  onChanged: (bool? value) {
                    setState(() {
                      isOnlinePayment = false;
                    });
                  },
                ),
                const Text('Offline'),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 34, 236, 115),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 100.0,
                  vertical: 16.0,
                ),
              ),
              child: const Text(
                'Proceed',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                if (isOnlinePayment) {
                  Navigator.pushNamed(context, '/useronlinepay');
                } else {
                  Navigator.pushNamed(context, '/userofflinepay');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
