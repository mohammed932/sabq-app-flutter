import 'package:Sabq/utils/constants.dart';
import 'package:flutter/material.dart';

class PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String textLabel, validation;
  final FocusNode node, nextFocusNode;
  final bool showAstrek;
  PasswordField(
      {@required this.controller,
      @required this.node,
      this.nextFocusNode,
      this.validation,
      this.showAstrek = true,
      @required this.textLabel});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        controller: controller,
        obscureText: true,
        focusNode: node,
        keyboardAppearance: Brightness.light,
        validator: validation != null
            ? (String val) {
                if (val.isEmpty) {
                  return validation;
                } else if (val.length < 8) {
                  return validation;
                } else {
                  return null;
                }
              }
            : null,
        onFieldSubmitted: (val) {
          FocusScope.of(context).requestFocus(nextFocusNode);
        },
        textInputAction:
            nextFocusNode != null ? TextInputAction.next : TextInputAction.done,
        decoration: Constants.textFieldDecoration.copyWith(
            prefixIcon: Padding(
              padding: EdgeInsets.all(15.0),
              child: Image.asset(
                "assets/imgs/lock.png",
                width: 0.0,
                height: 0.0,
              ),
            ),
            contentPadding: EdgeInsets.all(0.0),
            labelText: controller.text.isEmpty
                ? showAstrek ? '$textLabel \*' : textLabel
                : textLabel,
            labelStyle: TextStyle(fontSize: 14.0)),
      ),
    );
  }
}
