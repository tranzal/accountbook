import 'dart:collection';

import 'package:accountbook/controller/CalendarController.dart';
import 'package:accountbook/hive/CalendarTypeAdapter.dart';
import 'package:accountbook/utils/CalendarBuilder/CalendarBuilder.dart';
import 'package:accountbook/utils/CalendarUtil.dart';
import 'package:accountbook/widgets/CalendarHeader.dart';
import 'package:accountbook/widgets/ShowDatePickerPop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:hive/hive.dart';

class TableComplexExample extends StatefulWidget {
  @override
  _TableComplexExampleState createState() => _TableComplexExampleState();
}

class _TableComplexExampleState extends State<TableComplexExample> {
  final calendarController = Get.put(CalendarController());
  final Box box = Hive.box('calendarData');
  late final ValueNotifier<List<CalendarModel>> _selectedEvents;
  final ValueNotifier<DateTime> _focusedDay = ValueNotifier(DateTime.now());
  final Set<DateTime> _selectedDays = LinkedHashSet<DateTime>(
    equals: isSameDay,
    hashCode: getHashCode,
  );
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  String title = '';
  String detail = '';
  int account = 0;



  @override
  void initState() {
    super.initState();
    _selectedDays.add(_focusedDay.value);
    _selectedEvents = ValueNotifier(_getEventsForDay(_focusedDay.value));
  }

  @override
  void dispose() {
    _focusedDay.dispose();
    _selectedEvents.dispose();
    super.dispose();
  }

  bool get canClearSelection =>
      _selectedDays.isNotEmpty || _rangeStart != null || _rangeEnd != null;

  List<CalendarModel> _getEventsForDay(DateTime day) {
    return box.get(day.toString())?.cast<CalendarModel>()?? [];
  }

