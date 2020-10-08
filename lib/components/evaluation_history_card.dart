import 'package:Sabq/animations/scale-transation-route.dart';
import 'package:Sabq/components/round_buttton.dart';
import 'package:Sabq/models/evaluation_history.dart';
import 'package:Sabq/screens/judge/evaluation_result/evaluation_result.dart';
import 'package:Sabq/utils/global_functions.dart';
import 'package:Sabq/utils/languages/translations_delegate_base.dart';
import 'package:Sabq/widgets/general.dart';
import 'package:flutter/material.dart';

class EvaluationHistoryCard extends StatelessWidget {
  final EvaluationHistory evaluationHistory;
  EvaluationHistoryCard({this.evaluationHistory});
  openRecord(BuildContext context) {
    Navigator.push(
        context,
        ScaleTransationRoute(
            page: EvaluationResultScreen(
          evaluationHistory: evaluationHistory,
        )));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          evaluationHistory.participation.competitor != null
              ? _competitiorImage()
              : Container(),
          General.sizeBoxHorizontial(6.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    evaluationHistory.participation.competitor != null
                        ? Expanded(
                            child: General.buildTxt(
                                txt:
                                    '${evaluationHistory.participation.competitor.firstname} ${evaluationHistory.participation.competitor.secondname}',
                                color: Theme.of(context).primaryColor,
                                fontSize: 12.0,
                                isCenter: false))
                        : Container(),
                    evaluationHistory.participation.competitionLevel != null &&
                            evaluationHistory.participation.competitionLevel
                                    .competition !=
                                null
                        ? Expanded(
                            child: General.buildTxt(
                                txt: evaluationHistory.participation
                                    .competitionLevel.competition.name,
                                color: Colors.black54,
                                lineHeight: 1.5,
                                fontSize: 12.0))
                        : Container()
                  ],
                ),
                General.sizeBoxVerical(10.0),
                General.buildTxt(
                    txt:
                        "${TranslationBase.of(context).getStringLocaledByKey('PARTICIPATION_NUMBER')} #${evaluationHistory.participation.id}",
                    fontSize: 10.0,
                    color: Colors.black45),
                // General.sizeBoxVerical(10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    General.buildTxt(
                        txt:
                            "${TranslationBase.of(context).getStringLocaledByKey('PARTICIPATION_DATE')}: ${GlobalFunctions.formatDate(evaluationHistory.participationDate)} م",
                        fontSize: 10.0,
                        color: Colors.black45),
                    RoundButton(
                        onPress: () => openRecord(context),
                        roundVal: 20.0,
                        verticalPadding: 8.0,
                        buttonTitle: General.buildTxt(
                            txt: TranslationBase.of(context)
                                .getStringLocaledByKey('SHOW_DEGREES'),
                            color: Colors.white,
                            fontSize: 12.0)),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  _competitiorImage() {
    return Container(
      alignment: Alignment.center,
      child: CircleAvatar(
        radius: 30.0,
        child: Stack(
          children: <Widget>[],
        ),
        backgroundImage: evaluationHistory.participation.competitor.image ==
                null
            ? AssetImage('assets/imgs/profile-img.png')
            : NetworkImage(evaluationHistory.participation.competitor.image),
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
