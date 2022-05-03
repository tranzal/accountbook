import 'package:accountbook/widgets/complexCalendar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CalendarScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TableCalendar Example'),
      ),
      body: Center(
        child: TableComplexExample(),
        ),
    );
  }
}