import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallpaper/Screens/temp.dart';
import 'package:wallpaper/universal_variables.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  appDocDir = await getApplicationDocumentsDirectory();

  Directory('${appDocDir.path}/wallpapers')
      .create(recursive: true)
      .then((Directory directory) {
    appDocDir = directory;
    appDocPath = directory.path;
  });

  prefs = await SharedPreferences.getInstance();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TempPage(),
    );
  }
}
