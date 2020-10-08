import 'package:Sabq/utils/constants.dart';
import 'package:Sabq/utils/languages/translations_delegate_base.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';

class MobileField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode node;
  final FocusNode nextFocusNode;
  final bool hidePrefixIcon;
  MobileField({
    this.controller,
    this.node,
    this.hidePrefixIcon = false,
    this.nextFocusNode,
  });

  void _onCountryChange(CountryCode code) {
    print("New Country selected: $code");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 50.0,
      child: Stack(
        children: <Widget>[
          Directionality(
            textDirection: TextDirection.ltr,
            child: TextFormField(
              controller: controller,
              textDirection: TextDirection.ltr,
              focusNode: node,
              keyboardAppearance: Brightness.light,
              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
              textInputAction: TextInputAction.next,
              validator: (String val) {
                if (val.isEmpty) {
                  return TranslationBase.of(context)
                      .getStringLocaledByKey('MOBILE_REQUIRED');
                } else {
                  return null;
                }
              },
              onFieldSubmitted: (val) {
                FocusScope.of(context).requestFocus(nextFocusNode);
              },
              decoration: Constants.textFieldDecoration.copyWith(
                  prefix: CountryCodePicker(
                    onChanged: _onCountryChange,
                    initialSelection: 'EG',
                    showCountryOnly: false,
                    padding:
                        EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                    showOnlyCountryWhenClosed: false,
                    alignLeft: false,
                  ),
                  hasFloatingPlaceholder: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 0.0),
                  hintText: "55xxxxxx",
                  labelText:
                      "\* ${TranslationBase.of(context).getStringLocaledByKey('MOBILE_NUMBER')}",
                  labelStyle: TextStyle(fontSize: 14.0)),
            ),
          ),
        ],
      ),
    );
  }
}
