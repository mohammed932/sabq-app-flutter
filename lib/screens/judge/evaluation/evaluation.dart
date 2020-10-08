import 'dart:async';
import 'dart:convert';
import 'package:Sabq/animations/scale-transation-route.dart';
import 'package:Sabq/blocs/evaluation_bloc.dart';
import 'package:Sabq/blocs/localization_bloc.dart';
import 'package:Sabq/components/name_field.dart';
import 'package:Sabq/components/round_buttton.dart';
import 'package:Sabq/models/competition_level.dart';
import 'package:Sabq/models/rate_participation.dart';
import 'package:Sabq/utils/constants.dart';
import 'package:Sabq/utils/languages/translations_delegate_base.dart';
import 'package:Sabq/widgets/general.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'open_audio.dart';
import 'open_video.dart';
import 'package:video_player/video_player.dart';

class EvaluationScreen extends StatefulWidget {
  final CompetitionLevel level;
  EvaluationScreen({@required this.level});
  @override
  _EvaluationScreenState createState() => _EvaluationScreenState();
}

class _EvaluationScreenState extends State<EvaluationScreen> {
  TextEditingController _commentController = TextEditingController();
  FocusNode _commentFocus = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Grade> grades = [];
  EvaluationBloc evaluationBloc;
  AudioPlayer audioPlayer;
  _back() {
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    evaluationBloc.timer.cancel();
    evaluationBloc.stopwatch.reset();
    evaluationBloc.resetStopwatchTimePreview();
    super.dispose();
  }

  init() async {
    await Future.delayed(Duration(milliseconds: 100));
    evaluationBloc = Provider.of<EvaluationBloc>(context, listen: false);
    evaluationBloc.getLevelTests(levelId: widget.level.id);
    // evaluationBloc.startTimer();
  }

  _getAnotherParticipation(EvaluationBloc state) {
    evaluationBloc.timer.cancel();
    evaluationBloc.stopwatch.reset();
    evaluationBloc.startTimer();
    evaluationBloc.getLevelTests(levelId: widget.level.id);
  }

  openAppropriateMedia() {
    if (evaluationBloc.randomParticipation.attachment.type == "AUDIO") {
      Navigator.push(
          context,
          ScaleTransationRoute(
              page: LocalAudio(
            borderRadius: 5,
            marginBottom: 0,
            playerUrl: evaluationBloc.randomParticipation.attachment.path,
          )));
    } else {
      Navigator.push(
          context,
          ScaleTransationRoute(
              page: VideoScreen(
            videoPlayerController: VideoPlayerController.network(
                evaluationBloc.randomParticipation.attachment.path),
          )));
    }
  }

  _saveEvaluation(EvaluationBloc state) {
    if (!_formKey.currentState.validate()) {
      return;
    } else {
      _formKey.currentState.save();
    }
    List<Grade> grades = [];
    state.levelTests.forEach((parentTest) {
      parentTest.testItems.forEach((item) {
        grades.add(Grade(testId: item.id, value: item.testValue.round()));
      });
    });
    RateParticipation rateParticipation = RateParticipation(
        levelId: widget.level.id,
        participationId: state.randomParticipation.id,
        judgementDuration: state.stopwatchTimePreview.substring(0, 5),
        notes: _commentController.text,
        grades: grades);

    state.rateParticipation(params: rateParticipation, context: context);
    print('rateParticipation :${jsonEncode(rateParticipation)}');
  }

