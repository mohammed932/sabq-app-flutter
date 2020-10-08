import 'package:Sabq/animations/scale-transation-route.dart';
import 'package:Sabq/blocs/evaluation_bloc.dart';
import 'package:Sabq/blocs/localization_bloc.dart';
import 'package:Sabq/components/criteria-card.dart';
import 'package:Sabq/models/evaluation_history.dart';
import 'package:Sabq/screens/judge/evaluation/open_audio.dart';
import 'package:Sabq/screens/judge/evaluation/open_video.dart';
import 'package:Sabq/utils/constants.dart';
import 'package:Sabq/utils/global_functions.dart';
import 'package:Sabq/utils/languages/translations_delegate_base.dart';
import 'package:Sabq/widgets/general.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class EvaluationResultScreen extends StatefulWidget {
  final EvaluationHistory evaluationHistory;
  EvaluationResultScreen({@required this.evaluationHistory});
  @override
  _EvaluationResultScreenState createState() => _EvaluationResultScreenState();
}

class _EvaluationResultScreenState extends State<EvaluationResultScreen> {
  EvaluationBloc evaluationBloc;
  _back() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    evaluationBloc.resetStopwatchTimePreview();
    super.dispose();
  }

  _openMedia() {
    if (widget.evaluationHistory.participation.attachment.type == "AUDIO") {
      Navigator.push(
          context,
          ScaleTransationRoute(
              page: LocalAudio(
            borderRadius: 5,
            marginBottom: 0,
            isHaveDuration: false,
            playerUrl: widget.evaluationHistory.participation.attachment.path,
          )));
    } else {
      Navigator.push(
          context,
          ScaleTransationRoute(
              page: VideoScreen(
            videoPlayerController: VideoPlayerController.network(
                widget.evaluationHistory.participation.attachment.path),
          )));
    }
  }

  _openInWeb() async {
    String url = widget.evaluationHistory.participation.attachment.path;
    if (await canLaunch(url)) {
      await launch(
        url,
        forceWebView: true,
        // forceSafariVC: false,
        enableJavaScript: true,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    LocalizationBloc localizationBloc = Provider.of<LocalizationBloc>(context);
    evaluationBloc = Provider.of<EvaluationBloc>(context);
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            Positioned(
              left: 0.0,
              right: 0.0,
              height: 250.0,
              child: Container(
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: new AssetImage("assets/imgs/profile-img.png"),
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    repeat: ImageRepeat.repeatY,
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.6), BlendMode.darken),
                  ),
                ),
              ),
            ),
            Positioned(
                left: 0.0,
                right: 0.0,
                top: 90.0,
                child: GestureDetector(
                  onTap: _openMedia,
                  child: Image.asset(
                    'assets/imgs/player.png',
                    width: 60.0,
                    height: 60.0,
                  ),
                )),
            Positioned(
                right:
                    localizationBloc.appLocal.languageCode == "ar" ? 0.0 : null,
                left:
                    localizationBloc.appLocal.languageCode == "ar" ? null : 0.0,
                top: 30.0,
                child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 25.0,
                    ),
                    onPressed: _back)),
            Container(
              height: MediaQuery.of(context).size.height,
              margin: EdgeInsets.only(top: 200.0),
              decoration: BoxDecoration(
                  color: Color(General.getColorHexFromStr('#FAFAFA')),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50.0),
                    topRight: Radius.circular(50.0),
                  )),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    General.sizeBoxVerical(30.0),
                    _competitorNumber(),
                    General.sizeBoxVerical(15.0),
                    General.buildTxt(
                        txt: widget.evaluationHistory.participation
                            .competitionLevel.competition.name,
                        color: Colors.black54,
                        fontSize: 13.0),
                    General.sizeBoxVerical(20.0),
                    _evaluationDuration(),
                    General.sizeBoxVerical(15.0),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      alignment: Alignment.topRight,
                      child: General.buildTxt(
                          txt:
                              "${TranslationBase.of(context).getStringLocaledByKey('PARTICIPATION_DATE')} : ${GlobalFunctions.formatDate(widget.evaluationHistory.participationDate)} م",
                          color: Colors.black54,
                          isCenter: false,
                          fontSize: 13.0),
                    ),
                    General.sizeBoxVerical(15.0),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      alignment: Alignment.topRight,
                      child: General.buildTxt(
                          txt: TranslationBase.of(context)
                              .getStringLocaledByKey('CRITERIA'),
                          isBold: true,
                          color: Theme.of(context).primaryColor,
                          isCenter: false,
                          fontSize: 13.0),
                    ),
                    General.sizeBoxVerical(5.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 20.0),
                          child: General.buildTxt(
                              txt: TranslationBase.of(context)
                                  .getStringLocaledByKey('CRITERIA_TYPE')),
                        ),
                        General.buildTxt(
                            txt: TranslationBase.of(context)
                                .getStringLocaledByKey('DEGREE'))
                      ],
                    ),
                    Column(
                        children: List.generate(
                            widget.evaluationHistory.grades.length, (index) {
                      if (index.isOdd) {
                        return CriteriaCard(
                          isHaveBackground: true,
                          grade: widget.evaluationHistory.grades[index],
                        );
                      } else {
                        return CriteriaCard(
                            grade: widget.evaluationHistory.grades[index]);
                      }
                    })),
                    General.sizeBoxVerical(30.0),
                    _buildTotalScore()
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _competitorNumber() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        widget.evaluationHistory.participation.competitor != null
            ? General.buildTxt(
                txt:
                    "${TranslationBase.of(context).getStringLocaledByKey('COMPETITOR_NUMBER')} #${widget.evaluationHistory.participation.competitor.id}",
                isBold: true,
                fontSize: 18.0,
                color: Theme.of(context).primaryColor)
            : Container(),
        General.sizeBoxHorizontial(10.0),
        GestureDetector(
          onTap: _openInWeb,
          child: Image.asset(
            'assets/imgs/eye.png',
            width: 25.0,
          ),
        )
      ],
    );
  }

  _evaluationDuration() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      alignment: Alignment.topRight,
      child: General.buildTxt(
          txt:
              "${TranslationBase.of(context).getStringLocaledByKey('REVIEW_DURATION')}: ${widget.evaluationHistory.judgementDuration}",
          fontSize: 13.0,
          color: Colors.black54),
    );
  }

  _buildTotalScore() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(15.0),
      color: Constants.OrangeColor.withOpacity(0.3),
      child: Center(
        child: RichText(
            text: TextSpan(
                text:
                    "${TranslationBase.of(context).getStringLocaledByKey('TOTAL_SUMMATION')} :",
                style: TextStyle(fontSize: 16.0, color: Colors.black87),
                children: [
              TextSpan(
                  text: " ${widget.evaluationHistory.totalRate} ",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Theme.of(context).primaryColor,
                  )),
            ])),
      ),
    );
  }
}
