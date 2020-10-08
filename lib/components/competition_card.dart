import 'package:Sabq/blocs/localization_bloc.dart';
import 'package:Sabq/models/competition.dart';
import 'package:Sabq/utils/constants.dart';
import 'package:Sabq/utils/global_functions.dart';
import 'package:Sabq/utils/languages/translations_delegate_base.dart';
import 'package:Sabq/widgets/general.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CompetitionCard extends StatelessWidget {
  final Competition competition;
  CompetitionCard({@required this.competition});
  @override
  Widget build(BuildContext context) {
    LocalizationBloc localizationBloc = Provider.of<LocalizationBloc>(context);
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0))),
      margin: EdgeInsets.only(bottom: 20.0),
      child: Stack(
        children: <Widget>[
          ClipRRect(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0)),
              child: competition.image.isEmpty
                  ? Image.asset("assets/imgs/bg-img.png")
                  : Image.network(
                      competition.image,
                      height: 200.0,
                      width: MediaQuery.of(context).size.width,
                    )),
          Container(
            margin: EdgeInsets.only(top: 130.0, bottom: 0.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                  child: General.buildTxt(
                    txt: competition.name,
                    isBold: true,
                    isCenter: false,
                    color: Constants.OrangeColor,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                      top: 10.0,
                      right: localizationBloc.appLocal.languageCode == "ar"
                          ? 10.0
                          : 0.0,
                      left: localizationBloc.appLocal.languageCode == "ar"
                          ? 0.0
                          : 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      General.buildTxt(
                        txt:
                            "${GlobalFunctions.formatDate(competition.from)} - ${GlobalFunctions.formatDate(competition.to)}",
                        isCenter: false,
                        fontSize: 12.0,
                        color: Colors.grey,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 10.0),
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius:
                                localizationBloc.appLocal.languageCode == "ar"
                                    ? BorderRadius.only(
                                        topRight: Radius.circular(20.0),
                                        bottomLeft: Radius.circular(20.0),
                                      )
                                    : BorderRadius.only(
                                        topLeft: Radius.circular(20.0),
                                        bottomRight: Radius.circular(20.0),
                                      )),
                        child: General.buildTxt(
                            txt: TranslationBase.of(context)
                                .getStringLocaledByKey('SHOW_DETAILS'),
                            color: Colors.white,
                            fontSize: 14.0),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
