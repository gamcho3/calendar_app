import 'package:calendar_project/home/bloc/date_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                return TableCalendar(
                  headerStyle: const HeaderStyle(
                      titleCentered: true, formatButtonVisible: false),
                  calendarStyle: CalendarStyle(
                    weekendTextStyle:
                        TextStyle(color: Colors.blue.withOpacity(0.6)),
                    defaultDecoration:
                        const BoxDecoration(shape: BoxShape.rectangle),
                    weekendDecoration: BoxDecoration(shape: BoxShape.rectangle),
                    todayDecoration: BoxDecoration(
                        color: Colors.teal.withOpacity(0.3),
                        shape: BoxShape.rectangle),
                    selectedDecoration: BoxDecoration(
                        color: Colors.teal, shape: BoxShape.rectangle),
                    outsideDecoration: BoxDecoration(shape: BoxShape.rectangle),
                  ),
                  locale: 'ko_KR',
                  focusedDay: _focusday,
                  firstDay: DateTime.utc(2024, 01, 01),
                  lastDay: DateTime.utc(2024, 12, 31),
                  selectedDayPredicate: (day) {
                    return isSameDay(_isSelectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    print("선택 날짜 $selectedDay");
                    print("강조 날짜 $focusedDay");
                    _bloc.selectDate(selectedDay);
                    setState(() {
                      _isSelectedDay = selectedDay;
                      // _focusday = focusedDay;
                    });
                  },
                );
              }),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return ListTile(
                    tileColor: Colors.white,
                    title: Text(index.toString()),
                    subtitle: Text("부제목"),
                  );
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
        child: Icon(Icons.add),
      ),
    );
  }
}