  @override
  Widget build(BuildContext context) {
    LocalizationBloc localizationBloc = Provider.of<LocalizationBloc>(context);
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
                    image: widget.level.competition.image == null
                        ? AssetImage("assets/imgs/bg-img.png")
                        : NetworkImage(widget.level.competition.image),
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
                child: SingleChildScrollView(
                  child: Consumer<EvaluationBloc>(
                      builder: (BuildContext context, state, __) {
                    if (state.error != null) {
                      return Container();
                    } else if (state.hasData) {
                      return GestureDetector(
                        onTap: openAppropriateMedia,
                        child: Image.asset(
                          'assets/imgs/player.png',
                          width: 60.0,
                          height: 60.0,
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }),
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
              child: SingleChildScrollView(child: Consumer<EvaluationBloc>(
                  builder: (BuildContext context, state, __) {
                if (state.error != null) {
                  return Container(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: Center(child: General.buildTxt(txt: state.error)));
                } else if (state.hasData) {
                  return Column(
                    children: <Widget>[
                      General.sizeBoxVerical(10.0),
                      Container(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          children: <Widget>[
                            _competitorNumber(state),
                            General.sizeBoxVerical(20.0),
                            _evaluationDuration(state),
                            General.sizeBoxVerical(20.0),
                            Container(
                              alignment:
                                  localizationBloc.appLocal.languageCode == "ar"
                                      ? Alignment.bottomRight
                                      : Alignment.bottomLeft,
                              child: General.buildTxt(
                                  txt:
                                      "${TranslationBase.of(context).getStringLocaledByKey('REVIEW')} :",
                                  fontSize: 16.0,
                                  color: Theme.of(context).primaryColor),
                            ),
                            General.sizeBoxVerical(20.0),
                            state.levelTests != null
                                ? Column(
                                    children:
                                        state.levelTests.map((parentTest) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        General.buildTxt(
                                            txt: parentTest.name, isBold: true),
                                        Column(
                                          children:
                                              parentTest.testItems.map((item) {
                                            return Row(
                                              children: <Widget>[
                                                General.buildTxt(
                                                    txt: item.criteria.name,
                                                    fontSize: 12.0),
                                                Expanded(
                                                  flex: 6,
                                                  child: Slider(
                                                      value: item.testValue,
                                                      min: 0,
                                                      max: item.points
                                                          .toDouble(),
                                                      divisions: 100,
                                                      activeColor:
                                                          Theme.of(context)
                                                              .primaryColor,
                                                      inactiveColor:
                                                          Constants.OrangeColor
                                                              .withOpacity(0.3),
                                                      label:
                                                          '${item.testValue.round()}',
                                                      onChanged: (double val) {
                                                        setState(() {
                                                          item.testValue = val;
                                                        });
                                                      }),
                                                ),
                                                Expanded(
                                                    child: General.buildTxt(
                                                        fontSize: 12.0,
                                                        txt:
                                                            "${item.testValue.round()}/${item.points}"))
                                              ],
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    );
                                  }).toList())
                                : Container(),
                            General.sizeBoxVerical(5.0),
                          ],
                        ),
                      ),
                      _buildTotalScore(state),
                      General.sizeBoxVerical(15.0),
                      Container(
                        padding: EdgeInsets.all(20.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              NameField(
                                  controller: _commentController,
                                  node: _commentFocus,
                                  icon: "assets/imgs/comment.png",
                                  nextFocusNode: null,
                                  validation: TranslationBase.of(context)
                                      .getStringLocaledByKey(
                                          'COMMENT_REQUIRED'),
                                  textLabel: TranslationBase.of(context)
                                      .getStringLocaledByKey(
                                          'WRITE_COMMENT_HERE')),
                              General.sizeBoxVerical(20.0),
                              _evalutionBtn(context, state),
                              General.sizeBoxVerical(10.0),
                              !widget.level.skipContinueButton
                                  ? Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: RoundButton(
                                          onPress: () =>
                                              _getAnotherParticipation(state),
                                          roundVal: 100.0,
                                          color: Constants.OrangeColor,
                                          buttonTitle: General.buildTxt(
                                              txt: TranslationBase.of(context)
                                                  .getStringLocaledByKey(
                                                      'SKIP'),
                                              color: Colors.white)),
                                    )
                                  : Container()
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                } else {
                  return Container(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: General.customThreeBounce(context,
                          color: Theme.of(context).primaryColor, size: 30.0));
                }
              })),
            )
          ],
        ),
      ),
    );
  }

  _evalutionBtn(BuildContext context, EvaluationBloc state) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: RoundButton(
          onPress: !state.isWaiting ? () => _saveEvaluation(state) : null,
          roundVal: 100.0,
          disableColor: Theme.of(context).accentColor,
          buttonTitle: !state.isWaiting
              ? General.buildTxt(
                  txt: TranslationBase.of(context)
                      .getStringLocaledByKey('SAVE_REVIEW'),
                  color: Colors.white)
              : General.customThreeBounce(context)),
    );
  }

  _competitorNumber(EvaluationBloc state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        General.buildTxt(
            txt: state.randomParticipation != null &&
                    state.randomParticipation.competitor != null
                ? "${TranslationBase.of(context).getStringLocaledByKey('COMPETITOR_NUMBER')} #${state.randomParticipation.competitor.id}"
                : "",
            isBold: true,
            fontSize: 18.0,
            color: Theme.of(context).primaryColor),
        General.sizeBoxHorizontial(10.0),
        Image.asset(
          'assets/imgs/eye.png',
          width: 25.0,
        )
      ],
    );
  }

  Container _evaluationDuration(EvaluationBloc state) {
    return Container(
      alignment: Alignment.center,
      child: General.buildTxt(
          txt:
              "${TranslationBase.of(context).getStringLocaledByKey('REVIEW_DURATION')} ${state.stopwatchTimePreview}",
          fontSize: 14.0,
          color: Colors.black54),
    );
  }

  _buildTotalScore(EvaluationBloc state) {
    num totalScore = 0;
    state.levelTests.forEach((parentTest) {
      parentTest.testItems.forEach((item) {
        totalScore += item.testValue;
      });
    });
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
                  text: " ${totalScore.round()} ",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Theme.of(context).primaryColor,
                  )),
            ])),
      ),
    );
  }
}
