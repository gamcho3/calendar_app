import 'dart:async';

import 'package:calendar_project/collection/schedule_schema.dart';
import 'package:calendar_project/home/repository/schedule_repository.dart';

class DateBloc {
  final repository = IsarScheduleRepositoryImpl();
  final _dateController = StreamController<DateTime>();
  final _scheduleListController = StreamController<List<Schedule>>();
  Stream<DateTime> get dateStream => _dateController.stream;
  Stream<List<Schedule>> get scheduleListStream =>
      _scheduleListController.stream;

  void getScheduleList(DateTime date) async {
    final data = await repository.getScheduleList(date: date);
    _scheduleListController.sink.add(data);
  }

  void selectDate(date) {
    _dateController.sink.add(date);
  }

  void dispose() {
    _dateController.close();
  }
}
