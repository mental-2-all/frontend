import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mental_2_day/screens/login/loginChecker.dart';
import 'package:redis/redis.dart';

Command? redisClient;
Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'mental_2_day',
      theme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: Colors.blueGrey,
          onPrimary: Colors.blueGrey,
          secondary: Colors.white,
          onSecondary: Colors.white,
          error: Colors.black,
          onError: Colors.red,
          background: Colors.black,
          onBackground: Colors.black,
          surface: Colors.blueGrey,
          onSurface: Colors.black,
        ),
        textTheme: const TextTheme(bodyText2: TextStyle(color: Colors.white70)),
      ),
      home: const SplashScreen(),
    );
  }
}
