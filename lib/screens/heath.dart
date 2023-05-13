import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:mental_2_day/services/redis.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Heath extends StatefulWidget {
  const Heath({super.key});

  @override
  State<Heath> createState() => _Heath();
}
class _Heath extends State<Heath> {


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

    // requesting access to the data types before reading them
    bool requested = await health.requestAuthorization(types);

    var now = DateTime.now();
    double avghr = 0;
    double resthr = 0;
    double SLEEP_IN_BED = 0;
    double avgExersie = 0;
    int amount = 0;
    // fetch health data from the last 24 hours
    List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
        now.subtract(const Duration(days: 1)), now, types);
        for (HealthDataPoint element in healthData){
          if (element.toJson()["data_type"] == "HEART_RATE") {
            avghr = avghr + double.parse(element.toJson()["value"]["numericValue"]);
            amount++;
          }else{
            if (element.toJson()["data_type"] == "SLEEP_IN_BED"){
              SLEEP_IN_BED = double.parse(element.toJson()["value"]["numericValue"]);
            }
            else if (element.toJson()["data_type"] == "RESTING_HEART_RATE"){
              resthr = double.parse(element.toJson()["value"]["numericValue"]);
            }
            else if(element.toJson()["data_type" == "EXERCISE_TIME"]) {
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
      "resthr" : resthr,
      "sleep" : SLEEP_IN_BED,
      "exersie" : avgExersie
    }.toString();
    Redis.send("${key!}healthkit", data);

  }

  @override
  Widget build(BuildContext context) {
    sendHealthData();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Heath App Setup"),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Text("")],
        ),
      ),
    );
  }
}
