import 'package:blood_glucose_monitor/navigation/routes.dart';
import 'package:blood_glucose_monitor/theme/colors.dart';
import 'package:blood_glucose_monitor/widgets/button_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TestsPage extends StatelessWidget {
  const TestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        foregroundColor: theme.colorScheme.onPrimary,
        onPressed: () => Navigator.of(context).pushNamed(Routes.chat),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble_outline),
            Text(
              'Chat',
              style: theme.textTheme.labelMedium!.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(title: const Text('Your Tests')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Button Group Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: BGMButtonGroup(
                values: const ['Today', 'Last 7 Days', 'Last Month', 'All'],
                onSelectionChange: (selectedValues) {
                  // Handle selection change
                  print('Selected: $selectedValues');
                },
                enableMultiSelection: false,
                initialSelection: {'Today'},
              ),
            ),

            // Test Results List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: 5, // Generate 5 example items
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Card(
                        color: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: SizedBox(
                          height:
                              constraints.maxWidth *
                              0.25, // Adjusted for responsive height
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 16.0,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Yesterday',
                                      style: theme.textTheme.bodyMedium!,
                                    ),
                                    Text(
                                      '11:00',
                                      style: theme.textTheme.bodyMedium!,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      spacing: 8.0,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: '152 ',
                                                style:
                                                    theme.textTheme.titleLarge,
                                              ),
                                              TextSpan(
                                                text: 'mg/dL',
                                                style: theme
                                                    .textTheme
                                                    .bodySmall!
                                                    .copyWith(
                                                      color: theme
                                                          .colorScheme
                                                          .onSurfaceVariant,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              16.0,
                                            ),
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
                                                    color: AppColors.green,
                                                  ),
                                                ),
                                                const SizedBox(width: 3.0),
                                                Text(
                                                  'Good',
                                                  style: theme
                                                      .textTheme
                                                      .labelSmall!
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: AppColors.green,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SvgPicture.asset(
                                      'assets/blood/blue-light.svg',
                                      width: 28.0,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
