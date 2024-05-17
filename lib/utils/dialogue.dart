import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Dialogue {
  static void showDialogueBox(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('No Internet'),
            content: const Text("Please chek your internet connection"),
            actions: [
              CupertinoButton.filled(
                onPressed: () {},
                child: const Text("Retry"),
              ),
            ],
          );
        });
  }
}
