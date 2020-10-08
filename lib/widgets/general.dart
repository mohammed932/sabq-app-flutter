import 'package:Sabq/components/loading_dialogue.dart';
import 'package:Sabq/utils/languages/translations_delegate_base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class General {
  static sizeBoxHorizontial(space) {
    return SizedBox(
      width: space,
    );
  }

  static sizeBoxVerical(space) {
    return SizedBox(
      height: space,
    );
  }

  static showToast({@required txt, Color color}) {
    return Fluttertoast.showToast(
        msg: txt,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: color == null ? Colors.black87 : color,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static ringSpinner(BuildContext context, {num size = 50.0}) {
    return Center(
      child: SpinKitRing(
        color: Theme.of(context).primaryColor,
        lineWidth: 3.0,
        size: size,
      ),
    );
  }

  static Future<void> showMakeSureDialogue(
      {@required String txt,
      @required BuildContext context,
      Function onPress}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                sizeBoxVerical(10.0),
                buildTxt(txt: txt, fontSize: 13.0, lineHeight: 1.3)
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('لا'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('نعم'),
              onPressed: onPress,
            ),
          ],
        );
      },
    );
  }

  static customThreeBounce(BuildContext context,
      {Color color = Colors.white, size = 20.0}) {
    return Center(
      child: SpinKitThreeBounce(
        color: color,
        size: size,
      ),
    );
  }

  static buildTxt(
      {@required String txt,
      Color color = Colors.black,
      double fontSize,
      double lineHeight = 1,
      bool isBold = false,
      bool isOverflow = false,
      bool isUnderLine = false,
      isCenter = true}) {
    return Text(
      txt,
      textAlign: isCenter ? TextAlign.center : null,
      overflow: isOverflow ? TextOverflow.ellipsis : null,
      style: TextStyle(
          color: color,
          height: lineHeight,
          fontFamily: "droid",
          decoration: isUnderLine ? TextDecoration.underline : null,
          fontSize: fontSize,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
    );
  }

  static dismissLoadingDialog(context) {
    if (Navigator.of(context).canPop()) Navigator.pop(context);
  }

  static showLoadingDialog(context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return LoadingDialog();
      },
    );
  }

  static Future<void> showDialogue(
      {@required Widget txtWidget,
      @required BuildContext context,
      String actionLabel = "CANCEL"}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[sizeBoxVerical(10.0), txtWidget],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: General.buildTxt(
                  txt: TranslationBase.of(context)
                      .getStringLocaledByKey(actionLabel)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static int getColorHexFromStr(String colorStr) {
    colorStr = "FF" + colorStr;
    colorStr = colorStr.replaceAll("#", "");
    int val = 0;
    int len = colorStr.length;
    for (int i = 0; i < len; i++) {
      int hexDigit = colorStr.codeUnitAt(i);
      if (hexDigit >= 48 && hexDigit <= 57) {
        val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 65 && hexDigit <= 70) {
        // A..F
        val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 97 && hexDigit <= 102) {
        // a..f
        val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
      } else {
        throw new FormatException("An error occurred when converting a color");
      }
    }
    return val;
  }
}
