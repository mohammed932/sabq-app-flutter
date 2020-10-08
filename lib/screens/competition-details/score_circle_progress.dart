import 'package:Sabq/models/competition_level.dart';
import 'package:Sabq/utils/constants.dart';
import 'package:Sabq/utils/languages/translations_delegate_base.dart';
import 'package:Sabq/widgets/general.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ScoreCircleProgress extends StatelessWidget {
  final CompetitionLevel competitionLevel;
  ScoreCircleProgress({this.competitionLevel});
  @override
  Widget build(BuildContext context) {
    String newScore = competitionLevel.evaluation.score
        .toString()
        .replaceAll(RegExp(r"([.]*00)(?!.*\d)"), "");
    return Column(
      children: <Widget>[
        General.buildTxt(txt: competitionLevel.name),
        General.sizeBoxVerical(10.0),
        Container(
          child: CircularPercentIndicator(
            radius: 160.0,
            lineWidth: 11.0,
            animation: true,
            percent: double.parse(newScore),
            center: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                General.buildTxt(
                    txt: TranslationBase.of(context)
                        .getStringLocaledByKey('REVIEW'),
                    fontSize: 18.0,
                    isBold: true,
                    color: Theme.of(context).primaryColor),
                General.sizeBoxVerical(10.0),
                General.buildTxt(
                    txt: "${int.parse(newScore) * 100}/100",
                    fontSize: 22.0,
                    isBold: true,
                    color: Theme.of(context).primaryColor)
              ],
            ),
            circularStrokeCap: CircularStrokeCap.round,
            progressColor: Constants.OrangeColor,
          ),
        ),
        Divider(
          height: 40.0,
          color: Colors.black45,
        )
      ],
    );
  }
}
