import 'package:Sabq/utils/constants.dart';
import 'package:Sabq/utils/languages/translations_delegate_base.dart';
import 'package:flutter/material.dart';

class EmailField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode node;
  final FocusNode nextFocusNode;
  EmailField({
    this.controller,
    this.node,
    this.nextFocusNode,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        controller: controller,
        keyboardAppearance: Brightness.light,
        focusNode: node,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        validator: (val) => validateEmail(val, context),
        onFieldSubmitted: (val) {
          FocusScope.of(context).requestFocus(nextFocusNode);
        },
        decoration: Constants.textFieldDecoration.copyWith(
            prefixIcon: Padding(
              padding: EdgeInsets.all(15.0),
              child: Image.asset(
                "assets/imgs/email.png",
                width: 5.0,
                height: 5.0,
              ),
            ),
            contentPadding: EdgeInsets.all(0.0),
            labelText:
                "${TranslationBase.of(context).getStringLocaledByKey('EMAIL')} \*",
            labelStyle: TextStyle(fontSize: 14.0)),
      ),
    );
  }

  String validateEmail(String value, BuildContext context) {
    String emailValue = value.replaceAll(new RegExp(r"\s+"), "");
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (emailValue.isEmpty)
      return TranslationBase.of(context)
          .getStringLocaledByKey('EMAIL_REQUIRED');
    else if (!regex.hasMatch(emailValue))
      return TranslationBase.of(context)
          .getStringLocaledByKey('ENTER_VALID_EMAIL');
    else
      return null;
  }
}
