import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:notifications/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioRepository {
  static Dio dio = Dio();
  static String url = "http://192.168.43.86:8080";
  Future login(String username, String password) async {
    final Response response =
        await dio.get(url + "/login?username=$username&password=$password");
    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      log(response.data.toString());
      prefs.setString("token", response.data["token"]);
      return response.data;
    }
    return Future.error(response.data);
  }

  Future signUp(String username, String password) async {
    final Response response =
        await dio.get(url + "/signup?username=$username&password=$password");
    if (response.statusCode == 200) {
      final logInResponse = await login(username, password);
      return logInResponse;
    }
    return Future.error(response.data);
  }

  Future getAllChats() async {
    dio.options.headers["token"] = prefs.getString("token");
    List list = [];
    final Response response = await dio.get(url + "/allChats");
    if (response.statusCode == 200) {
      for (var item in response.data) {
        list.add(item);
      }
      return list;
    }
    return Future.error("error");
  }
 
  Future getUserChats() async {
    dio.options.headers["token"] = prefs.getString("token");
    List list = [];
    final Response response = await dio.get(url + "/myChats");
    if (response.statusCode == 200) {
      if (response.data.length != 0) {
        for (var item in response.data[0]["chats"]) {
          list.add(item);
        }
        return list;
      } else {
        return [];
      }
    }
    return Future.error("error");
  }

  Future addChats(String id) async {
    log(prefs.getString("token").toString());
    dio.options.headers["token"] = prefs.getString("token");
    List list = [];
    final Response response = await dio.get(url + "/addChat/$id");
    if (response.statusCode == 200) {
      if (response.data.length != 0) {
        log("Successfully added");
        return;
      } else {
        log("Nope");
        return;
      }
    }
    return Future.error("error");
  }

  Future getMessagesHistory(String id) async {
    dio.options.headers["token"] = prefs.getString("token");
    List list = [];
    final Response response = await dio.get(url + "/chats/$id");
    if (response.statusCode == 200) {
      if (response.data.length != 0) {
        for (var item in response.data) {
          list.add(item);
        }
        log(response.data.toString());
        return list;
      } else {
        return [];
      }
    }
    return Future.error("error");
  }
}
