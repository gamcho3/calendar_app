import 'package:calendar_project/collection/schedule_schema.dart';
import 'package:calendar_project/const/const.dart';
import 'package:calendar_project/db/isar_database.dart';
import 'package:calendar_project/home/bloc/date_bloc.dart';
import 'package:calendar_project/home/components/custom_scroll_list.dart';
import 'package:calendar_project/home/components/schedule_button.dart';
import 'package:dev/dev.dart';
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
          final ValueNotifier<ScheduleType> selectedType =
              ValueNotifier(ScheduleType.work);
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return ScheduleForm(selectedType: selectedType);
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ScheduleForm extends StatelessWidget {
  const ScheduleForm({
    super.key,
    required this.selectedType,
  });

  final ValueNotifier<ScheduleType> selectedType;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    return Container(
      height: height * 0.5,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("취소")),
                TextButton(onPressed: () {}, child: Text("저장")),
              ],
            ),
          ),
          TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.title_outlined),
              hintText: "제목 추가",
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Icon(Icons.watch_later_outlined), Text("오후 1: 20")],
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                left: 10,
                right: 10,
                child: Container(
                    height: 30,
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10))),
              ),
              SizedBox(
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 50,
                      child: CustomWheelList(
                        data: AMPM,
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      child: CustomWheelList(
                        data: HOUR,
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      child: CustomWheelList(
                        data: MiNUTE,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          TextField(
            decoration: const InputDecoration(
                prefixIcon: Icon(Icons.description_outlined),
                hintText: "부가 설명"),
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              children: ScheduleType.values
                  .map((e) => Row(
                        children: [
                          ScheduleButton(
                            type: e,
                            selectedType: selectedType,
                          ),
                          SizedBox(
                            width: 10,
                          )
                        ],
                      ))
                  .toList(),
            ),
          )
        ],
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
