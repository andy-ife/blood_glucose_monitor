import 'package:blood_glucose_monitor/constants/glucose_level.dart';
import 'package:blood_glucose_monitor/models/reading.dart';
import 'package:blood_glucose_monitor/theme/colors.dart';
import 'package:blood_glucose_monitor/utils/helpers.dart';
import 'package:blood_glucose_monitor/widgets/gradient_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CurrentTestCard extends StatelessWidget {
  const CurrentTestCard({super.key, required this.reading});

  final Reading reading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constraints = MediaQuery.of(context).size;
    final level = getGlucoseLevel(reading.glucose);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(24.0),
      ),
      child: SizedBox(
        height: constraints.height * 0.16,
        child: GradientBackground(
          borderRadius: 24.0,
          gradient: LinearGradient(
            colors: level == GlucoseLevel.good
                ? [AppColors.primary, AppColors.primaryLight]
                : level == GlucoseLevel.ok
                ? [AppColors.amberDark, AppColors.amber]
                : [AppColors.redDark, AppColors.red],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Current Test',
                      style: theme.textTheme.titleMedium!.copyWith(
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                    Text(
                      formatDateTimeToReadable(reading.time),
                      style: theme.textTheme.bodyMedium!.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      spacing: 8.0,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: reading.glucose.ceil().toString(),
                                style: theme.textTheme.headlineLarge!.copyWith(
                                  color: theme.colorScheme.onPrimary,
                                ),
                              ),
                              TextSpan(
                                text: ' mg/dL',
                                style: theme.textTheme.bodyMedium!.copyWith(
                                  color: theme.colorScheme.onPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: theme.colorScheme.surface,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4.0,
                              horizontal: 8.0,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  height: 6.0,
                                  width: 6.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: level == GlucoseLevel.good
                                        ? AppColors.green
                                        : level == GlucoseLevel.ok
                                        ? AppColors.amber
                                        : AppColors.red,
                                  ),
                                ),
                                SizedBox(width: 4.0),
                                Text(
                                  level.name.capitalize(),
                                  style: theme.textTheme.bodySmall!.copyWith(
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
                        ),
                      ],
                    ),

                    SvgPicture.asset(
                      level == GlucoseLevel.good
                          ? 'assets/blood/blue-light.svg'
                          : level == GlucoseLevel.ok
                          ? 'assets/blood/amber-light.svg'
                          : 'assets/blood/red-light.svg',
                      width: 40.0,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
