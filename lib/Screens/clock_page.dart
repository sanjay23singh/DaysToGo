import 'dart:io';
import 'dart:typed_data';
import 'dart:developer' as developer;
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:wallpaper/Functions/screenshot_functions.dart';
import 'package:wallpaper/Functions/universal_functions.dart';
import 'package:wallpaper/universal_variables.dart';

class ClockPage extends StatefulWidget {
  const ClockPage({super.key});

  @override
  State<ClockPage> createState() => _ClockPageState();
}

class _ClockPageState extends State<ClockPage> {
  bool rotate = false;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  void initState() {
    getPermissions();
    super.initState();
  }

  void showSnackBar(String text) {
    var snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget _buttons() {
    int numOfDays = _endDate.difference(_startDate).inDays;
    return ElevatedButton(
      onPressed: () async {
        if (numOfDays == 0) {
          showSnackBar('Invalid value');
        } else {
          setState(() {
            rotate = true;
          });
          int currentDay = DateTime.now().difference(_startDate).inDays;
          int totalDays = _endDate.difference(_startDate).inDays;
          int remainingDays = _endDate.difference(DateTime.now()).inDays + 1;
          final prefs = await SharedPreferences.getInstance();
          prefs.clear().then((value) {
            if (value) {
              prefs.setInt('totalDays', numOfDays);
              prefs.setInt('currentDay', currentDay);
              prefs.setInt('remainingDays', remainingDays);
              prefs.setInt('prevDay', -1);
              prefs.setBool('wallpaperSet', false);

              _getScreenshot(currentDay, totalDays);
            }
          });
        }
      },
      child: const Text("Create Wallpaper"),
    );
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
        ),
        body: _body());
  }

  Widget _body() {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Column(
            children: [
              getDateTimeColumn(),
              Expanded(child: getNumOfDays(_startDate, _endDate)),
              _buttons(),
            ],
          ),
        ),
        if (rotate) getSpinkit('Creating wallpapers')
      ],
    );
  }

  // get DateTime Column
  Widget getDateTimeColumn() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          alignment: Alignment.bottomLeft,
          child: const Text(
            'Start Date',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          alignment: Alignment.center,
          child: DateTimePicker(
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(8.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              hintText: "Select Start Date",
            ),
            initialValue: '',
            firstDate: DateTime(2000),
            lastDate: DateTime.now(),
            dateLabelText: 'Select Start Date',
            onChanged: (val) {
              DateTime date = DateTime.parse(val);
              setState(() {
                _startDate = date;
              });
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          alignment: Alignment.bottomLeft,
          child: const Text(
            'End Date',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          alignment: Alignment.center,
          child: DateTimePicker(
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(8.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              hintText: "Select End Date",
            ),
            initialValue: '',
            firstDate: DateTime.now(),
            lastDate: DateTime(2100),
            dateLabelText: 'End Date',
            onChanged: (val) {
              DateTime date = DateTime.parse(val);
              setState(() {
                _endDate = date;
              });
            },
          ),
        ),
      ],
    );
  }

  Future<void> _getScreenshot(int currentDay, int totalDays) async {
    if (appDocDir.existsSync()) {
      appDocDir.deleteSync(recursive: true);
    }

    for (int i = currentDay; i <= totalDays; i++) {
      _screenshotController
          .captureFromWidget(screenshotImage(i, totalDays))
          .then((Uint8List image) {
        //Capture Done
        setState(() async {
          await File('$appDocPath/wallpaper$i.png')
              .create(recursive: true)
              .then((file) {
            file.writeAsBytesSync(image);
            developer.log(file.path);
          });

          if (i == (currentDay + 2)) {
            developer.log('Inside');
            const int helloAlarmID = 234234;
            await AndroidAlarmManager.periodic(
              const Duration(milliseconds: 1),
              helloAlarmID,
              callback,
              exact: true,
              allowWhileIdle: true,
            );
          }
          if (i == totalDays) {
            setState(() {
              rotate = false;
              Navigator.of(context).pop();
            });
            showSnackBar('Wallpapers created');
            developer.log('Done');
          }
        });
      }).catchError((onError) {
        // print(onError);
      });
    }
  }
}
