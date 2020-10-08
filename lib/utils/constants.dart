import 'package:Sabq/widgets/general.dart';
import 'package:flutter/material.dart';

class Constants {
  static const String baseUrl = "http://staging.api.sabq.win/api/";
  static const Color OrangeColor = Color(0XFFD2BA7C);
  static var textFieldDecoration = InputDecoration(
    labelText: "",
    labelStyle: TextStyle(color: Colors.black54),
    focusedBorder: UnderlineInputBorder(
        borderSide:
            BorderSide(color: Color(General.getColorHexFromStr('#8E69A9')))),
    enabledBorder: UnderlineInputBorder(
        borderSide:
            BorderSide(color: Color(General.getColorHexFromStr('#8E69A9')))),
  );
}
