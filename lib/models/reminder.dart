class Reminder {
  final int id;
  final String userId;
  final String description;
  final DateTime? time;

  const Reminder({
    this.id = 0,
    this.userId = '',
    this.description = 'Take Blood Text',
    this.time,
  });

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'],
      userId: json['userId'],
      description: json['description'],
      time: DateTime.parse(json['time']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'description': description,
      'time': time?.toIso8601String(),
    };
  }
}
