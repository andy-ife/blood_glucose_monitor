import 'package:blood_glucose_monitor/constants/glucose_level.dart';
import 'package:blood_glucose_monitor/models/reading.dart';
import 'package:blood_glucose_monitor/theme/colors.dart';
import 'package:blood_glucose_monitor/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RecentTestCard extends StatelessWidget {
  const RecentTestCard({super.key, required this.reading});

  final Reading reading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constraints = MediaQuery.of(context).size;
    final level = getGlucoseLevel(reading.glucose);

    return Card(
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(16.0),
      ),
      child: SizedBox(
        height: constraints.height * 0.10,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Glucose', style: theme.textTheme.bodyMedium!),
                  Text(
                    formatDateTimeToReadable(reading.time),
                    style: theme.textTheme.bodyMedium!,
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
                              style: theme.textTheme.titleLarge,
                            ),
                            TextSpan(
                              text: ' mg/dL',
                              style: theme.textTheme.bodySmall!.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: theme.colorScheme.surface,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            children: [
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
                      ),
                    ],
                  ),

                  SvgPicture.asset(
                    level == GlucoseLevel.good
                        ? 'assets/blood/blue-light.svg'
                        : level == GlucoseLevel.ok
                        ? 'assets/blood/amber-light.svg'
                        : 'assets/blood/red-light.svg',
                    width: 28.0,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
