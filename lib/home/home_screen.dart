import 'package:calendar_project/collection/schedule_schema.dart';
import 'package:calendar_project/const/const.dart';
import 'package:calendar_project/db/isar_database.dart';
import 'package:calendar_project/home/bloc/date_bloc.dart';
import 'package:calendar_project/home/components/custom_scroll_list.dart';
import 'package:calendar_project/home/components/schedule_button.dart';
import 'package:calendar_project/home/components/schedule_container.dart';
import 'package:calendar_project/home/components/schedule_form.dart';
import 'package:calendar_project/home/model/time_model.dart';
import 'package:dev/dev.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _bloc = DateBloc();

  // 더미데이터 생성
  void insertDummySchedule() async {
    final database = IsarDatabase();
    final isar = database.isar;
    final dummylist = List.generate(5, (index) {
      return Schedule()
        ..date = DateFormat('yyyy-MM-dd').format(DateTime.now())
        ..endTime = DateTime(2024, 1, 1, 10, 0)
        ..startTime = DateTime(2024, 1, 1, 9, 0)
        ..title = '서류 제출'
        ..subTitle = '9시까지 서류 제출'
        ..type = ScheduleType.work;
    });

    isar.writeTxn(() async {
      await isar.schedules.clear();
      await isar.schedules.putAll(dummylist);
    });
  }

  @override
  void initState() {
    _bloc.getScheduleList(DateTime.now());
    insertDummySchedule();
    super.initState();
  }

  // 선택된 날짜
  DateTime _isSelectedDay = DateTime.now();
  // 현재 보여지는 달을 결정
  DateTime _focusday = DateTime.now();
  @override
  Widget build(BuildContext context) {
    final ValueNotifier<ScheduleType> selectedType =
        ValueNotifier(ScheduleType.work);
    return Scaffold(
      body: Column(
        children: [
          StreamBuilder(
              stream: _bloc.dateStream,
              builder: (context, AsyncSnapshot<DateTime> snapshot) {
                final selectedDate = snapshot.data;
                print("stream builder $selectedDate");
                return Container(
                  color: Colors.white,
                  child: TableCalendar(
                    headerStyle: const HeaderStyle(
                        titleCentered: true, formatButtonVisible: false),
                    calendarStyle: CalendarStyle(
                      weekendTextStyle:
                          TextStyle(color: Colors.blue.withOpacity(0.6)),
                      defaultDecoration:
                          const BoxDecoration(shape: BoxShape.rectangle),
                      weekendDecoration:
                          BoxDecoration(shape: BoxShape.rectangle),
                      todayDecoration: BoxDecoration(
                          color: Colors.teal.withOpacity(0.3),
                          shape: BoxShape.rectangle),
                      selectedDecoration: BoxDecoration(
                          color: Colors.teal, shape: BoxShape.rectangle),
                      outsideDecoration:
                          BoxDecoration(shape: BoxShape.rectangle),
                    ),
                    locale: 'ko_KR',
                    focusedDay: _focusday,
                    firstDay: DateTime.utc(2024, 01, 01),
                    lastDay: DateTime.utc(2024, 12, 31),
                    selectedDayPredicate: (day) {
                      return isSameDay(_isSelectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      _bloc.selectDate(selectedDay);
                      _bloc.getScheduleList(selectedDay);
                      // 선택날짜와 보여지는 달 저장
                      setState(() {
                        _isSelectedDay = selectedDay;
                        _focusday = focusedDay;
                      });
                    },
                  ),
                );
              }),
          Expanded(
            child: StreamBuilder<List<Schedule>>(
                stream: _bloc.scheduleListStream,
                builder: (context, AsyncSnapshot<List<Schedule>> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final list = snapshot.data!;

                  return ListView.separated(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      itemCount: list.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        return ScheduleContainer(
                          index: index,
                          schedule: list[index],
                        );
                      });
                }),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return ScheduleForm(selectedType: selectedType);
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
