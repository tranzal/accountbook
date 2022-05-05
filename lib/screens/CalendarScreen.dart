import 'package:accountbook/widgets/complexCalendar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CalendarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Get.reload();
            }
            ),
        title: const Text('TableCalendar Example'),
      ),
      body: Center(
        child: TableComplexExample(),
      ),
    );
  }
}
