import 'package:calendar_project/collection/schedule_schema.dart';
import 'package:calendar_project/db/isar_database.dart';
import 'package:calendar_project/home/bloc/date_bloc.dart';
import 'package:calendar_project/home/model/schedule_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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
  void insertDummySchedule() async {
    final database = IsarDatabase();
    final isar = database.isar;
    final dummylist = List.generate(10, (index) {
      return Schedule()
        ..date = DateFormat('yyyy-MM-dd').format(DateTime.now())
        ..endTime = DateTime(2024, 1, 1, 10, 0)
        ..startTime = DateTime(2024, 1, 1, 9, 0)
        ..title = '서류 제출'
        ..subTitle = '9시까지 서류 제출'
        ..type = ScheduleType.work;
    });

    isar.writeTxn(() async {
      await isar.schedules.putAll(dummylist);
    });
  }

  @override
  void initState() {
    insertDummySchedule();
    // TODO: implement initState
    super.initState();
  }

  final _bloc = DateBloc();

  // 선택된 날짜
  DateTime _isSelectedDay = DateTime.now().add(Duration(days: 1));
  // 현재 보여지는 달을 결정
  DateTime _focusday = DateTime.utc(2024, 06, 01);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          StreamBuilder(
              stream: _bloc.dateStream,
              builder: (context, AsyncSnapshot<DateTime> snapshot) {
                final selectedDate = snapshot.data;
                print(selectedDate);
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
                      // print("선택 날짜 $selectedDay");
                      // print("강조 날짜 $focusedDay");
                      _bloc.selectDate(selectedDay);
                      _bloc.getScheduleList(selectedDay);
                      setState(() {
                        _isSelectedDay = selectedDay;
                        // _focusday = focusedDay;
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
                  print(list);
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
              builder: (context) {
                return Container();
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ScheduleContainer extends StatelessWidget {
  final int index;
  final Schedule schedule;

  const ScheduleContainer({
    super.key,
    required this.index,
    required this.schedule,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: index.isEven ? Colors.teal.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        tileColor: Colors.white,
        // shape: RoundedRectangleBorder(
        //     side: const BorderSide(color: Colors.teal),
        //     borderRadius: BorderRadius.circular(10)),
        leading: CircleAvatar(
          child:
              Text("${schedule.startTime.hour}:${schedule.startTime.minute}"),
        ),
        title: Text(schedule.title),
        subtitle: Text(schedule.subTitle ?? ""),
        trailing: Container(
          width: 20,
          decoration:
              BoxDecoration(color: schedule.type.color, shape: BoxShape.circle),
        ),
      ),
    );
  }
}
