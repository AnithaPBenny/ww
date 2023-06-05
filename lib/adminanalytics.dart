import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class AdminAnalyticsPage extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  AdminAnalyticsPage({required this.seriesList, required this.animate});

  factory AdminAnalyticsPage.withSampleData() {
    return AdminAnalyticsPage(
      seriesList: _createSampleData(),
      animate: true,
    );
  }

  static List<charts.Series<ChartData, String>> _createSampleData() {
    final data = [
      ChartData('Category 1', 25),
      ChartData('Category 2', 50),
      ChartData('Category 3', 75),
      ChartData('Category 4', 100),
    ];

    return [
      charts.Series<ChartData, String>(
        id: 'Analytics',
        domainFn: (ChartData data, _) => data.category,
        measureFn: (ChartData data, _) => data.value,
        data: data,
        labelAccessorFn: (ChartData row, _) => '${row.category}: ${row.value}',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Analytics'),
      ),
      body: Center(
        child: charts.PieChart(
          seriesList,
          animate: animate,
          defaultRenderer: charts.ArcRendererConfig(
            arcRendererDecorators: [charts.ArcLabelDecorator()],
          ),
        ),
      ),
    );
  }
}

class ChartData {
  final String category;
  final int value;

  ChartData(this.category, this.value);
}
