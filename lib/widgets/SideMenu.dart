import 'package:accountbook/screens/Setting.dart';
import 'package:accountbook/widgets/ConfirmDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SideMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.27,
            child: UserAccountsDrawerHeader(
                margin: EdgeInsets.zero,
                currentAccountPicture: ClipOval(
                  child: Material(
                    color: Colors.grey.withOpacity(0.3),
                    // child: Image.network(
                    //   userProvider.user.photoURL!,
                    //   fit: BoxFit.fitHeight,
                    // ),
                  ),
                ),
                // accountName: Text(userProvider.user.displayName.toString()),
                // accountEmail: Text(userProvider.user.email.toString()),
                accountName: const Text('이름'),
                accountEmail: const Text('이메일'),
                decoration: const BoxDecoration(color: Colors.blue)),
          ),
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.647,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Get.to(() => GoogleCalendar(key: UniqueKey()));
                    },
                    child: Container(
                      padding: EdgeInsets.zero,
                      margin: EdgeInsets.zero,
                      height: 60,
                      alignment: Alignment.centerLeft,
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(width: 1, color: Colors.grey)
                          )
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text("캘린더"),
                      ),
                    ),
                  )
                ],
              )),
          BottomNavigationBar(
              onTap: (int index) async {
                switch (index) {
                  case 0:
                    confirm(context, "로그아웃 하시겠습니까?");
                    break;
                  case 1:
                    Get.to(Setting());
                    break;
                }
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.logout), label: ''),
                BottomNavigationBarItem(icon: Icon(Icons.settings), label: '')
              ])
        ],
      ),
    );
  }
}

// ListView(
// padding: EdgeInsets.zero,
// children: <Widget>[
// ListTile(
// leading: Icon(
// Icons.home,
// color: Colors.grey[850],
// ),
// title: Text('공지사항'),
// onTap: () {
// print('Home is clicked');
// },
// trailing: Icon(Icons.add),
// ),
// ListTile(
// leading: Icon(
// Icons.question_answer,
// color: Colors.grey[850],
// ),
// title: Text('Q&A'),
// onTap: () {
// print('Q&A is clicked');
// },
// trailing: Icon(Icons.add),
// ),
// ],
// )