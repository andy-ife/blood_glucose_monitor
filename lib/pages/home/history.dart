import 'package:blood_glucose_monitor/constants/glucose_level.dart';
import 'package:blood_glucose_monitor/controllers/history_controller.dart';
import 'package:blood_glucose_monitor/theme/colors.dart';
import 'package:blood_glucose_monitor/utils/helpers.dart';
import 'package:blood_glucose_monitor/widgets/button_group.dart';
import 'package:blood_glucose_monitor/widgets/glucose_chart.dart';
import 'package:blood_glucose_monitor/widgets/stat_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        bottom: TabBar(
          padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
          controller: _tabController,
          tabs: const [
            Tab(text: 'History'),
            Tab(text: 'Trend'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildHistoryTab(context), _buildTrendTab(context)],
      ),
    );
  }

  Widget _buildHistoryTab(BuildContext context) {
    final controller = context.watch<HistoryController>();
    final state = controller.state;

    final high = getHighestGlucose(state.data);
    final avg = getAverageGlucose(state.data);
    final low = getLowestGlucose(state.data);

    return RefreshIndicator(
      onRefresh: () async => controller.init(),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Time Period Buttons
              BGMButtonGroup(
                values: controller.tabs,
                onSelectionChange: (selected) {
                  controller.switchTimeframe(selected.first);
                },
                floating: false,
                scrollable: true,
                enableMultiSelection: false,
                initialSelection: {controller.tabs.first},
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      title: 'Avg',
                      value: avg.toString(),
                      status: getGlucoseLevel(avg).name.capitalize(),
                      statusColor: getGlucoseLevel(avg) == GlucoseLevel.good
                          ? AppColors.green
                          : getGlucoseLevel(avg) == GlucoseLevel.ok
                          ? AppColors.amber
                          : AppColors.red,
                      icon: '💧',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: StatCard(
                      title: 'Low',
                      value: low.toString(),
                      status: getGlucoseLevel(low).name.capitalize(),
                      statusColor: getGlucoseLevel(low) == GlucoseLevel.good
                          ? AppColors.green
                          : getGlucoseLevel(low) == GlucoseLevel.ok
                          ? AppColors.amber
                          : AppColors.red,
                      icon: '⬇️',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: StatCard(
                      title: 'High',
                      value: high.toString(),
                      status: getGlucoseLevel(high).name.capitalize(),
                      statusColor: getGlucoseLevel(high) == GlucoseLevel.good
                          ? AppColors.green
                          : getGlucoseLevel(high) == GlucoseLevel.ok
                          ? AppColors.amber
                          : AppColors.red,
                      icon: '⬆️',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              GlucoseChart.compact(readings: state.data),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrendTab(BuildContext context) {
    return const Center(child: Text('Trend Tab Content'));
  }
}
