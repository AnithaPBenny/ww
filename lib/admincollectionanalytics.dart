import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class CollectionAnalyticsPage extends StatefulWidget {
  @override
  _CollectionAnalyticsPageState createState() =>
      _CollectionAnalyticsPageState();
}

class _CollectionAnalyticsPageState extends State<CollectionAnalyticsPage> {
  late DatabaseReference _collectionRef;
  List<int> _monthlyCollections = List.filled(12, 0);

  @override
  void initState() {
    super.initState();
    _collectionRef = FirebaseDatabase.instance
        .reference()
        .child('payments')
        .child('collection');
    _listenToCollections();
  }

  void _listenToCollections() {
    _collectionRef.onValue.listen((event) {
      DataSnapshot dataSnapshot = event.snapshot;
      Map<dynamic, dynamic>? collectionData =
          dataSnapshot.value as Map<dynamic, dynamic>?;

      if (collectionData != null) {
        collectionData.forEach((userId, monthlyData) {
          Map<dynamic, dynamic>? monthlyCollectionData =
              monthlyData as Map<dynamic, dynamic>?;

          if (monthlyCollectionData != null) {
            monthlyCollectionData.forEach((month, collectionStatus) {
              bool? status = collectionStatus as bool?;

              if (status != null && status) {
                int monthIndex = _getMonthIndex(month);

                if (monthIndex >= 0 &&
                    monthIndex < _monthlyCollections.length) {
                  setState(() {
                    _monthlyCollections[monthIndex]++;
                  });
                }
              }
            });
          }
        });

        _updateCollectionAnalytics();
      }
    });
  }

  void _updateCollectionAnalytics() {
    DatabaseReference analyticsRef =
        FirebaseDatabase.instance.reference().child('collectionanalytics');
    List<Map<String, dynamic>> analyticsData = [];

    for (int i = 0; i < _monthlyCollections.length; i++) {
      String monthName = _getMonthName(i);
      int count = _monthlyCollections[i];
      analyticsData.add({
        'month': monthName,
        'count': count,
      });
    }

    analyticsRef.set(analyticsData);
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
    List<charts.Series<CollectionData, String>> seriesList = [
      charts.Series(
        id: 'collections',
        data: _monthlyCollections.asMap().entries.map((entry) {
          int index = entry.key;
          int count = entry.value;
          String month = _getMonthName(index);
          return CollectionData(month, count);
        }).toList(),
        domainFn: (CollectionData collection, _) => collection.month,
        measureFn: (CollectionData collection, _) => collection.count,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Collection Analytics'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'Monthly Collections',
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
                  vertical: false,
                  barRendererDecorator: charts.BarLabelDecorator<String>(),
                  domainAxis: charts.OrdinalAxisSpec(
                    renderSpec: charts.NoneRenderSpec(),
                  ),
                  primaryMeasureAxis: charts.NumericAxisSpec(
                    tickProviderSpec: charts.BasicNumericTickProviderSpec(
                      zeroBound: false,
                    ),
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

class CollectionData {
  final String month;
  final int count;

  CollectionData(this.month, this.count);
}
