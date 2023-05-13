import 'package:flutter/material.dart';
import 'package:health/health.dart';

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
    ];

    // requesting access to the data types before reading them
    bool requested = await health.requestAuthorization(types);

    var now = DateTime.now();

    // fetch health data from the last 24 hours
    List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
        now.subtract(Duration(days: 1)), now, types);
        print(healthData);
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
