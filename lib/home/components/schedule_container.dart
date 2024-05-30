import 'package:calendar_project/collection/schedule_schema.dart';
import 'package:flutter/material.dart';

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
