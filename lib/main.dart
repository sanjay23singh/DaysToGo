import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wallpaper/Screens/home_page.dart';
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

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
