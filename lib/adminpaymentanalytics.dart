import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class PaymentData {
  final String month;
  final int count;

  PaymentData(this.month, this.count);
}

class PaymentAnalyticsPage extends StatefulWidget {
  @override
  _PaymentAnalyticsPageState createState() => _PaymentAnalyticsPageState();
}

class _PaymentAnalyticsPageState extends State<PaymentAnalyticsPage> {
  late DatabaseReference _analyticsRef;
  List<int> _monthlyPayments = List.filled(12, 0);

  @override
  void initState() {
    super.initState();
    _analyticsRef = FirebaseDatabase.instance.reference().child('analytics');
    _listenToPayments();
  }

  void _listenToPayments() {
    DatabaseReference paymentRef =
        FirebaseDatabase.instance.reference().child('payments');
    paymentRef.onChildAdded.listen((event) {
      // Get the month from the payment node
      String? paymentMonth = event.snapshot.child('month').value as String?;

      if (paymentMonth != null) {
        int monthIndex = _getMonthIndex(paymentMonth);

        setState(() {
          // Increment the corresponding month in the analytics
          _monthlyPayments[monthIndex]++;
        });

        // Update the analytics node in the database
        _analyticsRef.child(paymentMonth).set(_monthlyPayments[monthIndex]);
      }
    });
  }

  int _getMonthIndex(String month) {
    switch (month) {
      case 'January':
        return 0;
      case 'February':
        return 1;
      case 'March':
        return 2;
      case 'April':
        return 3;
      case 'May':
        return 4;
      case 'June':
        return 5;
      case 'July':
        return 6;
      case 'August':
        return 7;
      case 'September':
        return 8;
      case 'October':
        return 9;
      case 'November':
        return 10;
      case 'December':
        return 11;
      default:
        return -1;
    }
  }

  String _getMonthName(int index) {
    switch (index) {
      case 0:
        return 'January';
      case 1:
        return 'February';
      case 2:
        return 'March';
      case 3:
        return 'April';
      case 4:
        return 'May';
      case 5:
        return 'June';
      case 6:
        return 'July';
      case 7:
        return 'August';
      case 8:
        return 'September';
      case 9:
        return 'October';
      case 10:
        return 'November';
      case 11:
        return 'December';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    List<charts.Series<PaymentData, String>> seriesList = [
      charts.Series(
        id: 'payments',
        data: _monthlyPayments.asMap().entries.map((entry) {
          int index = entry.key;
          int count = entry.value;
          String month = _getMonthName(index);
          return PaymentData(month, count);
        }).toList(),
        domainFn: (PaymentData payment, _) =>
            payment.month, // Set the months as the x-axis (domain)
        measureFn: (PaymentData payment, _) =>
            payment.count, // Set the count as the y-axis (measure)
        colorFn: (_, __) =>
            charts.MaterialPalette.blue.shadeDefault, // Set the bar color
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Analytics'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'Monthly Payments',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: charts.BarChart(
                  seriesList,
                  animate: true,
                  vertical:
                      false, // Set vertical to false for x-axis as the horizontal axis
                  barRendererDecorator:
                      charts.BarLabelDecorator<String>(), // Add bar labels
                  domainAxis: charts.OrdinalAxisSpec(
                    showAxisLine: true, // Show the axis line
                    renderSpec:
                        charts.NoneRenderSpec(), // Hide the domain axis labels
                  ),
                  primaryMeasureAxis: charts.NumericAxisSpec(
                    tickProviderSpec: charts.BasicNumericTickProviderSpec(
                        zeroBound: false), // Allow non-zero-based y-axis
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
