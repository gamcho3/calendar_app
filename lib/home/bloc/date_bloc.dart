import 'dart:async';

import 'package:calendar_project/collection/schedule_schema.dart';
import 'package:calendar_project/home/repository/schedule_repository.dart';

class DateBloc {
  static final DateBloc _instance = DateBloc._internal();

  DateBloc._internal();

  factory DateBloc() {
    return _instance;
  }

  final repository = IsarScheduleRepositoryImpl();
  final _dateController = StreamController<DateTime>.broadcast();
  final _scheduleListController = StreamController<List<Schedule>>();

  Stream<DateTime> get dateStream => _dateController.stream;
  Stream<List<Schedule>> get scheduleListStream =>
      _scheduleListController.stream;

  void getScheduleList(DateTime date) {
    final data = repository.getScheduleList(date: date);
    _scheduleListController.sink.add(data);
  }

  void createSchedule(
      {required DateTime date,
      required DateTime startTime,
      required DateTime endTime,
      required String title,
      String? subTitle,
      required ScheduleType type}) {
    repository.createSchedule(
        date: date,
        startTime: startTime,
        endTime: endTime,
        title: title,
        subTitle: subTitle,
        type: type);
    getScheduleList(date);
  }

  void selectDate(date) {
    _dateController.sink.add(date);
  }

  void dispose() {
    _dateController.close();
  }
}
