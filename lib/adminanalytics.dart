import 'package:flutter/material.dart';
import 'package:waste_wise/admincollectionanalytics.dart';
import 'package:waste_wise/adminpaymentanalytics.dart';

class AdminAnalyticsPage extends StatelessWidget {
  final void Function(String) onSelectAnalyticsType;

  const AdminAnalyticsPage({super.key, required this.onSelectAnalyticsType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Analytics Page'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Choose Analytics Type:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                onSelectAnalyticsType('Payment');
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PaymentAnalyticsPage()));
              },
              child: const Text('Payment Analytics'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                onSelectAnalyticsType('Collection');
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CollectionAnalyticsPage()));
              },
              child: const Text('Collection Analytics'),
            ),
          ],
        ),
      ),
    );
  }
}
