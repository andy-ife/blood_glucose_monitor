import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'History',
        style: Theme.of(
          context,
        ).textTheme.displayLarge!.copyWith(color: Colors.green),
      ),
    );
  }
}
