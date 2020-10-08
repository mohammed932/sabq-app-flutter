import 'package:Sabq/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPreferenceHandler {
  static setUserData(User user) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("userData", json.encode(user));
    } catch (e) {
      print("set user sharedPreference error :${e.toString()}");
    }
  }

  static getuserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getString('userData') != null) {
        Map<String, dynamic> data = json.decode(prefs.getString('userData'));
        User user = User.fromJson(data);
        return user;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  static setLang(String lang) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("lang", lang);
    } catch (e) {
      print(e.toString());
    }
  }

  static getLang() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString('lang') ?? 'en';
    } catch (e) {
      print("get lang err :$e");
    }
  }

  static removeUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("userData");
  }

  static getAccessToken() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getString('userData') != null) {
        Map<String, dynamic> data = json.decode(prefs.getString('userData'));
        User userData = User.fromJson(data);
        return userData.accessToken;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
