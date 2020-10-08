import 'package:Sabq/widgets/general.dart';
import 'package:flutter/material.dart';

class EmptyCompetition extends StatelessWidget {
  final String text;
  EmptyCompetition({@required this.text});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            "assets/imgs/empty-competition.png",
            width: 250.0,
          ),
          General.sizeBoxVerical(15.0),
          General.buildTxt(txt: text, fontSize: 18.0, color: Colors.black54)
        ],
      ),
    );
  }
}
