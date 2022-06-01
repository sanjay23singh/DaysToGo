import 'dart:io';
import 'dart:developer' as developer;
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallpaper/Functions/screenshot_functions.dart';
import 'package:wallpaper/universal_variables.dart';

Future<void> getPermissions() async {
  await AndroidAlarmManager.initialize();
  var status = await Permission.manageExternalStorage.status;
  if (status.isDenied) {
    await Permission.manageExternalStorage.request();
  }
}

Future<void> callback() async {
  await getApplicationDocumentsDirectory().then((directory) async {
    developer.log("A");

    final prefs = await SharedPreferences.getInstance();
    int dayNo = 1;
    bool cout = false;
    developer.log("B");

    int today = DateTime.now().day;
    int yesterday = DateTime.now().subtract(const Duration(hours: 24)).day;

    int prevDay = prefs.getInt('prevDay')!.toInt();

    if (yesterday == prevDay || prevDay == -1) {
      cout = true;
      int val = prefs.getInt('currentDay')!.toInt();
      dayNo = val + 1;
      int remDays = prefs.getInt('remainingDays')!.toInt();
      prefs.setInt('currentDay', val + 1);
      prefs.setInt('prevDay', today);
      prefs.setInt('remainingDays', remDays - 1);

      developer.log("C");
      String dirPath = '${directory.path}/wallpapers';
      String filePath = '$dirPath/wallpaper$dayNo.png';
      developer.log(filePath);

      await File(filePath).exists().then((bool val) {
        if (!val) {
          developer.log('path doesnt exist');
        } else {
          developer.log('path does exist');
          setWallpaper(filePath);
          developer.log(DateTime.now().toString());
        }
      });

      developer.log("F");
    } else {
      developer.log('Not this time babe');
    }
  });
}

initializeVariables() async {
  appDocDir = await getApplicationDocumentsDirectory();
  Directory('${appDocDir.path}/wallpapers')
      .create(recursive: true)
      .then((Directory directory) async {
    appDocDir = directory;
    appDocPath = directory.path;
  });
}

getSpinkit(t) {
  return Container(
    color: Colors.black54,
    child: Column(
      // mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        SpinKitWave(
          color: Colors.green,
          size: 50.0,
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          'Setting Wallpaper Service',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
        )
      ],
    ),
  );
}

Widget getNumOfDays(DateTime startDate, DateTime endDate) {
  int numOfDays = endDate.difference(startDate).inDays;
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        alignment: Alignment.center,
        child: Text(
          numOfDays.toString(),
          style: const TextStyle(fontSize: 90, fontWeight: FontWeight.bold),
        ),
      ),
      Container(
        // padding: const EdgeInsets.symmetric(vertical: 5),
        alignment: Alignment.center,

        child: const Text(
          'Days',
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
      ),
    ],
  );
}
