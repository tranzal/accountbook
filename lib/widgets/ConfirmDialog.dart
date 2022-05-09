import 'package:flutter/material.dart';

void confirm(BuildContext context, String contentText) {

  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(contentText),
          actions: [
            // The "Yes" button
            TextButton(
                onPressed: () async {
                },
                child: const Text('확인')),
            TextButton(
                onPressed: () {
                  // Close the dialog
                  Navigator.of(context).pop();
                },
                child: const Text('취소'))
          ],
        );
      }
  );
}