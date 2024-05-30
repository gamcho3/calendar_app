class TimeModel {
  final String ampm;
  final String time;
  final String minute;

  TimeModel({
    required this.ampm,
    required this.time,
    required this.minute,
  });

  TimeModel copyWith({
    String? ampm,
    String? time,
    String? minute,
  }) {
    return TimeModel(
      ampm: ampm ?? this.ampm,
      time: time ?? this.time,
      minute: minute ?? this.minute,
    );
  }
}
