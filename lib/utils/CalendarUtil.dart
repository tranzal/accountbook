import 'dart:collection';

import 'package:hive/hive.dart';
import 'package:table_calendar/table_calendar.dart';

/// Example event class.
class Event {
  final String title;
  final String pay;
  const Event(this.title, this.pay);

  @override
  String toString() => '내용 : ${title} 금액 : ${pay} ';


}

/// Example events.
///
/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);

final _kEventSource = {
    DateTime.utc(kFirstDay.year, kFirstDay.month, 3): List.generate(1, (index) => const Event('111111','asdfasdf'))
}..addAll({
    kToday: [
      const Event('Today\'s Event 1','아아아'),
      const Event('Today\'s Event 2','아아아'),
    ],
  });

int getHashCode(DateTime key) {

  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
