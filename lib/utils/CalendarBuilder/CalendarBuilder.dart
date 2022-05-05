import 'package:accountbook/hive/CalendarTypeAdapter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

CalendarBuilders<CalendarModel> calendarBuilders() {
  return CalendarBuilders(
    selectedBuilder: (context, date, events) => Container(
        margin: const EdgeInsets.all(4.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10.0)),
        child: Text(
          date.day.toString(),
          style: const TextStyle(color: Colors.white),
        )
    ),
    todayBuilder: (context, date, events) => Container(
        margin: const EdgeInsets.all(4.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.orange, borderRadius: BorderRadius.circular(10.0)),
        child: Text(
          date.day.toString(),
          style: const TextStyle(color: Colors.white),
        )
    ),
    markerBuilder: (context, date, events) {
      if (events.isNotEmpty) {
        int a = 0;

        events.forEach((element) {
          a += element.account;
        });

        return Positioned(
          bottom: 1,
          child: Text(
              NumberFormat('###,###,###,###').format(a).replaceAll(' ', ''),
            style: TextStyle(
              fontSize: 12,
                color: accountColor(a)
            ),
          ),
        );
      }
      return null;
    }
  );
}

Color accountColor(int a){
  if(a > 0){
    return Colors.red;
  }
  if(a < 0){
    return Colors.blue;
  }
  return Colors.black;
}
