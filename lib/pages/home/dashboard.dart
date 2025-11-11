import 'package:blood_glucose_monitor/controllers/dashboard_controller.dart';
import 'package:blood_glucose_monitor/pages/home/tests.dart';
import 'package:blood_glucose_monitor/services/auth_service.dart';
import 'package:blood_glucose_monitor/theme/colors.dart';
import 'package:blood_glucose_monitor/widgets/current_test_card.dart';
import 'package:blood_glucose_monitor/widgets/glucose_chart.dart';
import 'package:blood_glucose_monitor/widgets/profile_settings_dialog.dart';
import 'package:blood_glucose_monitor/widgets/recent_test_card.dart';
import 'package:blood_glucose_monitor/widgets/shimmer_loading.dart';
import 'package:blood_glucose_monitor/widgets/status_greeting.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constraints = MediaQuery.of(context).size;
    final currentUser = context.watch<AuthService>().user;
    final controller = context.watch<DashboardController>();
    final state = controller.state;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 112.0,
        leadingWidth: constraints.width * 0.20,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: GestureDetector(
            onTap: () => showDialog(
              context: context,
              builder: (context) => Dialog(child: ProfileSettingsDialog()),
            ),
            child: CircleAvatar(
              backgroundColor: theme.colorScheme.surfaceVariant,
              child: Icon(
                Icons.account_circle,
                size: 40.0,
                color: theme.colorScheme.onSurfaceVariant,
              ),
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
                    text: currentUser.username,
                    style: theme.textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            state.loading
                ? Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: ShimmerLoading(height: 20.0, width: 152),
                  )
                : state.currentTest == null
                ? Text(
                    "We couldn't get your current test",
                    style: theme.textTheme.bodyMedium!.copyWith(
                      color: AppColors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : StatusGreeting(reading: state.currentTest!.glucose),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => controller.init(),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsetsGeometry.symmetric(horizontal: 16.0),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 80.0),
            child: Column(
              spacing: 20.0,
              children: [
                state.loading
                    ? ShimmerLoading(
                        height: constraints.height * 0.16,
                        width: double.infinity,
                        borderRadius: BorderRadius.circular(24.0),
                      )
                    : state.currentTest == null
                    ? SizedBox.shrink()
                    : CurrentTestCard(reading: state.currentTest!),
                state.loading
                    ? ShimmerLoading(
                        height: constraints.height * 0.36,
                        width: double.infinity,
                      )
                    : GlucoseChart(readings: state.todayTests),
                Column(
                  spacing: 16.0,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Your Tests', style: theme.textTheme.titleLarge),
                        InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => TestsPage()),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
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
                      state.recentTests.length,
                      (i) => RecentTestCard(reading: state.recentTests[i]),
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
