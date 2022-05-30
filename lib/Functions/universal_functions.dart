import 'dart:io';
import 'dart:developer' as developer;
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:wallpaper/Functions/screenshot_functions.dart';
import 'package:wallpaper/universal_variables.dart';

Future<void> getPermissions() async {
  await AndroidAlarmManager.initialize();
  var status = await Permission.manageExternalStorage.status;
  if (status.isDenied) {
    await Permission.manageExternalStorage.request();
  }
}

void showToast(String text)
{
  Toast.show(text, duration: Toast.lengthShort, gravity:  Toast.bottom);
}

   Future<void> callback() async {
    developer.log('B');
    await getApplicationDocumentsDirectory().then((directory) async {
      developer.log('C');
      final prefs = await SharedPreferences.getInstance();
      developer.log('D');
      int hour = DateTime.now().hour;

      int dayNo = 1;
      if (!prefs.containsKey('day')) {
        prefs.setInt('day', 1);
      } else {
        dayNo = prefs.getInt('day')!.toInt() + 1;

        prefs.setInt('day', dayNo);
      }
      developer.log('E');
      String dirPath = '${directory.path}/wallpapers';
      String filePath = '$dirPath/wallpaper$dayNo.png';

      developer.log('F');
      await File(filePath).exists().then((bool val) {
        if (!val) {
          developer.log('path doesnt exist');
          showToast('path doesnt exist');
        } else {
          developer.log('path does exist');
          setWallpaper(filePath);
         developer.log(DateTime.now().toString());
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
