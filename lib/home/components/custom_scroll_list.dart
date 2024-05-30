import 'package:calendar_project/home/model/time_model.dart';
import 'package:flutter/material.dart';

class CustomWheelList extends StatelessWidget {
  final List<String> data;
  final String type;
  final ValueNotifier<Map<String, String>> notifier;

  const CustomWheelList({
    super.key,
    required this.data,
    required this.notifier,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return ListWheelScrollView(
        onSelectedItemChanged: (index) {
          notifier.value = {
            ...notifier.value,
            type: data[index],
          };
        },
        physics: const FixedExtentScrollPhysics(),
        itemExtent: 20,
        diameterRatio: 1.5,
        squeeze: 0.8,
        perspective: 0.01,
        children: data.map((e) => Text(e)).toList());
  }
}
