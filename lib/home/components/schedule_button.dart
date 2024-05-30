import 'package:calendar_project/collection/schedule_schema.dart';
import 'package:flutter/material.dart';

class ScheduleButton extends StatefulWidget {
  final ScheduleType type;
  final ValueNotifier<ScheduleType> selectedType;

  const ScheduleButton({
    super.key,
    required this.type,
    required this.selectedType,
  });

  @override
  State<ScheduleButton> createState() => _ScheduleButtonState();
}

class _ScheduleButtonState extends State<ScheduleButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.selectedType.value = widget.type;
      },
      child: ValueListenableBuilder(
          valueListenable: widget.selectedType,
          builder: (context, value, _) {
            return Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: widget.type.color,
                  shape: BoxShape.circle,
                  border: widget.type == value
                      ? Border.all(
                          color: Colors.black,
                          width: 2,
                        )
                      : null),
              child: Center(
                child: Text(
                  widget.type.name.split('')[0].toUpperCase(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            );
          }),
    );
  }
}
