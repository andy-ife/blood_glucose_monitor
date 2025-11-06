class Reading {
  final double glucose;
  final DateTime time;
  final String? chartLabel;
  final int? xAxis;

  Reading({
    required this.glucose,
    required this.time,
    this.chartLabel,
    this.xAxis,
  });

  Reading copyWith({
    double? glucose,
    DateTime? time,
    String? chartLabel,
    int? xAxis,
  }) {
    return Reading(
      glucose: glucose ?? this.glucose,
      time: time ?? this.time,
      chartLabel: chartLabel ?? this.chartLabel,
      xAxis: xAxis ?? this.xAxis,
    );
  }

  Map<String, dynamic> toJson() => {
    'glucose': glucose,
    'timestamp': time.toIso8601String(),
  };

  factory Reading.fromJson(Map<String, dynamic> json) {
    return Reading(
      glucose: (json['glucose'] ?? 90 as num).toDouble(),
      time:
          DateTime.tryParse(json['timestamp'] as String)?.toLocal() ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Reading &&
          runtimeType == other.runtimeType &&
          glucose == other.glucose &&
          time == other.time;

  @override
  int get hashCode => glucose.hashCode ^ time.hashCode;
}
