


import 'package:accountbook/utils/CalendarUtil.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class EventTypeAdapter{
  @HiveField(0)
  final Event event;

  EventTypeAdapter({required this.event});
}