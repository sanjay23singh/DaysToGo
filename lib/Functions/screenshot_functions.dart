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
  int _remainingDays= total-num+1;
  return Container(
    padding: const EdgeInsets.fromLTRB(20, 50, 20, 25),
    alignment: Alignment.bottomCenter,
    color: Colors.black,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
         Text(
          'Day $num/$total',
          style: const TextStyle(
              fontSize: 35, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        Expanded(child: Image.asset('assets/images/itachi.png')),
        FittedBox(
          child: Column(
            children:  [
             const Text(
                'ONLY',
                style: TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                _remainingDays.toString(),
                
                style: const TextStyle(
                    fontSize: 90,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              const Text(
                'Days Remaining',
                style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
        
      ],
    ),
  );
}


