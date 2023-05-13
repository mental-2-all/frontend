import 'package:redis/redis.dart';

import '../main.dart';


class Redis {
  List<String> allKeys = [];
  List<String> data = [];

  static Future<void> makeClient() async {
    final values = {
      "where" : "redis-13465.c85.us-east-1-2.ec2.cloud.redislabs.com",
      "port" : 13465,
      "username": "default",
      "pass" : "itw0IthEdpq7UawL2ft3gkvhHOF8Vd0v",
    };
    final conn = RedisConnection();
    await conn
        .connect(values["where"], values["port"])
        .then((Command command) async {
      await command.send_object(["AUTH", values["username"], values["pass"]]);
      redisClient = command;
    });
  }

  static Future<String> readOneKey(String where) async {
    return await redisClient!.send_object([
      "GET",
      where,
    ]);
  }

  Future<dynamic> workingServers() async {
    allKeys = [];
    final List<dynamic> allKeysRedis = await redisClient!.send_object([
      "KEYS",
      "*",
    ]);
    for (int x = 0; x < allKeysRedis.length; x++) {
      dynamic works = await readOneKey(allKeysRedis[x].toString());
      if (!allKeysRedis[x].toString().contains("location")) {
        allKeys.add(allKeysRedis[x].toString());
        data.add(works.toString());
      }
    }
  }

  static Future<String> getCommand(String where) async {
    while (true) {
      String data = await readOneKey(where);
      if (data.contains("**")) {
        return data.replaceAll("**", "");
      } else if (data.contains("%%")) {
        return data.replaceAll("%%", "");
      }
      Future.delayed(const Duration(milliseconds: 4));
    }
  }

  static Future<void> send(String where, String what) async {
    await redisClient!.send_object(["SET", where, what]);
  }

  static Future<String> getPath(String where) async {
    return await readOneKey("${where}location");
  }
  static Future<void> kill(String where) async {
    await Redis.send(where, "&&kill");
  }

  static Future<void> sendCommand(String where, String what) async {
    if (what.contains("cd")) {
      Redis.send(where, "%%$what");
    } else {
      Redis.send(where, "&&$what");
    }
  }
static Future<Map<String, Map<String, double>>> graphData() async {
  
    final List<dynamic> allKeysRedis = await redisClient!.send_object([
      "KEYS",
      "*",
    ]);
    Map<String, Map<String, double>> returnVal = {};
    for (int a = 0; a < allKeysRedis.length; a++) {
      try {
        String element = allKeysRedis[a].toString();
        List<dynamic> data =
        await redisClient!.send_object(
            ["ZRANGE", element.toString(), "0", "-1", "WITHSCORES"]);
        List<String> headers = [];
        List<double> values = [];
        Map<String, double> midData = {};
        returnVal[element] = {};
        for (int x = 0; x < data.length; x++) {
          if (x % 2 == 0) {
            headers.add(data[x].toString());
          } else {
            values.add(double.parse(data[x].toString()));
          }
        }
        for (int x = 0; x < headers.length; x++) {
          midData[headers[x]] = values[x];
        }
        returnVal[element] = midData;
      } catch (e) {
        print(e);
      }
    };
    return returnVal;
    }
    static Future<Map<String, dynamic>?> showRedisData(Command client, dynamic element) async {
    try{
        List<dynamic> data =
        await client.send_object(
            ["ZRANGE", element.toString(), "0", "-1", "WITHSCORES"]);
        List<String> headers = [];
        List<double> values = [];
        Map<String, double> midData = {};
        for (int x = 0; x < data.length; x++) {
          if (x.isEven) {
            headers.add(data[x].toString());
          } else {
            values.add(double.parse(data[x].toString()));
          }
        }
        for (int x = 0; x < headers.length; x++) {
          midData[headers[x]] = values[x];
        }
        return midData;
    }catch(e) {
      print(e);
      return null;
    }
  }
}
class RedisValues {
  Command? conn;
  List<dynamic>? keys;
}