import 'package:Sabq/blocs/competition_bloc.dart';
import 'package:Sabq/blocs/competition_details_bloc.dart';
import 'package:Sabq/components/round_buttton.dart';
import 'package:Sabq/models/competition.dart';
import 'package:Sabq/models/competition_level.dart';
import 'package:Sabq/screens/competition-details/score_circle_progress.dart';
import 'package:Sabq/utils/global_functions.dart';
import 'package:Sabq/utils/languages/translations_delegate_base.dart';
import 'package:Sabq/widgets/general.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:provider/provider.dart';
import 'upload_clip_dialogue.dart';

class CompetitionDetails extends StatefulWidget {
  final Competition competition;

  CompetitionDetails({this.competition});
  @override
  _CompetitionDetailsState createState() => _CompetitionDetailsState();
}

class _CompetitionDetailsState extends State<CompetitionDetails> {
  CompetitionDetailsBloc competitionDetailsBloc;
  double _currentOpacity = 0;
  num uploadProgress = 0;
  final FlutterUploader uploader = FlutterUploader();
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
    super.dispose();
    uploader.cancelAll();
  }

  init() async {
    await Future.delayed(Duration(milliseconds: 200));
    competitionDetailsBloc =
        Provider.of<CompetitionDetailsBloc>(context, listen: false);
    competitionDetailsBloc.getCompetition(id: widget.competition.id);
    initProgress();
    setState(() => _currentOpacity = 1);
  }

  initProgress() {
    uploader.progress.listen((progress) {
      print("my progress is :${progress.progress}");
      if (mounted) {
        uploadProgress = progress.progress;
        competitionDetailsBloc.setProgressIndicator(val: progress.progress);
      }
    });
  }

  _enroll(CompetitionDetailsBloc state) async {
    if (state.enrollmentStatus.isEnrolledInCompetition) {
      print("is enrolled");
      state.setIsDialogueDissmissed(val: false);
      var dialogueResult = await UploadClipDialogue.openDailogue(
          context: context, competition: widget.competition);
      if (dialogueResult == null && uploadProgress > 0) {
        uploadProgress = 0;
        state.setIsDialogueDissmissed(val: true);
        uploader.cancel(taskId: state.uploadMediaTaskId);
      }
    } else {
      print("not enrolled");
      enrollInCompetition();
    }
  }

  enrollInCompetition() async {
    try {
      competitionDetailsBloc.setIsDialogueDissmissed(val: false);
      var dialogueResult = await UploadClipDialogue.openDailogue(
          context: context, competition: widget.competition);
      if (dialogueResult == null && uploadProgress > 0) {
        uploadProgress = 0;

        competitionDetailsBloc.setIsDialogueDissmissed(val: true);
        uploader.cancel(taskId: competitionDetailsBloc.uploadMediaTaskId);
      }
    } catch (e) {
      General.showDialogue(
          txtWidget: General.buildTxt(
              txt: e.message.errors[0], fontSize: 13.0, lineHeight: 1.3),
          context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            Positioned(
              left: 0.0,
              right: 0.0,
              height: 250.0,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: widget.competition.image.isEmpty
                        ? AssetImage("assets/imgs/bg-img.png")
                        : NetworkImage(widget.competition.image),
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
              height: 200.0,
              child: Container(
                child: Consumer<CompetitionDetailsBloc>(
                    builder: (BuildContext context, state, __) {
                  if (!state.waiting) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        General.sizeBoxVerical(30.0),
                        IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                              size: 25.0,
                            ),
                            onPressed: _back),
                        General.sizeBoxVerical(10.0),
                        Container(
                          alignment: Alignment.center,
                          child: General.buildTxt(
                              txt: widget.competition.name,
                              fontSize: 16.0,
                              color: Colors.white,
                              isBold: true),
                        ),
                        General.sizeBoxVerical(10.0),
                        state.competition.intailLevel != null
                            ? Container(
                                alignment: Alignment.center,
                                child: General.buildTxt(
                                  txt: state
                                      .competition.competitionLevels.last.name,
                                  fontSize: 14.0,
                                  color: Colors.white,
                                ),
                              )
                            : Container(),
                        General.sizeBoxVerical(10.0),
                        Container(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              General.buildTxt(
                                txt:
                                    "${GlobalFunctions.formatDate(widget.competition.from)} م",
                                fontSize: 14.0,
                                color: Colors.white,
                              ),
                              General.buildTxt(
                                txt:
                                    "  -  ${GlobalFunctions.formatDate(widget.competition.to)} م",
                                fontSize: 14.0,
                                color: Colors.white,
                              )
                            ],
                          ),
                        )
                      ],
                    );
                  } else {
                    return Container();
                  }
                }),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 200.0),
              height: MediaQuery.of(context).size.height,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                    color: Color(General.getColorHexFromStr('#FAFAFA')),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50.0),
                      topRight: Radius.circular(50.0),
                    )),
                child: SingleChildScrollView(
                  child: AnimatedOpacity(
                      duration: Duration(seconds: 1),
                      opacity: _currentOpacity,
                      curve: Curves.easeIn,
                      child: Consumer<CompetitionDetailsBloc>(
                          builder: (BuildContext context, state, __) {
                        if (!state.waiting) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              General.sizeBoxVerical(30.0),
                              state.competition != null &&
                                      state.competition.description != null
                                  ? General.buildTxt(
                                      txt: state.competition.description,
                                      lineHeight: 1.7,
                                      isCenter: false,
                                      fontSize: 12.0,
                                      color: Colors.black87)
                                  : Container(),
                              General.sizeBoxVerical(80.0),
                              // _showAppropriateWidget(state)
                              state.competitionLevels != null ||
                                      state.competitionLevels.isNotEmpty
                                  ? buildScoreSection(state)
                                  : buildCupsSection(state)
                            ],
                          );
                        } else {
                          return Container(
                              margin: EdgeInsets.only(
                                  top:
                                      MediaQuery.of(context).size.height * 0.4),
                              child: General.customThreeBounce(context,
                                  color: Theme.of(context).primaryColor,
                                  size: 30.0));
                        }
                      })),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _showAppropriateWidget(state) {
    if (state.competitionLevels != null) {
      return buildScoreSection(state);
    } else if (state.enrollmentStatus.isEnrolledInCompetition) {}
  }

  buildScoreSection(CompetitionDetailsBloc state) {
    print('aaa :${state.enrollmentStatus.isEnrolledInCompetition}');
    return state.competitionLevels.isNotEmpty
        ? Column(
            children: state.competitionLevels.map<Widget>((level) {
              switch (level.evaluation.evaluated) {
                case "EVALUATED":
                  return ScoreCircleProgress(competitionLevel: level);
                  break;
                case "NOT_EVALUATED":
                  if (level.evaluation.file == "HAS_UPLOADED_FILE") {
                    return _notEvalutedWidget(level);
                  } else {
                    return _evaluateButton(state);
                  }
                  break;
                default:
                  return Container();
              }
            }).toList(),
          )
        : state.enrollmentStatus.isEnrolledInCompetition
            ? Center(
                child: Column(
                  children: <Widget>[
                    General.buildTxt(
                        txt: TranslationBase.of(context)
                            .getStringLocaledByKey('PARTICIPATION_PRESENTED'),
                        isBold: true),
                    General.sizeBoxVerical(10.0),
                    General.buildTxt(
                        txt: TranslationBase.of(context).getStringLocaledByKey(
                            'WILL_NOTIFY_AFTER_REVIEW_UR_PARTICIPATION'))
                  ],
                ),
              )
            : buildCupsSection(state);
  }

  _notEvalutedWidget(CompetitionLevel level) {
    return Column(
      children: <Widget>[
        General.buildTxt(txt: level.name, lineHeight: 1.5),
        General.sizeBoxVerical(20.0),
        General.buildTxt(
            txt: TranslationBase.of(context)
                .getStringLocaledByKey('NOT_REVIEW_YET'),
            fontSize: 13.0,
            color: Colors.black54),
        Divider(
          height: 40.0,
          color: Colors.black45,
        )
      ],
    );
  }

  buildCupsSection(CompetitionDetailsBloc state) {
    if (state.enrollmentStatus != null) {
      if (!state.enrollmentStatus.hasUploadedTempParticipation &&
          !state
              .enrollmentStatus.hasUploadedNormalParticipationToInitialLevel) {
        return _cupWidget(state);
      } else {
        return Container();
      }
    }
  }

  _cupWidget(CompetitionDetailsBloc state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _drawCup(
                cupImg: 'assets/imgs/third-cup.png',
                cupSize: 90.0,
                prize: state.competition.thirdPostion),
            _drawCup(
                cupImg: 'assets/imgs/first-cup.png',
                cupSize: 120.0,
                prize: state.competition.firstPostion),
            _drawCup(
                cupImg: 'assets/imgs/second-cup.png',
                cupSize: 90.0,
                prize: state.competition.secondPostion),
          ],
        ),
        General.sizeBoxVerical(50.0),
        _evaluateButton(state)
      ],
    );
  }

  _evaluateButton(CompetitionDetailsBloc state) {
    return RoundButton(
        onPress: !state.isWaiting ? () => _enroll(state) : null,
        roundVal: 100.0,
        disableColor: Theme.of(context).primaryColor.withOpacity(0.6),
        buttonTitle: !state.isWaiting
            ? General.buildTxt(
                txt: TranslationBase.of(context)
                    .getStringLocaledByKey('PRESENT_CLIP_FOR_REVIEW'),
                color: Colors.white)
            : General.customThreeBounce(context));
  }

  _drawCup({String cupImg, num cupSize, String cupTag, String prize}) {
    return Column(
      children: <Widget>[
        _drawCupPrize(prize: prize),
        Container(
          child: Image.asset(
            cupImg,
            width: cupSize,
          ),
        ),
      ],
    );
  }

  _drawCupPrize({String prize}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        General.buildTxt(
            txt: prize,
            isBold: true,
            fontSize: 16.0,
            color: Theme.of(context).primaryColor),
        General.sizeBoxVerical(6.0),
        General.buildTxt(
            txt: TranslationBase.of(context).getStringLocaledByKey('RYAL'),
            fontSize: 13.0,
            color: Theme.of(context).primaryColor)
      ],
    );
  }
}
