import 'dart:collection';

import 'package:accountbook/hive/CalendarTypeAdapter.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

import '../utils/CalendarUtil.dart';

class CalendarController extends GetxController{
  late PageController pageController;
  late ValueNotifier<List<CalendarModel>> selectedEvents;
  ValueNotifier<DateTime> focusedDay = ValueNotifier(DateTime.now());
  Set<DateTime> selectedDays = LinkedHashSet<DateTime>(
    equals: isSameDay,
    hashCode: getHashCode,
  );
  String title = '';
  String detail = '';
  int account = 0;

  void pageControlInit(PageController _pageController){
    pageController = _pageController;
    update();
  }

  void selectedEventsInit(List<CalendarModel> _selectedEvents){
    selectedEvents = ValueNotifier(_selectedEvents);
    update();
  }

  void selectedEventsChange(List<CalendarModel> _selectedEvents){
    selectedEvents.value = _selectedEvents;
    update();
  }

  void focusedDayChange(DateTime _focusedDay){
    focusedDay.value = _focusedDay;
    update();
  }

  void selectedDaysChange(Set<DateTime> _selectedDays){
    selectedDays = _selectedDays;
    update();
  }

  void titleChange(String _title){
    title = _title;
    update();
  }

  void detailChange(String _detail){
    detail = _detail;
    update();
  }

  void accountChange(int _account){
    account = _account;
    update();
  }

  void titleReset(){
    title = '';
    update();
  }

  void detailReset(){
    detail = '';
    update();
  }

  void accountReset(){
    account = 0;
    update();
  }
}