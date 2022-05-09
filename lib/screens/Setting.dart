
import 'package:accountbook/widgets/DefaultAppBar.dart';
import 'package:accountbook/widgets/SideMenu.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Setting extends StatefulWidget {
  @override
  _Setting createState() => _Setting();
}

class _Setting extends State<Setting> {
  bool switchValue = Hive.box('aramBox').get('aramSwitch',defaultValue: true);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(title: '설정'),
      endDrawer: SideMenu(),
      endDrawerEnableOpenDragGesture: false,
      body:Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          SwitchListTile(
            value: switchValue,
            onChanged: (newValue) async {
              Hive.box('aramBox').put('aramSwitch', newValue);
              setState(() {
                switchValue = newValue;
              });
            },
            title: const Text(
              '알림받기',
            ),
            tileColor: const Color(0xFFF5F5F5),
            dense: false,
            controlAffinity: ListTileControlAffinity.trailing,
          ),
        ],
      )
      ,
    );
  }



}