import 'package:Sabq/blocs/localization_bloc.dart';
import 'package:Sabq/widgets/general.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StackNormalHeader extends StatelessWidget {
  final String title;
  final Function onPress;
  StackNormalHeader({this.title, this.onPress});
  @override
  Widget build(BuildContext context) {
    LocalizationBloc localizationBloc = Provider.of<LocalizationBloc>(context);
    return Stack(
      children: <Widget>[
        Positioned(
            left: 0.0,
            right: 0.0,
            child: Container(
              height: 140.0,
              color: Theme.of(context).primaryColor,
            )),
        Positioned(
            left: 0.0,
            right: 0.0,
            top: 55.0,
            child: Container(
              child: General.buildTxt(
                txt: title,
                color: Colors.white,
                fontSize: 18.0,
              ),
            )),
        Positioned(
            right: localizationBloc.appLocal.languageCode == "ar" ? 5.0 : null,
            left: localizationBloc.appLocal.languageCode == "ar" ? null : 5.0,
            top: 38.0,
            child: Container(
              child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 25.0,
                  ),
                  onPressed: onPress),
            ))
      ],
    );
  }
}
