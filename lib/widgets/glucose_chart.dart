import 'package:blood_glucose_monitor/models/reading.dart';
import 'package:blood_glucose_monitor/theme/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GlucoseChart extends StatelessWidget {
  const GlucoseChart({super.key, required this.readings});

  final List<Reading> readings;

  @override
  Widget build(BuildContext context) {
    final constraints = MediaQuery.of(context).size;
    return Card(
      color: AppColors.white,
      child: SizedBox(
        height: constraints.height * 0.36,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: LineChart(
            LineChartData(
              lineBarsData: [
                LineChartBarData(
                  spots: readings
                      .map((r) => FlSpot(r.xAxis!.toDouble(), r.glucose))
                      .toList(),
                  color: AppColors.primary,
                  barWidth: 3.0,
                  isCurved: true,
                  preventCurveOverShooting: true,
                  isStrokeCapRound: true,
                  isStrokeJoinRound: true,
                ),
              ],
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
