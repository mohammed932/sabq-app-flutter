import 'package:Sabq/animations/scale-transation-route.dart';
import 'package:Sabq/screens/tabs/tabs.dart';
import 'package:Sabq/utils/languages/translations_delegate_base.dart';
import 'package:Sabq/widgets/general.dart';
import 'package:flutter/material.dart';

class MessageSentSuccessfullyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Image.asset(
                    "assets/imgs/message-success.png",
                    // width: 300.0,
                  ),
                ),
                General.sizeBoxVerical(30.0),
                General.buildTxt(
                    txt: TranslationBase.of(context)
                        .getStringLocaledByKey('MSG_SENT_SUCCESSFULLY'),
                    fontSize: 18.0,
                    color: Theme.of(context).primaryColor,
                    isBold: true),
                General.sizeBoxVerical(15.0),
                General.buildTxt(
                    txt: TranslationBase.of(context)
                        .getStringLocaledByKey('WILL_CONTACT_U_SOON'),
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
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        ScaleTransationRoute(
                            page: TabsScreen(
                          tabIndex: 2,
                        )),
                        (Route<dynamic> route) => false);
                  }))
        ],
      ),
    );
  }
}
