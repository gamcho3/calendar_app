import 'package:calendar_project/collection/schedule_schema.dart';
import 'package:calendar_project/const/const.dart';
import 'package:calendar_project/home/components/custom_scroll_list.dart';
import 'package:calendar_project/home/components/schedule_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduleForm extends StatefulWidget {
  const ScheduleForm({
    super.key,
    required this.selectedType,
  });

  final ValueNotifier<ScheduleType> selectedType;

  @override
  State<ScheduleForm> createState() => _ScheduleFormState();
}

class _ScheduleFormState extends State<ScheduleForm> {
  bool showCalendar = false;
  bool showTimePicker = false;
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<Map<String, String>> selectedTime =
        ValueNotifier({'ampm': '오전', 'hour': '9', 'minute': '00'});
    final height = MediaQuery.sizeOf(context).height;
    return SizedBox(
      height: height * 0.7,
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
              children: [
                Row(
                  children: [
                    Icon(Icons.watch_later_outlined),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                        onTap: () {
                          setState(() {
                            showCalendar = !showCalendar;
                            showTimePicker = false;
                          });
                        },
                        child: Text(DateFormat('yyyy년 MM월 dd일 EE요일', 'ko_KR')
                            .format(selectedDate)))
                  ],
                ),
                InkWell(
                    onTap: () {
                      setState(() {
                        showCalendar = false;
                        showTimePicker = !showTimePicker;
                      });
                    },
                    child: ValueListenableBuilder(
                        valueListenable: selectedTime,
                        builder: (context, value, _) {
                          print(value);
                          return Text(
                              "${value['ampm']} ${value['hour']}시 ${value['minute']}분");
                        }))
              ],
            ),
          ),
          Visibility(
            visible: showCalendar,
            child: Flexible(
              fit: FlexFit.loose,
              flex: 1,
              child: CalendarDatePicker(
                  initialDate: selectedDate,
                  firstDate: DateTime(2024),
                  lastDate: DateTime(2025),
                  onDateChanged: (date) {
                    setState(() {
                      selectedDate = date;
                    });
                  }),
            ),
          ),
          if (showTimePicker)
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
                          notifier: selectedTime,
                          data: AMPM,
                          type: 'ampm',
                        ),
                      ),
                      SizedBox(
                        width: 50,
                        child: CustomWheelList(
                          notifier: selectedTime,
                          data: HOUR,
                          type: 'hour',
                        ),
                      ),
                      SizedBox(
                        width: 50,
                        child: CustomWheelList(
                          notifier: selectedTime,
                          data: MiNUTE,
                          type: 'minute',
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
                            selectedType: widget.selectedType,
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
