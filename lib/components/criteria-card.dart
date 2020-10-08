import 'package:Sabq/models/evaluation_history.dart';
import 'package:Sabq/widgets/general.dart';
import 'package:flutter/material.dart';

class CriteriaCard extends StatelessWidget {
  final bool isHaveBackground;
  final Grade grade;
  CriteriaCard({this.isHaveBackground = false, this.grade});
  @override
  Widget build(BuildContext context) {
    return Container(
      color:
          isHaveBackground ? Colors.grey.withOpacity(0.3) : Colors.transparent,
      padding: EdgeInsets.symmetric(vertical: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          General.buildTxt(
              txt: grade.criteriaName, fontSize: 12.0, isCenter: false),
          General.buildTxt(txt: grade.value.toString(), fontSize: 12.0)
        ],
      ),
    );
  }
}
