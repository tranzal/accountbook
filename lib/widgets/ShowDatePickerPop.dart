
import 'package:flutter/material.dart';

void showDatePickerPop(BuildContext context) {
  Future<DateTime?> selectedDate = showDatePicker(
    context: context,
    initialDate: DateTime.now(), //초기값
    firstDate: DateTime.now(), //시작일
    lastDate: DateTime.now().add(const Duration(days: 30)), //마지막일
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.dark(), //다크 테마
        child: child!,
      );
    },
  );

  selectedDate.then((dateTime) {
    return dateTime;
  });
}