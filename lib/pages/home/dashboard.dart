import 'package:blood_glucose_monitor/theme/colors.dart';
import 'package:blood_glucose_monitor/widgets/gradient_background.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constraints = MediaQuery.of(context).size;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        foregroundColor: theme.colorScheme.onPrimary,
        onPressed: () {},
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
      appBar: AppBar(
        toolbarHeight: 112.0,
        leadingWidth: constraints.width * 0.20,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: CircleAvatar(
            backgroundColor: theme.colorScheme.surfaceVariant,
            child: Icon(
              Icons.account_circle,
              size: 40.0,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: 'Hello, ', style: theme.textTheme.bodyLarge),
                  TextSpan(
                    text: '_glucoseboy',
                    style: theme.textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Text('You are healthy', style: theme.textTheme.titleLarge),
                SizedBox(width: 4.0),
                Container(
                  height: 8.0,
                  width: 8.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 16.0),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 80.0),
          child: Column(
            spacing: 20.0,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(24.0),
                ),
                child: SizedBox(
                  height: constraints.height * 0.16,
                  child: GradientBackground(
                    borderRadius: 24.0,
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryLight],
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
                                style: theme.textTheme.titleSmall!.copyWith(
                                  color: theme.colorScheme.onPrimary,
                                ),
                              ),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Today ',
                                      style: theme.textTheme.labelMedium!
                                          .copyWith(
                                            color: theme.colorScheme.onPrimary,
                                            fontWeight: FontWeight.w400,
                                          ),
                                    ),
                                    TextSpan(
                                      text: '11:00',
                                      style: theme.textTheme.titleSmall!
                                          .copyWith(
                                            color: theme.colorScheme.onPrimary,
                                          ),
                                    ),
                                  ],
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
                                          text: '152 ',
                                          style: theme.textTheme.headlineLarge!
                                              .copyWith(
                                                color:
                                                    theme.colorScheme.onPrimary,
                                              ),
                                        ),
                                        TextSpan(
                                          text: 'mg/dL',
                                          style: theme.textTheme.bodyMedium!
                                              .copyWith(
                                                color:
                                                    theme.colorScheme.onPrimary,
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
                                      padding: const EdgeInsets.all(4.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 6.0,
                                            width: 6.0,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: AppColors.green,
                                            ),
                                          ),
                                          SizedBox(width: 4.0),
                                          Text(
                                            'Good',
                                            style: theme.textTheme.bodySmall!
                                                .copyWith(
                                                  fontWeight: FontWeight.w600,
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
                                width: 40.0,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              Card(
                color: AppColors.white,
                child: SizedBox(
                  height: constraints.height * 0.36,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: BarChart(BarChartData()),
                  ),
                ),
              ),

              Column(
                spacing: 16.0,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Your Tests', style: theme.textTheme.titleLarge),
                      InkWell(
                        onTap: () => print('Tapped'),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            'See all',
                            style: theme.textTheme.titleMedium!.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  ...List.generate(
                    4,
                    (i) => Card(
                      color: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(16.0),
                      ),
                      child: SizedBox(
                        height: constraints.height * 0.10,
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
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: '152 ',
                                              style: theme.textTheme.titleLarge,
                                            ),
                                            TextSpan(
                                              text: 'mg/dL',
                                              style: theme.textTheme.bodySmall!
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
                                              SizedBox(width: 3.0),
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
                    ),
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
