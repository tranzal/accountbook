import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DefaultAppBar extends StatefulWidget implements PreferredSizeWidget{
  const DefaultAppBar({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _DefaultAppBar createState() => _DefaultAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

class _DefaultAppBar extends State<DefaultAppBar> {
  late final String title;
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('My Personal Journal');

  @override
  Widget build(BuildContext context) {

    return AppBar(
      title: Text(widget.title),
      leading: IconButton(icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          }
      ),
      automaticallyImplyLeading: false,
      actions: <Widget>[
        // Builder(
        //     builder: (context){
        //     return IconButton(icon: customIcon,
        //         onPressed: () {
        //           const Center(
        //             child: TextField(
        //               decoration: InputDecoration(
        //                 hintText: '검색',
        //                 prefixIcon: Icon(Icons.search),
        //               ),
        //             ),
        //           );
        //         }
        //       );
        //     }
        // )
        // ,
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
    );
  }

}