import 'dart:io';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';

Future<void> setWallpaper(String filePath) async {
  try {
    int location = WallpaperManager.LOCK_SCREEN;
    var file = File(filePath);

    await WallpaperManager.setWallpaperFromFile(file.path, location)
        .then((bool result) async {
      if (result) {

        developer.log('Wallpaper changed successfully');
      } else {
        developer.log('Some issue occured');
      }
    });
  } on PlatformException {}
}

Widget screenshotImage(int num, int total) {
  return Container(
    padding: const EdgeInsets.fromLTRB(20, 150, 20, 100),
    alignment: Alignment.bottomCenter,
    color: Colors.black,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset('assets/images/itachi.png'),
        FittedBox(
          child: Text(
            'Day $num/$total',
            style: const TextStyle(color: Colors.white, fontSize: 50),
          ),
        ),
      ],
    ),
  );
}
