import 'package:blood_glucose_monitor/constants/glucose_level.dart';
import 'package:blood_glucose_monitor/theme/colors.dart';
import 'package:blood_glucose_monitor/utils/helpers.dart';
import 'package:flutter/material.dart';

class StatusGreeting extends StatelessWidget {
  const StatusGreeting({super.key, required this.reading});

  final double reading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final status = _getGreetingAndColor(reading);

    return Row(
      children: [
        Text(status.$1, style: theme.textTheme.titleLarge),
        SizedBox(width: 6.0),
        Container(
          height: 8.0,
          width: 8.0,
          decoration: BoxDecoration(shape: BoxShape.circle, color: status.$2),
        ),
      ],
    );
  }

  (String, MaterialColor) _getGreetingAndColor(double reading) {
    final level = getGlucoseLevel(reading);
    switch (level) {
      case GlucoseLevel.low:
        return ('Your blood sugar is low!', AppColors.red);
      case GlucoseLevel.high:
        return ('Your blood sugar is high!', AppColors.red);
      case GlucoseLevel.good:
        return ('Your blood sugar is good', AppColors.green);
      case GlucoseLevel.ok:
        return ('Your blood sugar is ok', AppColors.amber);
    }
  }
}
