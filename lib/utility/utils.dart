import 'dart:developer' as developer;
import 'dart:io';
import 'dart:typed_data';

import 'package:bus_booking_app/utility/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  // ignore: non_constant_identifier_names
  static logData(String TAG, dynamic message) {
    developer.log(message.toString(), name: TAG);
  }

  static String formatTime(int timeInSeconds) {
    int hours = timeInSeconds ~/ 3600;
    int minutes = (timeInSeconds ~/ 60) % 60;
    int seconds = timeInSeconds % 60;

    String formattedHours = hours.toString().padLeft(2, '0');
    String formattedMinutes = minutes.toString().padLeft(2, '0');
    String formattedSeconds = seconds.toString().padLeft(2, '0');

    if (hours > 0) {
      return '$formattedHours:$formattedMinutes:$formattedSeconds';
    } else {
      return '$formattedMinutes:$formattedSeconds';
    }
  }

  static void getSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: BrandColors.primary,
          ),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w500),
          )),
    );
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static Future<void> launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.inAppWebView);
  }

  static Future<File> uint8ListToFile(Future<Uint8List> uint8ListFuture, String fileName) async {
    Uint8List uint8List = await uint8ListFuture;
    Directory tempDir = await getTemporaryDirectory();
    File file = File('${tempDir.path}/$fileName');
    return await file.writeAsBytes(uint8List);
  }

  static String formatNumber(int number) {
  final NumberFormat formatter = NumberFormat('##,##,###');
  return formatter.format(number);
}
}
