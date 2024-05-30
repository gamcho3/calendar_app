import 'dart:ui';
import 'package:isar/isar.dart';

part 'schedule_schema.g.dart';

enum ScheduleType {
  work,
  personal,
  other;

  Color get color {
    switch (this) {
      case ScheduleType.work:
        return Color(0xFFE57373);
      case ScheduleType.personal:
        return Color(0xFF81C784);
      case ScheduleType.other:
        return Color(0xFF64B5F6);
    }
  }
}

@collection
class Schedule {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  late String date;
  late String title;

  String? subTitle;
  late DateTime startTime;
  late DateTime endTime;
  @enumerated
  late ScheduleType type;
}
