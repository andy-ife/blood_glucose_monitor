class Reminder {
  final String userId;
  final String description;
  final DateTime? time;

  const Reminder({
    this.userId = '',
    this.description = 'Take Blood Text',
    this.time,
  });

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      userId: json['userId'],
      description: json['description'],
      time: DateTime.parse(json['time']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'description': description,
      'time': time?.toIso8601String(),
    };
  }
}
