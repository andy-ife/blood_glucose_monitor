import 'package:blood_glucose_monitor/utils/helpers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ReminderCard extends StatelessWidget {
  const ReminderCard({
    super.key,
    required this.onDelete,
    required this.onTap,
    required this.description,
    required this.time,
  });

  final String description;
  final DateTime time;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: ListTile(
          leading: SvgPicture.asset('assets/glucometer.svg'),
          trailing: IconButton(
            onPressed: onDelete,
            icon: Icon(Icons.delete_outline),
          ),
          title: Text(description),
          subtitle: Text(timestampToString(Timestamp.fromDate(time))),
        ),
      ),
    );
  }
}
