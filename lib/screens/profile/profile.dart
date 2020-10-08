import 'package:Sabq/animations/scale-transation-route.dart';
import 'package:Sabq/blocs/localization_bloc.dart';
import 'package:Sabq/blocs/user_bloc.dart';
import 'package:Sabq/components/stack-logo-header.dart';
import 'package:Sabq/screens/about_app/about_app.dart';
import 'package:Sabq/screens/bank_info/bank_info.dart';
import 'package:Sabq/screens/contact-us/contact-us.dart';
import 'package:Sabq/screens/judge/evaluation-history/evaluation-history.dart';
import 'package:Sabq/screens/my_profile/my_profile.dart';
import 'package:Sabq/utils/global_functions.dart';
import 'package:Sabq/utils/languages/translations_delegate_base.dart';
import 'package:Sabq/widgets/general.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum pages { My_PROFILE, BANK_INFO, CONTACT_US, RATING_RECORD, ABOUT_APP }

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  _openPage({pageName}) {
    switch (pageName) {
      case pages.My_PROFILE:
        Navigator.push(context, ScaleTransationRoute(page: MyProfileScreen()));
        break;
      case pages.BANK_INFO:
        Navigator.push(context, ScaleTransationRoute(page: BankInfoScreen()));
        break;
      case pages.CONTACT_US:
        Navigator.push(context, ScaleTransationRoute(page: ContactUsScreen()));
        break;
      case pages.RATING_RECORD:
        Navigator.push(
            context, ScaleTransationRoute(page: EvaluationHistoryScreen()));
        break;
      case pages.ABOUT_APP:
        Navigator.push(context, ScaleTransationRoute(page: AboutAppScreen()));
        break;
      default:
    }
  }

  _logout() async {
    GlobalFunctions.logout(context: context);
  }

  _logoutDialouge() {
    General.showMakeSureDialogue(
        context: context,
        txt: TranslationBase.of(context)
            .getStringLocaledByKey('R_U_SURE_LOGOUT'),
        onPress: _logout);
  }

  _changeLang() {
    LocalizationBloc localizationBloc = Provider.of<LocalizationBloc>(context);
    localizationBloc.changeDirection();
    General.showToast(txt: "تم تغيير اللغة");
  }

  @override
  Widget build(BuildContext context) {
    UserBloc userBloc = Provider.of<UserBloc>(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          StackLogoHeader(
            headerHeight: 140.0,
            logoWidth: 70.0,
            logoDistanceFromTop: 55.0,
            isHaveLogoImg: false,
            title:
                TranslationBase.of(context).getStringLocaledByKey('MY_ACCOUNT'),
            isTitleBold: false,
            titleFontSize: 18.0,
            isHaveBackButton: false,
          ),
          Container(
              margin: EdgeInsets.only(top: 90.0),
              decoration: BoxDecoration(
                  color: Color(General.getColorHexFromStr('#FAFAFA')),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50.0),
                    topRight: Radius.circular(50.0),
                  )),
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
                children: ListTile.divideTiles(context: context, tiles: [
                  tileItem(
                      title: TranslationBase.of(context)
                          .getStringLocaledByKey('MY_PROFILE'),
                      icon: 'assets/imgs/user-profile.png',
                      onPress: () => _openPage(pageName: pages.My_PROFILE)),
                  tileItem(
                    title: TranslationBase.of(context)
                        .getStringLocaledByKey('BANK_INFO'),
                    icon: 'assets/imgs/user-profile.png',
                    onPress: () => _openPage(pageName: pages.BANK_INFO),
                  ),
                  userBloc.user != null &&
                          userBloc.user.userInfo.type == "JUDGE"
                      ? tileItem(
                          title: TranslationBase.of(context)
                              .getStringLocaledByKey('REVIEW_HISTORY'),
                          icon: 'assets/imgs/rating-star.png',
                          onPress: () =>
                              _openPage(pageName: pages.RATING_RECORD),
                        )
                      : null,
                  tileItem(
                    title: TranslationBase.of(context)
                        .getStringLocaledByKey('ABOUT_APP'),
                    icon: 'assets/imgs/info.png',
                    onPress: () => _openPage(pageName: pages.ABOUT_APP),
                  ),
                  tileItem(
                      title: TranslationBase.of(context)
                          .getStringLocaledByKey('CONTACT_US'),
                      icon: 'assets/imgs/phone-profile.png',
                      onPress: () => _openPage(pageName: pages.CONTACT_US)),
                  tileItem(
                      title: TranslationBase.of(context)
                          .getStringLocaledByKey('CHANGE_LANGUAGE'),
                      icon: 'assets/imgs/rating-star.png',
                      onPress: _changeLang),
                  tileItem(
                      title: TranslationBase.of(context)
                          .getStringLocaledByKey('LOGOUT'),
                      icon: 'assets/imgs/logout.png',
                      onPress: _logoutDialouge),
                ]).toList(),
              ))
        ],
      ),
    );
  }

  tileItem({String title, String icon, Function onPress}) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 5.0),
      title: Row(
        children: <Widget>[
          Image.asset(
            icon,
            width: 25.0,
          ),
          General.sizeBoxHorizontial(20.0),
          General.buildTxt(
              txt: title,
              isCenter: false,
              fontSize: 14.0,
              color: Colors.black54)
        ],
      ),
      onTap: onPress,
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 15.0,
        color: Colors.black54,
      ),
      dense: true,
    );
  }
}
