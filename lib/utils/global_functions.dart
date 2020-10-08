import 'package:Sabq/animations/scale-transation-route.dart';
import 'package:Sabq/blocs/general_bloc.dart';
import 'package:Sabq/blocs/user_bloc.dart';
import 'package:Sabq/models/user.dart';
import 'package:Sabq/screens/intro/intro.dart';
import 'package:Sabq/services/api.dart';
import 'package:Sabq/utils/shared_preference.dart';
import 'package:Sabq/widgets/general.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:intl/intl.dart';

class GlobalFunctions {
  static getUserData(context) async {
    UserBloc userBloc = Provider.of<UserBloc>(context, listen: false);
    User userData = await SharedPreferenceHandler.getuserData();
    try {
      bool isLogin = userData != null ? true : false;
      if (isLogin) {
        try {
          User user = await Api().getUserData();
          print("my user is : $user");
          userBloc.setUser(currentUser: user);
        } catch (e) {
          print("user error is :$e");
        }
      } else {
        print("user not login");
      }
    } catch (e) {
      print("user err : $e");
    }
  }

  static formatDate(String date) {
    DateTime myDate = DateTime.parse(date);
    return new DateFormat('yyyy/MM/dd').format(myDate);
  }

  static CustomFooter smartRefresherFooter({@required String endResultMsg}) {
    return CustomFooter(builder: (BuildContext context, LoadStatus mode) {
      Widget body;
      if (mode == LoadStatus.idle) {
        body = Padding(
          padding: EdgeInsets.all(10.0),
          child: General.ringSpinner(context, size: 30.0),
        );
      } else if (mode == LoadStatus.loading) {
        body = Padding(
          padding: EdgeInsets.all(10.0),
          child: General.ringSpinner(context, size: 30.0),
        );
      } else if (mode == LoadStatus.failed) {
        body = Text("Load Failed!Click retry!");
      } else if (mode == LoadStatus.canLoading) {
        body = Text("release to load more");
      } else {
        body = Padding(
          padding: EdgeInsets.all(15.0),
          child: General.buildTxt(txt: endResultMsg),
        );
      }
      return Container(
        child: Center(child: body),
      );
    });
  }

  static logout({@required BuildContext context}) async {
    GenenralBloc genenralBloc =
        Provider.of<GenenralBloc>(context, listen: false);
    UserBloc userBloc = Provider.of<UserBloc>(context);
    genenralBloc.setisLoginButtonPressed(status: true);
    await SharedPreferenceHandler.removeUserData();
    userBloc.setUser(currentUser: null);
    genenralBloc.setIsCreateNewAccountButtonPressed(status: false);
    Navigator.pushAndRemoveUntil(
        context,
        ScaleTransationRoute(page: IntroScreen()),
        (Route<dynamic> route) => false);
  }
}
