import 'package:Sabq/components/stack_normal_header.dart';
import 'package:Sabq/utils/languages/translations_delegate_base.dart';
import 'package:Sabq/widgets/general.dart';
import 'package:flutter/material.dart';

class AboutAppScreen extends StatefulWidget {
  @override
  _AboutAppScreenState createState() => _AboutAppScreenState();
}

class _AboutAppScreenState extends State<AboutAppScreen> {
  _back() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(General.getColorHexFromStr('#FAFAFA')),
      body: Stack(
        children: <Widget>[
          StackNormalHeader(
              title: TranslationBase.of(context)
                  .getStringLocaledByKey('ABOUT_APP'),
              onPress: _back),
          Positioned(
              top: 90.0,
              right: 0.0,
              left: 0.0,
              child: Image.asset('assets/imgs/about.png')),
          Container(
            margin: EdgeInsets.only(top: 330.0),
            child: SingleChildScrollView(
              child: Container(
                  padding: EdgeInsets.all(15.0),
                  child: General.buildTxt(
                      isCenter: false,
                      lineHeight: 1.5,
                      txt: TranslationBase.of(context)
                          .getStringLocaledByKey('ABOUT_CONTENT'))),
            ),
          )
        ],
      ),
    );
  }
}
