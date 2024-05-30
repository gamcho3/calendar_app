import 'package:calendar_project/collection/schedule_schema.dart';
import 'package:calendar_project/db/isar_database.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

abstract class ScheduleRepository {
  getScheduleList({required DateTime date});
  createSchedule(
      {required DateTime date,
      required DateTime startTime,
      required DateTime endTime,
      required String title,
      String? subTitle,
      required ScheduleType type});
  updateSchedule();
  deleteSchedule();
}

class IsarScheduleRepositoryImpl implements ScheduleRepository {
  @override
  createSchedule(
      {required DateTime date,
      required DateTime startTime,
      required DateTime endTime,
      required String title,
      String? subTitle,
      required ScheduleType type}) {
    final database = IsarDatabase();
    final isar = database.isar;
    final schedule = Schedule()
      ..date = DateFormat('yyyy-MM-dd').format(date)
      ..endTime = endTime
      ..startTime = startTime
      ..title = title
      ..subTitle = subTitle
      ..type = type;
    isar.writeTxn(() async {
      await isar.schedules.put(schedule);
    });
  }

  @override
  deleteSchedule() {
    // TODO: implement deleteSchedule
    throw UnimplementedError();
  }

  @override
  List<Schedule> getScheduleList({required DateTime date}) {
    final formatedDate = DateFormat('yyyy-MM-dd').format(date);
    final database = IsarDatabase();
    final isar = database.isar;
    final scheduleList = isar.schedules;
    final data = scheduleList.filter().dateEqualTo(formatedDate).findAllSync();
    return data;
  }

  @override
  updateSchedule() {
    // TODO: implement updateSchedule
    throw UnimplementedError();
  }
}
