import 'package:accountbook/hive/CalendarTypeAdapter.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class AccountListWidget extends StatelessWidget {
  final Box box = Hive.box('calendarData');
  @override
  Widget build(BuildContext context) {
    for (var key in box.keys) {
      String changeFormat = DateFormat('yyyy-MM-dd').format(DateTime.parse(key));
      List<CalendarModel> eventList = box.get(key)?.cast<CalendarModel>() ?? [];

      for (CalendarModel temp in eventList) {

      }
    }
    return ListView.builder(
        itemCount: box.length,
        itemBuilder: (context, index) {
          return Center(
            child: Column(
              children: <Widget>[
                Text(DateFormat('yyyy-MM-dd').format(DateTime.parse(box.keyAt(box.length - index - 1))), ),
                const Divider(color: Colors.black, height: 1,),
                for(CalendarModel calmodel in box.get(box.keyAt(box.length - index - 1))) calendarView(calmodel)
              ],
            ),
          );
        },
    );
  }

  Widget calendarView(CalendarModel calendarModel) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      alignment: Alignment.centerLeft,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black, width: 1, style: BorderStyle.solid)),
      ),
      child: Column(
        children: <Widget>[
          Text('제목 : ${calendarModel.title}'),
          Text('상세 : ${calendarModel.detail}'),
          Text('금액 : ${calendarModel.account.toString()}'),
        ],
      ),
    );
  }
}
