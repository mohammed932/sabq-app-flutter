import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final Function onPress;
  final Widget buttonTitle;
  final num roundVal;
  final Color color;
  final Color borderColor;
  final Color disableColor;
  final num verticalPadding, horizontialPadding;
  RoundButton(
      {@required this.onPress,
      @required this.buttonTitle,
      this.borderColor = Colors.transparent,
      this.disableColor,
      this.roundVal = 10.0,
      this.verticalPadding = 15.0,
      this.horizontialPadding = 15.0,
      this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: RaisedButton(
        padding: EdgeInsets.symmetric(
            vertical: verticalPadding, horizontal: horizontialPadding),
        disabledColor:
            disableColor == null ? Theme.of(context).accentColor : disableColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(roundVal),
            side: BorderSide(color: borderColor)),
        color: color != null ? color : Theme.of(context).primaryColor,
        elevation: 0.0,
        onPressed: onPress,
        child: buttonTitle,
      ),
    );
  }
}
