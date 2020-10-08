import 'package:Sabq/utils/constants.dart';
import 'package:flutter/material.dart';

class NameField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode node;
  final String textLabel, icon, validation, action;
  final bool showAstrek;
  final FocusNode nextFocusNode;
  final num lines;

  NameField(
      {@required this.controller,
      @required this.node,
      this.nextFocusNode,
      this.lines,
      this.action = "done",
      this.validation,
      this.icon = "assets/imgs/avatar.png",
      this.showAstrek = true,
      @required this.textLabel});
  showAppropriateInputAction() {
    switch (action) {
      case "done":
        return TextInputAction.done;
        break;
      case "next":
        return TextInputAction.next;
        break;
      case "newline":
        return TextInputAction.newline;
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        controller: controller,
        focusNode: node,
        keyboardAppearance: Brightness.light,
        textInputAction: showAppropriateInputAction(),
        validator: validation != null
            ? (String val) {
                if (val.isEmpty) {
                  return validation;
                } else {
                  return null;
                }
              }
            : null,
        onFieldSubmitted: (val) {
          FocusScope.of(context).requestFocus(nextFocusNode);
        },
        maxLines: lines ?? null,
        keyboardType: TextInputType.multiline,
        decoration: Constants.textFieldDecoration.copyWith(
            prefixIcon: icon != null
                ? Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Image.asset(
                      icon,
                      width: 5.0,
                      height: 5.0,
                    ),
                  )
                : null,
            contentPadding: EdgeInsets.all(0.0),
            labelText: controller.text.isEmpty
                ? showAstrek ? '$textLabel \*' : textLabel
                : textLabel,
            labelStyle: TextStyle(fontSize: 14.0)),
      ),
    );
  }
}
