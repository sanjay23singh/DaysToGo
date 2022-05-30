import 'dart:io';
import 'dart:developer' as developer;
import 'dart:isolate';
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

    final prefs = await SharedPreferences.getInstance();
    int dayNo = 1;
    bool cout=false;
    if (!prefs.containsKey('day')) {
      cout=true;
      prefs.setInt('day', 1);
    } else {
      dayNo = prefs.getInt('day')!.toInt() + 1;

      prefs.setInt('day', dayNo);
    }

    String dirPath = '${directory.path}/wallpapers';
    String filePath = '$dirPath/wallpaper$dayNo.png';
    developer.log(filePath);

    int hour=DateTime.now().hour;
    int minute=DateTime.now().minute;
    await File(filePath).exists().then((bool val) {
      if (!val) {
        developer.log('path doesnt exist');
      } else if(cout|| hour==0&&minute==0){
        developer.log('path does exist');
        setWallpaper(filePath);
        developer.log(DateTime.now().toString());
      }
      else {
        developer.log('C');
      }
    });
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
      children: [
        const SpinKitWave(
          color: Colors.green,
          size: 50.0,
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
          spinkitText,
          style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold, color: Colors.blue),
        )
      ],
    ),
  );
}
