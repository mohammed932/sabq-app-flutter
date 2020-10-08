import 'package:Sabq/blocs/authentication_bloc.dart';
import 'package:Sabq/blocs/localization_bloc.dart';
import 'package:Sabq/blocs/user_bloc.dart';
import 'package:Sabq/mocks/mocks.dart';
import 'package:Sabq/utils/languages/translations_delegate_base.dart';
import 'package:Sabq/widgets/general.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectGender extends StatefulWidget {
  SelectGender();
  @override
  _SelectGenderState createState() => _SelectGenderState();
}

class _SelectGenderState extends State<SelectGender> {
  String selectedGender;
  UserBloc userBloc;
  selectGender(String gender) {
    AuthenticationBloc authenticationBloc =
        Provider.of<AuthenticationBloc>(context, listen: false);
    UserBloc userBloc = Provider.of<UserBloc>(context, listen: false);
    print('gender :$gender');
    if (authenticationBloc.createAccount != null) {
      authenticationBloc.createAccount.gender = int.parse(gender);
    }

    if (userBloc.user != null) {
      print("aaaaqa");
      userBloc.user.userInfo.gender = gender;
      // switch (userBloc.user.userInfo.gender) {
      //   case "1":
      //     userBloc.user.userInfo.gender = 'MALE';
      //     break;
      //   case "2":
      //     userBloc.user.userInfo.gender = 'FEMALE';
      //     break;
      //   default:
      // }
    }
    setState(() => selectedGender = gender);
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    await Future.delayed(Duration(milliseconds: 200));
    userBloc = Provider.of<UserBloc>(context, listen: false);
    print('userBloc.user.userInfo.gender :${userBloc.user.userInfo.gender}');
    switch (userBloc.user.userInfo.gender) {
      case "MALE":
        selectedGender = "1";
        break;
      case "FEMALE":
        selectedGender = "2";
        break;
      default:
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    LocalizationBloc localizationBloc = Provider.of<LocalizationBloc>(context);
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Theme.of(context).primaryColor))),
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 10.0),
            margin: EdgeInsets.only(top: 20.0, left: 0.0, right: 20.0),
            child: DropdownButton(
              hint: General.buildTxt(
                  txt: TranslationBase.of(context)
                      .getStringLocaledByKey('GENDER')),
              underline: Container(
                height: 0,
                color: Colors.transparent,
              ),
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down),
              items: Mocks.genders.map((gender) {
                return DropdownMenuItem<String>(
                  value: gender.id.toString(),
                  child: General.buildTxt(
                      txt: localizationBloc.appLocal.languageCode == "ar"
                          ? gender.textAr
                          : gender.textEn,
                      color: Colors.black,
                      fontSize: 14.0),
                );
              }).toList(),
              value: selectedGender,
              onChanged: (String gender) => selectGender(gender),
            ),
          ),
          Positioned(
            bottom: 15.0,
            right: 10.0,
            child: Container(
              child: Image.asset(
                'assets/imgs/gender.png',
                width: 10.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
