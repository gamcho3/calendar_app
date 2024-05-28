import 'package:calendar_project/collection/schedule_schema.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarDatabase {
  static final IsarDatabase _instance = IsarDatabase._internal();

  IsarDatabase._internal();

  factory IsarDatabase() {
    return _instance;
  }

  late Isar _isar;
  Isar get isar => _isar;

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [ScheduleSchema],
      directory: dir.path,
    );
  }
}
