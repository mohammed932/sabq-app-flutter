import 'dart:convert';

import 'package:Sabq/blocs/authentication_bloc.dart';
import 'package:Sabq/blocs/general_bloc.dart';
import 'package:Sabq/blocs/localization_bloc.dart';
import 'package:Sabq/blocs/user_bloc.dart';
import 'package:Sabq/models/country.dart';
import 'package:Sabq/widgets/general.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:search_choices/search_choices.dart';

class SelectCountry extends StatefulWidget {
  @override
  _SelectCountryState createState() => _SelectCountryState();
}

class _SelectCountryState extends State<SelectCountry> {
  String selectedCountry;
  GenenralBloc genenralBloc;
  selectCountry(String val) {
    Country myCountry =
        genenralBloc.countries.firstWhere((country) => country.name == val);
    AuthenticationBloc authBloc =
        Provider.of<AuthenticationBloc>(context, listen: false);
    UserBloc userBloc = Provider.of<UserBloc>(context);
    if (userBloc.user != null && userBloc.user.userInfo.firstName != null) {
      userBloc.user.userInfo.country.id = myCountry.id;
    } else {
      authBloc.createAccount.country = myCountry.id;
    }
    print("json data is :${jsonEncode(authBloc.createAccount)}");
    setState(() => selectedCountry = val);
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    await Future.delayed(Duration(milliseconds: 100));
    genenralBloc = Provider.of<GenenralBloc>(context, listen: false);
    UserBloc userBloc = Provider.of<UserBloc>(context, listen: false);
    AuthenticationBloc authBloc =
        Provider.of<AuthenticationBloc>(context, listen: false);
    if (authBloc.createAccount != null &&
        authBloc.createAccount.country != null) {
      Country country = genenralBloc.countries.firstWhere(
          (country) => country.id == authBloc.createAccount.country);
      selectedCountry = country.name;
      print("qqqq");
      setState(() {});
    } else if (userBloc.user.userInfo.country != null) {
      selectedCountry = userBloc.user.userInfo.country.name;

      print("ffff");
      setState(() {});
    }
    genenralBloc.getCountries();
  }

  @override
  Widget build(BuildContext context) {
    LocalizationBloc localizationBloc = Provider.of<LocalizationBloc>(context);
    return Consumer<GenenralBloc>(builder: (BuildContext context, state, __) {
      if (!state.waiting) {
        return Stack(
          children: <Widget>[
            SearchChoices.single(
              items: state.countries.map((country) {
                return DropdownMenuItem(
                  child: General.buildTxt(txt: country.name),
                  value: country.name,
                );
              }).toList(),
              value: selectedCountry,
              hint: "الدولة",
              closeButton: "اغلاق",
              searchHint: "ابحث عن الدولة",
              rightToLeft: true,
              style: TextStyle(fontSize: 16.0, fontFamily: 'droid'),
              onChanged: (value) => selectCountry(value),
              icon: Container(
                // padding: localizationBloc.appLocal.languageCode == "ar"
                //     ? EdgeInsets.only(left: 10.0)
                //     : EdgeInsets.only(right: 10.0),
                child: Container(
                  width: 0.0,
                  height: 0.0,
                ),
              ),
              isExpanded: true,
              underline: Container(
                padding: EdgeInsets.all(20.0),
                height: 1.0,
                color: Theme.of(context).primaryColor,
              ),
              displayClearIcon: false,
            ),
            Positioned(
                left:
                    localizationBloc.appLocal.languageCode == "ar" ? 0.0 : null,
                right:
                    localizationBloc.appLocal.languageCode == "ar" ? null : 0.0,
                top: selectedCountry != null ? 20.0 : 12.0,
                child: Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.black54,
                ))
          ],
        );
      } else {
        return Container();
      }
    });
  }
}
