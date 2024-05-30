import 'package:flutter/material.dart';

class CustomWheelList extends StatelessWidget {
  final List<String> data;

  const CustomWheelList({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return ListWheelScrollView(
        physics: const FixedExtentScrollPhysics(),
        itemExtent: 20,
        diameterRatio: 1.5,
        squeeze: 0.8,
        perspective: 0.01,
        children: data.map((e) => Text(e)).toList());
  }
}
