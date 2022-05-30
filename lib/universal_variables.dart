import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';


late Directory appDocDir;
late String appDocPath;
const String dayBoxName = 'currDay';
String spinkitText="";
SharedPreferences? prefs;
