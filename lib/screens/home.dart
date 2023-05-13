import 'package:d_chart/d_chart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mental_2_day/main.dart';
import 'package:mental_2_day/screens/widgets/coolText.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/redis.dart';

import 'dart:convert';

List<Map<String, int>> parseEmotions(String jsonString) {
  final Map<String, dynamic> map = json.decode(jsonString);
  final List<Map<String, int>> emotions = [];

  map.forEach((key, value) {
    Map<String, int> emotom = {key: value};
    emotions.add(emotom);
  });

  return emotions;
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool done = false;
  Map<String, dynamic> Health = {};
    Map<String, dynamic> cool = {};


  @override
  void initState() {
    initCount();
    super.initState();
  }

  initCount() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? key = prefs.getString('discord');
    String unparesed = await Redis.readOneKey(key!);
    Health =  json.decode(unparesed);
     unparesed = await Redis.readOneKey(key!);
    cool =  json.decode(unparesed);
    setState(() {
      done = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!done) {
      return CircularProgressIndicator();
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.logout),
          color: Colors.black,
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
          },
        ),
        title: const Text(
          "Current Data",
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.blueGrey,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
               DataDisplayWidget(
                title:  "Rate", 
                value: cool["rate"].round().toString(),
              ),
              SizedBox(
                height: 30,
              ),
                DataDisplayWidget(
                title:  "Contacted Doctor", 
                value: cool["ill"].toString(),
              ),
  
              SizedBox(
                height: 30,
              ),
              coolText(text: "Emotions", fontSize: 20),
              SizedBox(
                  height: 250,
                  child: DChartPie(
                    data: const [
                      {"domain": "Anger", "measure": 7},
                      {"domain": "Confuse", "measure": 3},
                      {"domain": "Joy", "measure": 18},
                      {"domain": "Sadness", "measure": 6},
                      {"domain": "Neutral", "measure": 3}
                    ],
                    labelPosition: PieLabelPosition.auto,
                    labelColor: Colors.white,
                    pieLabel: (pieData, index) {
                      return " ${pieData["domain"]} - ${pieData['measure']}%";
                    },
                    fillColor: (pieData, index) {
                      return Colors.blueGrey;
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class DataDisplayWidget extends StatelessWidget {
  final String title;
  final String value;

  const DataDisplayWidget({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.blueGrey,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
