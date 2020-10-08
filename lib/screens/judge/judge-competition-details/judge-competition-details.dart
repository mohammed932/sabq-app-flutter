import 'package:Sabq/animations/scale-transation-route.dart';
import 'package:Sabq/blocs/competition_details_bloc.dart';
import 'package:Sabq/blocs/evaluation_bloc.dart';
import 'package:Sabq/components/audio_box.dart';
import 'package:Sabq/components/round_buttton.dart';
import 'package:Sabq/components/video_box.dart';
import 'package:Sabq/models/competition.dart';
import 'package:Sabq/models/competition_level.dart';
import 'package:Sabq/models/participationLevel.dart';
import 'package:Sabq/screens/judge/evaluation/evaluation.dart';
import 'package:Sabq/screens/judge/evaluation/open_video.dart';
import 'package:Sabq/utils/global_functions.dart';
import 'package:Sabq/utils/languages/translations_delegate_base.dart';
import 'package:Sabq/widgets/general.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import 'level-slide-bar.dart';

class JudgeCompetitionDetailsScreen extends StatefulWidget {
  final Competition competition;
  final bool isExpired;
  JudgeCompetitionDetailsScreen({this.competition, this.isExpired = false});
  @override
  _JudgeCompetitionDetailsScreenState createState() =>
      _JudgeCompetitionDetailsScreenState();
}

class _JudgeCompetitionDetailsScreenState
    extends State<JudgeCompetitionDetailsScreen> {
  double _currentOpacity = 0;
  CompetitionDetailsBloc competitionDetailsBloc;
  EvaluationBloc evaluationBloc;
  _back() {
    Navigator.pop(context);
  }

  _openEvaluattionScreen(CompetitionLevel level) async {
    Navigator.push(
        context,
        ScaleTransationRoute(
            page: EvaluationScreen(
          level: level,
        )));
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  void dispose() {
    evaluationBloc.resetStopwatchTimePreview();
    super.dispose();
  }

  init() async {
    await Future.delayed(Duration(milliseconds: 200));
    competitionDetailsBloc =
        Provider.of<CompetitionDetailsBloc>(context, listen: false);
    evaluationBloc = Provider.of<EvaluationBloc>(context, listen: false);
    competitionDetailsBloc.getCompetition(id: widget.competition.id);
    setState(() => _currentOpacity = 1);
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
              child: Container(child: Consumer<CompetitionDetailsBloc>(
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
                            txt: state.competition.name,
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
              })),
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
                              General.buildTxt(
                                  txt: state.competition.description,
                                  lineHeight: 1.7,
                                  isCenter: false,
                                  fontSize: 12.0,
                                  color: Colors.black87),
                              General.sizeBoxVerical(50.0),
                              !widget.isExpired
                                  ? Column(
                                      children:
                                          state.competitionLevels.map((level) {
                                        if (level.status == 'ACTIVE' &&
                                            level.isInitialLevel) {
                                          return Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            child: RoundButton(
                                                onPress: () =>
                                                    _openEvaluattionScreen(
                                                        level),
                                                roundVal: 100.0,
                                                disableColor: Theme.of(context)
                                                    .accentColor,
                                                buttonTitle: General.buildTxt(
                                                    txt: TranslationBase.of(
                                                            context)
                                                        .getStringLocaledByKey(
                                                            'REQUEST_CLIP_FOR_REVIEW'),
                                                    color: Colors.white)),
                                          );
                                        } else {
                                          return Container();
                                        }
                                      }).toList(),
                                    )
                                  : _mediaList(state),
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

  _openInWeb(ParticipationLevel participationLevel) async {
    String url = participationLevel.attachment.path;
    print(url);
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

  _onLevelPress(CompetitionLevel level) {
    print(competitionDetailsBloc.competition.competitionLevels);
    competitionDetailsBloc.competition.competitionLevels
        .forEach((item) => item.isActive = false);
    competitionDetailsBloc.competition.competitionLevels.forEach((item) {
      if (level.id == item.id) {
        level.isActive = true;
        competitionDetailsBloc.getLevelAttachments(levelId: level.id);
      }
    });
    setState(() {});
  }

  _mediaList(CompetitionDetailsBloc state) {
    return Column(
      children: <Widget>[
        LevelBar(
          levels: state.competition.competitionLevels,
          onLevelPress: _onLevelPress,
        ),
        !state.waitingLevel
            ? state.participationLevels.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: state.participationLevels.length,
                    itemBuilder: (BuildContext context, int index) {
                      ParticipationLevel participationLevel =
                          state.participationLevels[index];
                      return Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () => _openInWeb(participationLevel),
                              child: Container(
                                child: Image.asset(
                                  'assets/imgs/eye.png',
                                  width: 25.0,
                                ),
                              ),
                            ),
                            General.sizeBoxVerical(15.0),
                            participationLevel.attachment.type == 'VIDEO'
                                ? GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => VideoScreen(
                                            videoPlayerController:
                                                VideoPlayerController.network(
                                                    participationLevel
                                                        .attachment.path),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Stack(
                                      children: <Widget>[
                                        ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child: VideoBox(
                                                videoPlayerController:
                                                    VideoPlayerController
                                                        .network(
                                                            participationLevel
                                                                .attachment
                                                                .path))),
                                        Positioned.fill(
                                            child: Container(
                                          color: Color.fromRGBO(0, 0, 0, .2),
                                        )),
                                        Positioned(
                                          right: 0,
                                          left: 0,
                                          top: 0,
                                          bottom: 0,
                                          child: Icon(
                                            Icons.play_circle_filled,
                                            size: 50,
                                            color: Colors.white,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                : AudioBox(
                                    playerUrl:
                                        participationLevel.attachment.path,
                                  ),
                            Row(
                              children: <Widget>[
                                CircleAvatar(
                                  radius: 25.0,
                                  child: Stack(
                                    children: <Widget>[],
                                  ),
                                  backgroundImage: participationLevel
                                              .competitor.image ==
                                          null
                                      ? AssetImage(
                                          'assets/imgs/profile-img.png')
                                      : NetworkImage(
                                          participationLevel.competitor.image),
                                  backgroundColor: Colors.transparent,
                                ),
                                General.sizeBoxHorizontial(10.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    General.buildTxt(
                                        txt:
                                            "${participationLevel.competitor.firstname} ${participationLevel.competitor.secondname}"),
                                    General.sizeBoxVerical(10.0),
                                    General.buildTxt(
                                        txt:
                                            "المسابقة : ${state.competition.name}")
                                  ],
                                )
                              ],
                            ),
                            Divider()
                          ],
                        ),
                      );
                    })
                : Container(
                    margin: EdgeInsets.only(top: 50.0),
                    child: General.buildTxt(txt: "لا يوجد مشاركات"),
                  )
            : General.customThreeBounce(context),
      ],
    );
  }
}
