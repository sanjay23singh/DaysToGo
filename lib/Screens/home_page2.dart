import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:wallpaper/Functions/universal_functions.dart';
import 'package:wallpaper/Screens/clock_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool rotate = false;
  int _currentDay = 1;
  int _totalDays = 100;
  int _remainingDays = 0;

  void showHomePageSnackBar(String text) {
    var snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  updateDates() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('currentDay')) {
      setState(() {
        _currentDay = prefs.getInt('currentDay')!.toInt();
        _totalDays = prefs.getInt('totalDays')!.toInt();
        _remainingDays = prefs.getInt('remainingDays')!.toInt();
      });
    }
  }

  @override
  void initState() {
    updateDates();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ClockPage()),
                  );
                },
                icon: const Icon(Icons.add))
          ],
        ),
        body: _body());
  }

  Widget _body() {
    return Stack(
      children: [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Day $_currentDay/$_totalDays',
                style:
                    const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              CircularStepProgressIndicator(
                totalSteps: _totalDays,
                currentStep: _currentDay,
                stepSize: 10,
                selectedColor: Colors.greenAccent,
                unselectedColor: Colors.grey[200],
                padding: 0,
                width: 200,
                height: 200,
                // selectedStepSize: 15,
                roundedCap: (_, __) => true,

                child: const Icon(
                  Icons.auto_graph_sharp,
                  color: Colors.purple,
                  size: 84,
                ),
              ),
              Column(
                children: [
                  const Text(
                    'ONLY',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _remainingDays.toString(),
                    style: const TextStyle(
                        fontSize: 90, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Days Remaining',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (rotate) getSpinkit('Setting Wallpapers')
      ],
    );
  }
}
