import 'package:calendar_project/collection/schedule_schema.dart';
import 'package:calendar_project/db/isar_database.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

abstract class ScheduleRepository {
  getScheduleList({required DateTime date});
  createSchedule();
  updateSchedule();
  deleteSchedule();
}

class IsarScheduleRepositoryImpl implements ScheduleRepository {
  @override
  createSchedule() {}

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
