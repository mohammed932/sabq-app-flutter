import 'package:Sabq/animations/scale-transation-route.dart';
import 'package:Sabq/screens/tabs/tabs.dart';
import 'package:Sabq/utils/constants.dart';
import 'package:Sabq/utils/languages/translations_delegate_base.dart';
import 'package:Sabq/widgets/general.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SupscriptionDone extends StatelessWidget {
  _dismiss(BuildContext context) {
    Navigator.pushAndRemoveUntil(
        context,
        ScaleTransationRoute(
            page: TabsScreen(
          tabIndex: 0,
        )),
        (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Image.asset("assets/imgs/competitor.png"),
                  ),
                  General.sizeBoxVerical(30.0),
                  General.buildTxt(
                      txt: TranslationBase.of(context).getStringLocaledByKey(
                          'U_HAVE_SUCCESSFULLY_PARTICIPATED_IN_COMPETITION'),
                      fontSize: 18.0,
                      color: Constants.OrangeColor,
                      isBold: true)
                ],
              ),
            ),
            Positioned(
                right: 20.0,
                top: 50.0,
                child: IconButton(
                    icon: Icon(
                      Icons.close,
                      size: 30.0,
                    ),
                    onPressed: () => _dismiss(context)))
          ],
        ),
      ),
    );
  }
}
