
import 'package:flutter/material.dart';

Future<DateTime?> popupDatePicker(BuildContext context, DateTime selectDay){
  return showDatePicker(
    context: context,
    initialDate: selectDay, // 초깃값
    firstDate: DateTime(1900), // 시작일
    lastDate: DateTime(2099), // 마지막일
    builder: (context, child) {
      if(child != null){
        return Theme(
          data: ThemeData.dark(), // 다크테마
          child: child,
        );
      } else {
        return Theme(
          data: ThemeData.dark(), // 다크테마
          child: child?? const Text('Date Picker'),
        );
      }
    },
  );
}