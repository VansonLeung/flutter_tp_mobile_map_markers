
import 'package:flutter/material.dart';

void TPToast(BuildContext context, String msg) {
  var snackBar = SnackBar(
    content: Text(msg, style: const TextStyle(color: Color(0xFFFFFFFF) ),),
    backgroundColor: const Color(0xFF118811),
    behavior: SnackBarBehavior.floating,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

