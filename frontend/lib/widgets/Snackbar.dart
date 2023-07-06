
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

Future <void> Snackbar(String header,String content,Color color,{int? duration} ) async {

   await  Get.snackbar(header, content,
    snackPosition: SnackPosition.BOTTOM, // Position of the snackbar
    backgroundColor: color, // Background color of the snackbar
    colorText: Colors.white, // Text color of the snackbar
    duration:  Duration(seconds: duration??3 )
    );


}