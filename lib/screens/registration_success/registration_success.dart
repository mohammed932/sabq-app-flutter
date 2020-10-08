import 'dart:async';
import 'package:Sabq/animations/scale-transation-route.dart';
import 'package:Sabq/blocs/general_bloc.dart';
import 'package:Sabq/components/stack-logo-header.dart';
import 'package:Sabq/screens/intro/intro.dart';
import 'package:Sabq/utils/languages/translations_delegate_base.dart';
import 'package:Sabq/widgets/general.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegistationSuccessScreen extends StatefulWidget {
  @override
  _RegistationSuccessScreenState createState() =>
      _RegistationSuccessScreenState();
}

class _RegistationSuccessScreenState extends State<RegistationSuccessScreen> {
  double _curentOpacity = 0;
  _back() {
    // Navigator.pop(context);
    GenenralBloc genenralBloc =
        Provider.of<GenenralBloc>(context, listen: false);
    genenralBloc.setisLoginButtonPressed(status: true);
    genenralBloc.setIsCreateNewAccountButtonPressed(status: false);
    Navigator.pushAndRemoveUntil(
        context,
        ScaleTransationRoute(page: IntroScreen()),
        (Route<dynamic> route) => false);
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    await Future.delayed(Duration(milliseconds: 200));
    setState(() => _curentOpacity = 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(General.getColorHexFromStr('#FAFAFA')),
      body: Container(
        child: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            StackLogoHeader(
              onPress: _back,
            ),
            Wrap(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 210.0),
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50.0),
                          topRight: Radius.circular(50.0),
                          bottomLeft: Radius.circular(50.0),
                          bottomRight: Radius.circular(50.0))),
                  child: AnimatedOpacity(
                    duration: Duration(seconds: 1),
                    opacity: _curentOpacity,
                    curve: Curves.linear,
                    child: Container(
                      padding: EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          General.sizeBoxVerical(15.0),
                          General.buildTxt(
                              txt: TranslationBase.of(context)
                                  .getStringLocaledByKey('INFO_ENTERED'),
                              fontSize: 22.0,
                              isBold: true,
                              color: Theme.of(context).primaryColor),
                          General.sizeBoxVerical(50.0),
                          Image.asset(
                            "assets/imgs/success.png",
                            width: 100.0,
                            height: 100.0,
                          ),
                          General.sizeBoxVerical(35.0),
                          General.buildTxt(
                            txt: TranslationBase.of(context).getStringLocaledByKey(
                                'INFO_HAS_BEEN_ENTERED_SUCCESSFULLY_WAITING_FORM_MANAGMENT_ACCEPTANCE'),
                            fontSize: 18.0,
                            lineHeight: 1.8,
                            color: Colors.black45,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
