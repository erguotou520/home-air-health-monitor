import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'dart:math';

/// day - value Object
class DailyData {
  final String day;
  final int value;
  DailyData(this.day, this.value);
}

class BarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  BarChart(this.seriesList, { this.animate });

  /// Creates a [BarChart] with sample data and no transition.
  factory BarChart.withSampleData() {
    return new BarChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text('历史数据')
      ),
      body: new Container(
        padding: EdgeInsets.all(24),
        child: new charts.BarChart(
          seriesList,
          animate: animate,
          barGroupingType: charts.BarGroupingType.grouped,
          behaviors: [new charts.SeriesLegend()],
        ),
      )
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<DailyData, String>> _createSampleData() {
    final random = new Random();
    final data = [
      new DailyData('12.01', random.nextInt(50)),
      new DailyData('12.02', random.nextInt(50)),
      new DailyData('12.03', random.nextInt(50)),
      new DailyData('12.04', random.nextInt(50)),
      new DailyData('12.05', random.nextInt(50)),
      new DailyData('12.06', random.nextInt(50)),
      new DailyData('12.07', random.nextInt(50)),
    ];

    return [
      new charts.Series<DailyData, String>(
        id: 'data',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (DailyData data, _) => data.day,
        measureFn: (DailyData data, _) => data.value,
        data: data,
      )
    ];
  }
}
