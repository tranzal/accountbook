import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

part 'CalendarTypeAdapter.g.dart';

@HiveType(typeId: 1)
class CalendarModel{
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String detail;
  @HiveField(2)
  final int account;

  @override
  String toString() => '내용 : $title 금액 : ${NumberFormat('###,###,###,###').format(account).replaceAll(' ', '')} ';

  CalendarModel({required this.title, required this.account, required this.detail});
}