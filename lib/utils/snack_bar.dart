import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSnackbar(title, message) {
  Get.snackbar(
    title,
    message,
    backgroundColor: Colors.white.withOpacity(0.7),
    colorText: Colors.black,
  );
}
