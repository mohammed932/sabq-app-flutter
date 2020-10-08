import 'package:Sabq/animations/scale-transation-route.dart';
import 'package:Sabq/screens/judge/judge-tabs/judge-tabs.dart';
import 'package:Sabq/utils/languages/translations_delegate_base.dart';
import 'package:Sabq/widgets/general.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EvaluationDone extends StatelessWidget {
  _dismiss(BuildContext context) {
    Navigator.pushAndRemoveUntil(
        context,
        ScaleTransationRoute(page: JudgeTabsScreen()),
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
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Image.asset(
                      "assets/imgs/evaluation-done.png",
                      width: 270.0,
                      height: 270.0,
                    ),
                  ),
                  General.buildTxt(
                      txt: TranslationBase.of(context).getStringLocaledByKey(
                          'REVIEW_HAVE_BEEN_SENT_SUCCESSFULLY'),
                      fontSize: 18.0,
                      color: Theme.of(context).primaryColor,
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
