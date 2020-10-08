import 'package:Sabq/utils/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:devicelocale/devicelocale.dart';

class LocalizationBloc extends ChangeNotifier {
  Locale _appLocale;
  Locale get appLocal => _appLocale ?? Locale("ar");

  LocalizationBloc() {
    setBaseLocale();
  }

  void setBaseLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String savedLocal = prefs.getString('lang');
    print('savedLocal is :$savedLocal');
    if (savedLocal != null) {
      print("Saved locale");
      print(savedLocal);
      _appLocale = Locale(savedLocal);
    } else {
      print("Failed to get saved local, default is device local");
      String locale = await Devicelocale.currentLocale;
      if (locale.contains("-")) {
        locale = locale.substring(0, locale.indexOf("-"));
      }
      if (locale.contains("_")) {
        locale = locale.substring(0, locale.indexOf("_"));
      }
      print(locale);
      _appLocale = Locale(locale);
      print('_appLocale is :$_appLocale');
      notifyListeners();
    }
  }

  void changeDirection() async {
    if (_appLocale == Locale("ar")) {
      await SharedPreferenceHandler.setLang('en');
      _appLocale = Locale("en");
    } else {
      await SharedPreferenceHandler.setLang('ar');
      _appLocale = Locale("ar");
    }
    notifyListeners();
  }
}
