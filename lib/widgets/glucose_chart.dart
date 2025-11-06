import 'package:blood_glucose_monitor/constants/glucose_level.dart';
import 'package:blood_glucose_monitor/models/reading.dart';
import 'package:blood_glucose_monitor/theme/colors.dart';
import 'package:blood_glucose_monitor/utils/helpers.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class GlucoseChart extends StatelessWidget {
  const GlucoseChart({super.key, required this.readings, this.compact = false});

  final List<Reading> readings;
  final bool compact;

  factory GlucoseChart.compact({required List<Reading> readings}) =>
      GlucoseChart(readings: readings, compact: true);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constraints = MediaQuery.of(context).size;

    if (readings.isEmpty) {
      return Center(
        child: Column(
          spacing: 16.0,
          children: [
            Icon(
              Icons.medical_information,
              size: constraints.height * 0.36,
              color: AppColors.lightGrey,
            ),
            Text("No readings for today"),
          ],
        ),
      );
    }

    final averageGlucose = getAverageGlucose(readings);
    final level = getGlucoseLevel(averageGlucose);

    return Card(
      color: AppColors.white,
      child: Column(
        children: [
          if (!compact)
            Padding(
              padding: const EdgeInsets.only(
                left: 12.0,
                right: 12.0,
                top: 12.0,
                bottom: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_getTitle(), style: theme.textTheme.titleLarge),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.open_in_new, color: AppColors.darkGrey),
                  ),
                ],
              ),
            ),
          if (!compact) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            level == GlucoseLevel.good
                                ? 'assets/blood/blue-light.svg'
                                : level == GlucoseLevel.ok
                                ? 'assets/blood/amber-light.svg'
                                : 'assets/blood/red-light.svg',
                            width: 20.0,
                          ),
                          SizedBox(width: 4.0),
                          Text('Avg', style: theme.textTheme.bodySmall),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: averageGlucose.toString(),
                                    style: theme.textTheme.titleMedium,
                                  ),
                                  TextSpan(
                                    text: ' mg/dL',
                                    style: theme.textTheme.bodySmall!,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 4.0),
                            Container(
                              height: 5.0,
                              width: 5.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: level == GlucoseLevel.good
                                    ? AppColors.green
                                    : level == GlucoseLevel.ok
                                    ? AppColors.amber
                                    : AppColors.red,
                              ),
                            ),
                            SizedBox(width: 3.0),
                            Text(
                              level.name.capitalize(),
                              style: theme.textTheme.labelSmall!.copyWith(
                                fontWeight: FontWeight.w600,
                                color: level == GlucoseLevel.good
                                    ? AppColors.green
                                    : level == GlucoseLevel.ok
                                    ? AppColors.amber
                                    : AppColors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.arrow_upward, size: 16.0),
                          SizedBox(width: 8.0),
                          Text(
                            "High: ${getHighestGlucose(readings)}",
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 2.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.arrow_downward, size: 16.0),
                            SizedBox(width: 8.0),
                            Text(
                              "Low: ${getLowestGlucose(readings)}",
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
          ],
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              height: constraints.height * 0.40,
              width: constraints.width * _getChartWidth(),
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
                      dotData: FlDotData(show: false),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) => SideTitleWidget(
                          meta: meta,
                          child: Text(
                            "${value.toInt()}",
                            style: theme.textTheme.labelSmall,
                          ),
                        ),
                        //interval: 100,
                        minIncluded: false,
                        maxIncluded: false,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        interval: _getInterval(),
                        getTitlesWidget: (value, meta) => SideTitleWidget(
                          meta: meta,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              _getBottomTitle(value).toString(),
                              style: theme.textTheme.labelSmall,
                            ),
                          ),
                        ),
                        maxIncluded: readings.first.chartLabel != "hourly",
                        minIncluded: false,
                      ),
                    ),
                  ),
                  minX: 0,
                  maxX: _getMaxX(),
                  minY: 0,
                  maxY: 300,
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(
                    show: true,
                    drawHorizontalLine: false,
                    getDrawingVerticalLine: (e) =>
                        FlLine(color: AppColors.lightGrey.withOpacity(0.4)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _getMaxX() {
    return readings.first.chartLabel == "hourly"
        ? 24
        : readings.first.chartLabel == "daily"
        ? 7
        : 30;
  }

  String _getTitle() {
    return readings.first.chartLabel == "hourly"
        ? "Today"
        : readings.first.chartLabel == "daily"
        ? "Last 7 Days"
        : "Last Month";
  }

  double _getInterval() {
    return readings.first.chartLabel == "hourly"
        ? 2
        : readings.first.chartLabel == "daily"
        ? 1
        : 4;
  }

  double _getChartWidth() {
    return readings.first.chartLabel == "hourly"
        ? 2
        : readings.first.chartLabel == "daily"
        ? 1.2
        : 1.6;
  }

  dynamic _getBottomTitle(double value) {
    dynamic result;
    switch (readings.first.chartLabel) {
      case "hourly":
        result = "${value.toInt()}:00";
        break;
      case "daily":
        result = days[(value > 0 ? value - 1 : 0).toInt()];
        break;
      default:
        result = value.toInt();
        break;
    }
    return result;
  }
}