  List<CalendarModel> _getEventsForDays(Iterable<DateTime> days) {
    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  List<CalendarModel> _getEventsForRange(DateTime start, DateTime end) {
    final days = daysInRange(start, end);
    return _getEventsForDays(days);
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {

    setState(() {
      if (_selectedDays.contains(selectedDay)) {
        _selectedDays.remove(selectedDay);
      } else {
        _selectedDays.add(selectedDay);
      }

      _focusedDay.value = focusedDay;
      _rangeStart = null;
      _rangeEnd = null;
      _rangeSelectionMode = RangeSelectionMode.toggledOff;
    });

    _selectedEvents.value = _getEventsForDays(_selectedDays);

    setState(() {
      _rangeStart = null;
      _rangeEnd = null;
      _selectedDays.clear();
      _selectedDays.add(_focusedDay.value);
      _selectedEvents.value = [];
      _selectedEvents.value = _getEventsForDays(_selectedDays);
    });
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {

    setState(() {
      _focusedDay.value = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _selectedDays.clear();
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        listenableBuilder(),
        TableCalendar<CalendarModel>(
          locale: 'ko-KR',
          weekendDays: const [DateTime.saturday, DateTime.sunday],
          calendarBuilders: calendarBuilders(),
          calendarStyle: CalendarStyle(
            outsideDaysVisible: true,
            weekendTextStyle: const TextStyle().copyWith(color: Colors.red),
            holidayTextStyle: const TextStyle().copyWith(color: Colors.blue[800]),
          ),
          firstDay: kFirstDay,
          lastDay: kLastDay,
          focusedDay: _focusedDay.value,
          headerVisible: false,
          selectedDayPredicate: (day) => _selectedDays.contains(day),
          rangeStartDay: _rangeStart,
          rangeEndDay: _rangeEnd,
          calendarFormat: _calendarFormat,
          rangeSelectionMode: _rangeSelectionMode,
          eventLoader: _getEventsForDay,
          holidayPredicate: (day) {
            // Every 20th day of the month will be treated as a holiday
            return day.day == 0;
          },
          onDaySelected: _onDaySelected,
          onRangeSelected: _onRangeSelected,
          onCalendarCreated: (controller) => calendarController.pageControlInit(controller),
          onPageChanged: (focusedDay) => _focusedDay.value = focusedDay,
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              setState(() => _calendarFormat = format);
            }
          },
        ),
        const SizedBox(height: 8.0),
        Expanded(
          child: ValueListenableBuilder<List<CalendarModel>>(
            valueListenable: _selectedEvents,
            builder: (context, value, _) {
              return ListView.builder(
                itemCount: value.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListTile(
                      onTap: () {
                        modifyDialog(value[index], index);
                      },
                      title: Text('${value[index]}'),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
  Widget listenableBuilder(){
    return ValueListenableBuilder<DateTime>(
      valueListenable: _focusedDay,
      builder: (context, value, _) {
        return CalendarHeader(
          focusedDay: value,
          clearButtonVisible: canClearSelection,
          onTodayButtonTap: () {
            setState(() => _focusedDay.value = DateTime.now());
          },
          onClearButtonTap: () {
            if(_selectedDays.isEmpty){
              return;
            }
            box.delete(_selectedDays.elementAt(0).toString());
            setState(() {
              _rangeStart = null;
              _rangeEnd = null;
              _selectedEvents.value = [];
            });
          },
          onAddTap: () {
            if(_selectedDays.isEmpty){
              return;
            }
            bottomSheet(context);
          },
          onLeftArrowTap: () {
            calendarController.pageController.previousPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          },
          onRightArrowTap: () {
            calendarController.pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          },
        );
      },
    );
  }

  void modifyDialog(CalendarModel model, int index){
    Get.dialog(
        AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("수정"),
              IconButton(
                icon: const Icon(Icons.clear, size: 20.0),
                visualDensity: VisualDensity.compact,
                onPressed: () {
                  Get.back();
                },
              )
            ],
          ),
          content: Container(
            margin: EdgeInsets.zero,
            height: MediaQuery.of(context).size.height * 0.25,
            child: Column(
              children: [
                TextField(
                  controller: TextEditingController(text: model.title),
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '사용 내역',
                  ),
                  onChanged: (value) {
                    setState(() {
                      title = value;
                    });
                  },
                  onTap: () {
                    setState(() {
                      title = model.title;
                    });
                  },
                ),
                TextField(
                  controller: TextEditingController(text: model.detail),
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '상세내역',
                  ),
                  onChanged: (value) {
                    setState(() {
                      detail = value;
                    });
                  },
                  onTap: () {
                    setState(() {
                      detail = model.detail;
                    });
                  },
                ),
                TextField(
                  controller: TextEditingController(text: NumberFormat('###,###,###,###').format(model.account).replaceAll(' ', '')),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.singleLineFormatter,
                    // FilteringTextInputFormatter.allow(RegExp(r'^-?[0-9]\d*(\.\d+)?$')),
                  ],
                  keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '금액',
                  ),
                  onChanged: (value) {

                    String replaceValue = value.replaceAll(',', '');

                    if(replaceValue.isEmpty){
                      setState(() {
                        account = 0;
                      });
                      return;
                    }

                    if((!replaceValue.startsWith('-') && !replaceValue.isNum) || (replaceValue.startsWith('-') && !replaceValue.isNum && replaceValue.length > 1)){
                      print("asdfasdfasdf");
                      return;
                    }

                    if(replaceValue.startsWith('-') && replaceValue.length > 1){
                      setState(() {
                        account = int.parse(replaceValue);
                      });
                      return;
                    }
                    if(!replaceValue.startsWith('-')){
                      setState(() {
                        account = int.parse(replaceValue);
                      });
                      return;
                    }
                  },
                  onTap: () {
                    setState(() {
                      account = model.account;
                    });
                  },
                )
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text("수정"),
              onPressed: () {
                List<CalendarModel> eventList = box.get(_selectedDays.elementAt(0).toString())?.cast<CalendarModel>()?? [];
                eventList[index] = (CalendarModel(title: title, account: account, detail: detail));
                box.put(_selectedDays.elementAt(0).toString(), eventList);
                setState(() {
                  _selectedEvents.value = _getEventsForDays(_selectedDays);
                });
                Get.back();
              },
            ),
            ElevatedButton(
              child: const Text("삭제"),
              onPressed: () {
                List<CalendarModel> eventList = box.get(_selectedDays.elementAt(0).toString())?.cast<CalendarModel>()?? [];
                eventList.removeAt(index);
                setState(() {
                  _selectedEvents.value = _getEventsForDays(_selectedDays);
                });
                Get.back();
              },
            )
          ],
        )
    );
  }
  void bottomSheet(BuildContext context) {
    DateTime startDate = DateTime.now();
    DateTime endDate = DateTime.now();
    List<CalendarModel> eventList = box.get(_selectedDays.elementAt(0).toString())?.cast<CalendarModel>()?? [];

    Get.bottomSheet(
        StatefulBuilder(
          builder: (context, setState) {
            return Container(
              color: Colors.blue,
              child: Wrap(
                children: <Widget>[
                  TextField(
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '사용 내역',
                    ),
                    onChanged: (value) {
                      setState(() {
                        title = value;
                      });
                    },
                    onTap: () {
                      setState(() {
                        title = '';
                      });
                    },
                  ),
                  TextField(
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '상세내역',
                    ),
                    onChanged: (value) {
                      setState(() {
                        detail = value;
                      });
                    },
                    onTap: () {
                      setState(() {
                        detail = '';
                      });
                    },
                  ),
                  TextField(
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.singleLineFormatter
                      // FilteringTextInputFormatter.allow(RegExp(r'^[+-]?([0-9]+([.][0-9]*)?|[.][0-9]+)$')),
                      // FilteringTextInputFormatter.allow(RegExp('^(0|[-]?[1-9]\d*)$')),
                    ],
                    keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '금액',
                    ),
                    onChanged: (value) {

                      if(value.isEmpty){
                        setState(() {
                          account = 0;
                        });
                        return;
                      }

                      if((!value.startsWith('-') && !value.isNum) || (value.startsWith('-') && !value.isNum && value.length > 1)){
                        print("asdfasdfasdf");
                        return;
                      }

                      if(value.startsWith('-') && value.length > 1){
                        setState(() {
                          account = int.parse(value);
                        });
                        return;
                      }
                      if(!value.startsWith('-')){
                        setState(() {
                          account = int.parse(value);
                        });
                        return;
                      }
                    },
                    onTap: () {
                      setState(() {
                        account = 0;
                      });
                    },
                  ),
                  // DatePickerDialog(initialDate: _selectedDays.elementAt(0), firstDate: _selectedDays.elementAt(0), lastDate: _selectedDays.elementAt(0).add(const Duration(days: 1000)),),
                  Row(
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                            textStyle: MaterialStateProperty.all(const TextStyle(
                                color: Colors.black
                            )),
                            backgroundColor: MaterialStateProperty.all(Colors.white)
                        ),
                        onPressed: () {
                          Future<DateTime?> selectedDate = popupDatePicker(context, _selectedDays.elementAt(0));
                          selectedDate.then((dateTime) {
                            if(int.parse(dateTime!.difference(DateTime.now()).inDays.toString()) < 0){
                              return;
                            }
                            startDate = dateTime;
                            setState((){
                            });
                          });
                        },
                        child: Text(DateFormat('yyyy-MM-dd').format(startDate), style: const TextStyle(color: Colors.black)),
                      ),
                      const Text(' ~ '),
                      ElevatedButton(
                        style: ButtonStyle(
                            textStyle: MaterialStateProperty.all(const TextStyle(
                                color: Colors.black
                            )),
                            backgroundColor: MaterialStateProperty.all(Colors.white)
                        ),
                        onPressed: () {
                          Future<DateTime?> selectedDate = popupDatePicker(context, _selectedDays.elementAt(0));

                          selectedDate.then((dateTime) {
                            if(int.parse(dateTime!.difference(startDate).inDays.toString()) < 0){
                              return;
                            }
                            endDate = dateTime;
                            setState((){});
                          });

                        },
                        child: Text(DateFormat('yyyy-MM-dd').format(endDate), style: const TextStyle(color: Colors.black)),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            if(title.isEmpty || account == 0 || detail.isEmpty){
                              Get.defaultDialog(
                                  title: '값을 입력해 주세요'
                              );
                              return;
                            }
                            eventList.add(CalendarModel(title: title, account: account, detail: detail));
                            box.put(_selectedDays.elementAt(0).toString(), eventList);
                            setState(() {
                              _selectedEvents.value = _getEventsForDays(_selectedDays);
                            });
                            Get.back();
                          },
                          child: const Text('저장')
                      ),
                      ElevatedButton(
                          onPressed: () {
                            if(title.isEmpty || account == 0 || detail.isEmpty){
                              Get.defaultDialog(
                                  title: '값을 입력해 주세요'
                              );
                              return;
                            }
                            eventList.add(CalendarModel(title: title, account: account, detail: detail));
                            DateTime date = startDate;
                            // while(true){
                            //   if(endDate == date){
                            //     return;
                            //   }
                            //   box.put(date, eventList);
                            //   date = DateTime(date.year, date.month + 1, date.day);
                            // }

                            setState(() {
                              _selectedEvents.value = _getEventsForDays(_selectedDays);
                            });
                            Get.back();
                          },
                          child: const Text('반복 저장')
                      )
                    ],
                  ),
                ],
              ),
            );
          },
        ),

    );
  }

}