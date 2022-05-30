import 'dart:io';
import 'dart:developer' as developer;
import 'dart:typed_data';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:screenshot/screenshot.dart';
import 'package:toast/toast.dart';
import 'package:wallpaper/Functions/screenshot_functions.dart';
import 'package:wallpaper/Functions/universal_functions.dart';
import 'package:wallpaper/universal_variables.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _textEditingController = TextEditingController();
  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  void initState(){
    getPermissions().then((value) {
      setState(() {});
    });
      
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [
        SystemUiOverlay.top, // Shows Status bar and hides Navigation bar
      ],
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.fromLTRB(20, 100, 20, 100),
        child: Column(
          children: [
            const Text(
              "Enter Number of Days",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 100,
              child: TextFormField(
                controller: _textEditingController,
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 20),
                maxLines: 1,
              ),
            ),
            Expanded(
              child: Container(),
            ),
            ElevatedButton(
              onPressed: () {
                _getScreenshot();
              },
              child: const Text("Create Wallpaper"),
            ),
            ElevatedButton(
              onPressed: () async {
                developer.log('A');
               developer.log(DateTime.now().toString());
                const int helloAlarmID = 234234;
                await AndroidAlarmManager.periodic(
                  const Duration(seconds: 1),
                  helloAlarmID,
                 callback,
                  exact: true,
                  allowWhileIdle: true,
                );
              },
              child: const Text("Set Wallpaper"),
            ),
          ],
        ),
      ),
    );
  }



  Future<void> _getScreenshot() async {
    if (appDocDir.existsSync()) {
      appDocDir.deleteSync(recursive: true);
    }
    int n = int.parse(_textEditingController.text);
    for (int i = 1; i <= n; i++) {
      _screenshotController
          .captureFromWidget(screenshotImage(i, n))
          .then((Uint8List image) {
        //Capture Done
        setState(() async {
          await File('$appDocPath/wallpaper$i.png')
              .create(recursive: true)
              .then((file) {
            file.writeAsBytesSync(image);
            developer.log(file.path);
          });
        });
      }).catchError((onError) {
        // print(onError);
      });
    }
  }
}
