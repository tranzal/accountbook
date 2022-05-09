import 'package:accountbook/widgets/SideMenu.dart';
import 'package:accountbook/widgets/complexCalendar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CalendarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: SideMenu(),
      endDrawerEnableOpenDragGesture: false,
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Get.reload();
            }
          ),
        title: const Text('TableCalendar Example'),
        actions: [
          Builder(
              builder: (context){
                return IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openEndDrawer();
                    }
                );
              }
          ),
        ],
      ),
      body: Center(
        child: TableComplexExample(),
      ),
    );
  }
}
