import 'dart:convert';

import 'package:Sabq/blocs/authentication_bloc.dart';
import 'package:Sabq/blocs/competition_bloc.dart';
import 'package:Sabq/blocs/competition_details_bloc.dart';
import 'package:Sabq/blocs/evaluation_bloc.dart';
import 'package:Sabq/blocs/general_bloc.dart';
import 'package:Sabq/blocs/user_bloc.dart';
import 'package:Sabq/screens/intro/intro.dart';
import 'package:Sabq/screens/judge/judge-tabs/judge-tabs.dart';
import 'package:Sabq/screens/tabs/tabs.dart';
import 'package:Sabq/utils/global_functions.dart';
import 'package:Sabq/utils/shared_preference.dart';
import 'package:Sabq/widgets/general.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'blocs/localization_bloc.dart';
import 'utils/languages/translations_delegate_base.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Map<String, dynamic> userData = prefs.getString('userData') != null
      ? json.decode(prefs.getString('userData'))
      : null;
  Widget _defaultHome = IntroScreen();
  if (userData == null) {
    _defaultHome = IntroScreen();
  } else {
    if (userData['data']['type'] == 'JUDGE') {
      _defaultHome = JudgeTabsScreen();
    } else {
      _defaultHome = TabsScreen();
    }
  }
  runApp(app(_defaultHome));
}

Widget app(Widget startScreen) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<GenenralBloc>.value(
        value: GenenralBloc(),
      ),
      ChangeNotifierProvider<AuthenticationBloc>.value(
        value: AuthenticationBloc(),
      ),
      ChangeNotifierProvider<CompetitionBloc>.value(
        value: CompetitionBloc(),
      ),
      ChangeNotifierProvider<UserBloc>.value(
        value: UserBloc(),
      ),
      ChangeNotifierProvider<EvaluationBloc>.value(
        value: EvaluationBloc(),
      ),
      ChangeNotifierProvider<CompetitionDetailsBloc>.value(
        value: CompetitionDetailsBloc(),
      ),
      ChangeNotifierProvider<LocalizationBloc>.value(
        value: LocalizationBloc(),
      ),
    ],
    child: MyApp(
      defaultHome: startScreen,
    ),
  );
}

class MyApp extends StatefulWidget {
  final Widget defaultHome;
  MyApp({this.defaultHome});
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    getUserData();
    checkAppLang();
  }

  checkAppLang() async {
    LocalizationBloc localizationBloc = Provider.of<LocalizationBloc>(context);
    if (localizationBloc.appLocal.languageCode == 'ar') {
      await SharedPreferenceHandler.setLang('ar');
    } else {
      await SharedPreferenceHandler.setLang('en');
    }
  }

  getUserData() async {
    await Future.delayed(Duration(milliseconds: 100));
    await GlobalFunctions.getUserData(context);
  }

  @override
  Widget build(BuildContext context) {
    final LocalizationBloc localizationBloc =
        Provider.of<LocalizationBloc>(context);
    return MaterialApp(
      theme: ThemeData(
          fontFamily: 'droid',
          primaryColor: Color(General.getColorHexFromStr('#8E69A9')),
          accentColor: Color(General.getColorHexFromStr('#a789bd')),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
              brightness: Brightness.light,
              iconTheme: IconThemeData(
                color: Colors.black,
              )),
          brightness: Brightness.light),
      debugShowCheckedModeBanner: false,
      locale: localizationBloc.appLocal,
      localizationsDelegates: [
        const TranslationBaseDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: [
        const Locale('ar', ''), // Arabic
        const Locale('en', ''), // English
      ],
      home: widget.defaultHome,
    );
  }
}
