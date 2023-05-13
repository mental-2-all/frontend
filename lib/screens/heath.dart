import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:mental_2_day/services/redis.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'widgets/coolText.dart';

class Heath extends StatefulWidget {
  const Heath({super.key});

  @override
  State<Heath> createState() => _Heath();
}

class _Heath extends State<Heath> {
  @override
  void initState() {
    sendHealthData();
    super.initState();
  }

  sendHealthData() async {
    // create a HealthFactory for use in the app
    HealthFactory health = HealthFactory();

    // define the types to get
    var types = [
      HealthDataType.SLEEP_IN_BED,
      HealthDataType.EXERCISE_TIME,
      HealthDataType.RESTING_HEART_RATE,
      HealthDataType.HEART_RATE,
    ];

    var now = DateTime.now();
    double avghr = 0;
    double resthr = 0;
    double SLEEP_IN_BED = 0;
    double avgExersie = 0;
    int amount = 0;
    // fetch health data from the last 24 hours
    List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
        now.subtract(const Duration(days: 1)), now, types);
    for (HealthDataPoint element in healthData) {
      if (element.toJson()["data_type"] == "HEART_RATE") {
        avghr = avghr + double.parse(element.toJson()["value"]["numericValue"]);
        amount++;
      } else {
        if (element.toJson()["data_type"] == "SLEEP_IN_BED") {
          SLEEP_IN_BED =
              double.parse(element.toJson()["value"]["numericValue"]);
        } else if (element.toJson()["data_type"] == "RESTING_HEART_RATE") {
          resthr = double.parse(element.toJson()["value"]["numericValue"]);
        } else if (element.toJson()["data_type" == "EXERCISE_TIME"]) {
          avgExersie = double.parse(element.toJson()["value"]["numericValue"]);
        }
      }
    }
    avghr = avghr / amount;
    print(avghr);
    print(resthr);
    print(SLEEP_IN_BED);
    print(avgExersie);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? key = prefs.getString('discord');
    final data = {
      "avghr": avghr,
      "resthr": resthr,
      "sleep": SLEEP_IN_BED,
      "exersie": avgExersie
    }.toString();
    await Redis.send("${key!}healthkit", data);
     var snackBar = SnackBar(
      content: coolText(text: 'Synced With HealthKit', fontSize: 12,),
    );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HealthKit'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'What is HealthKit?',
                style: Theme.of(context).textTheme.headline5!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: 16.0),
              Text(
                'HealthKit is a framework developed by Apple for iOS devices that allows developers to integrate health and fitness data into their apps. HealthKit provides a centralized repository for storing health data from various sources, such as third-party fitness trackers and medical devices.',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              SizedBox(height: 24.0),
              Text(
                'What kind of data can HealthKit track?',
                style: Theme.of(context).textTheme.headline5!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: 16.0),
              Text(
                'HealthKit can track a wide range of health and fitness data, including:',
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: 8.0),
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HealthDataItem(
                      icon: Icons.directions_walk,
                      label: 'Steps taken',
                    ),
                    HealthDataItem(
                      icon: Icons.directions_run,
                      label: 'Distance traveled',
                    ),
                    HealthDataItem(
                      icon: Icons.local_fire_department,
                      label: 'Calories burned',
                    ),
                    HealthDataItem(
                      icon: Icons.favorite,
                      label: 'Heart rate',
                    ),
                    HealthDataItem(
                      icon: Icons.stacked_line_chart,
                      label: 'Blood pressure',
                    ),
                    HealthDataItem(
                      icon: Icons.nights_stay,
                      label: 'Sleep',
                    ),
                    HealthDataItem(
                      icon: Icons.fastfood,
                      label: 'Nutrition',
                    ),
                    HealthDataItem(
                      icon: Icons.medical_services,
                      label: 'Medical records',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HealthDataItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const HealthDataItem({Key? key, required this.icon, required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.blueGrey,
        ),
        SizedBox(width: 8.0),
        Text(
          label,
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ],
    );
  }
}

class ScaffoldWithMessage extends StatelessWidget {
  final String message;
  final Widget body;

  const ScaffoldWithMessage(
      {Key? key, required this.message, required this.body})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            message,
            style: TextStyle(fontSize: 20.0),
          ),
          SizedBox(height: 20.0),
          body,
        ],
      ),
    );
  }
}
