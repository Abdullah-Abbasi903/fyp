import 'package:flutter/material.dart';

void snackBar(BuildContext context, String text,[Color color=Colors.grey]) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 1),
      content: Text(text),
      backgroundColor: color,
    ),
  );
}
