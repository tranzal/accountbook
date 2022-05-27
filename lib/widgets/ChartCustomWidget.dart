import 'dart:math';

import 'package:accountbook/hive/CalendarTypeAdapter.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart' as date;

class ChartCustomWidget extends StatelessWidget {
  final Box box = Hive.box('calendarData');
  @override
  Widget build(BuildContext context) {
    List<String> labels = ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12',];
    List<double> data = List.filled(12, 0);
    bool check = false;
    if(box.length > 0) {
      check = true;
    }
    if(check) {
      for (var key in box.keys) {
        String changeFormat = date.DateFormat('MM').format(DateTime.parse(key));
        List<CalendarModel> eventList = box.get(key)?.cast<CalendarModel>() ??
            [];
        double account = 0;

        for (CalendarModel temp in eventList) {
          if (temp.account < 0) {
            account += temp.account * -1;
          }
        }

        int labelIndex = labels.indexOf(changeFormat);
        data[labelIndex] += account;
      }
    }

    return Container(
      alignment: Alignment.topCenter,
      child: Center(
        child: check ? CustomPaint(
          size: const Size(350, 600),
          foregroundPainter:  BarChart(
            data: data,
            labels: labels,
            color: Colors.deepOrange,
          ),
        ) : const Text('처리 할 값이 없습니다.'),
      ),
    );
  }
}

class BarChart extends CustomPainter {
  final Color color;
  final List<double> data;
  final List<String> labels;
  double bottomPadding = 0.0;
  double leftPadding = 0.0;
  double textScaleFactorXAxis = 1.0;
  double textScaleFactorYAxis = 1.2;

  BarChart({
    required this.data,
    required this.labels,
    this.color = Colors.blue
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 텍스트 공간을 미리 정한다.
    setTextPadding(size);

    var coordinates = getCoordinates(size);

    drawBar(canvas, size, coordinates);
    drawXLabels(canvas, size, coordinates);
    drawYLabels(canvas, size, coordinates);
    drawLines(canvas, size, coordinates);
  }

  @override
  bool shouldRepaint(BarChart oldDelegate) {
    return oldDelegate.data != data;
  }

  void setTextPadding(Size size) {
    // 세로 크기의 1/10 만큼 텍스트 패딩
    bottomPadding = size.height / 10;
    // 가로로 기의 1/10 만큼 텍스트 패딩
    leftPadding = size.width / 10;
  }

  void drawBar(Canvas canvas, Size size, List<Offset> coordinates) {
    var paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    // 막대 그래프가 겹치지 않게 간격을 준다.
    var barWidthMargin = size.width * 0.09;

    for(var index = 0 ; index < coordinates.length ; index ++) {
      var offset = coordinates[index];
      var left = offset.dx;
      // 간격만큼 가로로 이동
      var right = offset.dx + barWidthMargin;
      var top = offset.dy;
      // 텍스트가 겹치지 않게 하기위해 텍스트의 크기만큼 패딩을 빼준다.
      var bottom = size.height - bottomPadding;

      var rect = Rect.fromLTRB(left, top, right, bottom);

      canvas.drawRect(rect, paint);
    }
  }

  // x축 텍스트를 그린다.
  void drawXLabels(Canvas canvas, Size size, List<Offset> coordinates) {
    //화면 크기에 따라 유동적으로 폰트 크기를 계산
    var fontSize = calculateFontSize(labels[0], size, xAxis: true);

    for(var index = 0 ; index < labels.length ; index ++) {
      var span = TextSpan(
          style: TextStyle(
              fontSize: fontSize,
              color: Colors.black,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400
          ),
          text: labels[index]
      );

      var tp = TextPainter(text: span, textDirection: TextDirection.ltr);

      tp.layout();

      var offset = coordinates[index];
      var dx = offset.dx;
      var dy = size.height - tp.height;

      tp.paint(canvas, Offset(dx, dy));
    }
  }

  // y 축 텍스트를 그린다. 최저값과 최고값을 Y축에 표시
  void drawYLabels(Canvas canvas, Size size, List<Offset> coordinates) {
    var bottomY = coordinates[0].dy;
    var topY = coordinates[0].dy;
    var indexOfMin = 0;
    var indexOfMax = 0;

    for(var index = 0 ; index < coordinates.length ; index ++) {
      var dy = coordinates[index].dy;

      if(bottomY < dy) {
        bottomY = dy;
        indexOfMin = index;
      }

      if(topY > dy) {
        topY = dy;
        indexOfMax = index;
      }
    }
    var minValue = '${data[indexOfMin].toInt()}';
    var maxValue = '${data[indexOfMax].toInt()}';

    var fontSize = calculateFontSize(maxValue, size, xAxis: false) + 4;

    drawYText(canvas, minValue, fontSize, bottomY);
    drawYText(canvas, maxValue, fontSize, topY);
  }

  //화면 크기에 비례해 폰트 크기를 계산한다.
  double calculateFontSize(String value, Size size, {required bool xAxis}) {
    // 글자수에 따라 폰트 크기를 계산
    var numberOfCharacters = value.length;
    // width가 600 일 때 100글자를 적어야 한다면 글자 한개당 fontSize는 6
    var fontSize = (size.width / numberOfCharacters) / data.length;

    if(xAxis) {
      fontSize *= textScaleFactorXAxis;
    } else {
      fontSize *= textScaleFactorYAxis;
    }
    return fontSize;
  }

  // x, y 축을 구분하는 선을 그린다.
  void drawLines(Canvas canvas, Size size, List<Offset> coordinates) {
    var paint = Paint()
      ..color = Colors.blueGrey[100]!
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.8;

    var bottom = size.height - bottomPadding;
    var left = coordinates[0].dx;

    var path = Path();
    path.moveTo(left, 0);
    path.lineTo(left, bottom);
    path.lineTo(size.width, bottom);

    canvas.drawPath(path, paint);
  }

  void drawYText(Canvas canvas, String text, double fontSize, double y) {
    var span = TextSpan(
        style: TextStyle(
            fontSize: fontSize,
            color: Colors.black,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600
        ),
        text: text
    );

    var tp = TextPainter(text: span, textDirection: TextDirection.ltr);

    tp.layout();

    var offset = Offset(0.0, y);

    tp.paint(canvas, offset);
  }

  List<Offset> getCoordinates(Size size) {
    var coordinates = <Offset>[];

    var maxData = data.reduce(max);
    var width = size.width - leftPadding;
    var minBarWidth = width / data.length;

    for(var index = 0 ; index < data.length ; index ++) {
      // 그래프의 가로 위치 지정
      var left = minBarWidth * (index) + leftPadding;
      // 그래프의 높이가 [0~1] 사이가 되도록 정규화
      var normalized = data[index] / maxData;
      // x 축에 표시되는 글자가 겹치지 않도록 높이에서 패딩
      var height = size.height - bottomPadding;
      // 정규화된 값을 통해 높이 구하기
      var top = height - normalized * height;

      var offset = Offset(left, top);
      coordinates.add(offset);
    }

    return coordinates;
  }
}