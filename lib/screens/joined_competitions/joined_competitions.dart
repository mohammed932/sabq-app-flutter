import 'package:Sabq/animations/scale-transation-route.dart';
import 'package:Sabq/blocs/competition_bloc.dart';
import 'package:Sabq/components/competition_card.dart';
import 'package:Sabq/components/empty-competition.dart';
import 'package:Sabq/components/stack-logo-header.dart';
import 'package:Sabq/models/competition.dart';
import 'package:Sabq/screens/competition-details/competition-details.dart';
import 'package:Sabq/utils/languages/translations_delegate_base.dart';
import 'package:Sabq/widgets/general.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JoinedCompetitionsScreen extends StatefulWidget {
  @override
  _JoinedCompetitionsScreenState createState() =>
      _JoinedCompetitionsScreenState();
}

class _JoinedCompetitionsScreenState extends State<JoinedCompetitionsScreen> {
  double _currentOpacity = 0;
  CompetitionBloc competitionBloc;
  openDetails(Competition competition) {
    Navigator.push(
        context,
        ScaleTransationRoute(
            page: CompetitionDetails(
          competition: competition,
        )));
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    await Future.delayed(Duration(milliseconds: 200));
    competitionBloc = Provider.of<CompetitionBloc>(context, listen: false);
    competitionBloc.getEnrolledCompetitions();
    setState(() => _currentOpacity = 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          StackLogoHeader(
            headerHeight: 150.0,
            logoWidth: 70.0,
            logoDistanceFromTop: 60.0,
            title: TranslationBase.of(context)
                .getStringLocaledByKey('JOINED_COMPETITIONS'),
            titleFontSize: 18.0,
            isTitleBold: false,
            isHaveLogoImg: false,
            isHaveBackButton: false,
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            top: 100.0,
            height: MediaQuery.of(context).size.height,
            child: Container(
              decoration: BoxDecoration(
                  color: Color(General.getColorHexFromStr('#FAFAFA')),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50.0),
                    topRight: Radius.circular(50.0),
                  )),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 115.0),
            height: MediaQuery.of(context).size.height,
            child: AnimatedOpacity(
              duration: Duration(seconds: 1),
              opacity: _currentOpacity,
              curve: Curves.easeIn,
              child: Container(
                child: Consumer<CompetitionBloc>(
                    builder: (BuildContext context, state, __) {
                  if (state.error != null) {
                    return Center(child: General.buildTxt(txt: state.error));
                  } else if (!state.waiting) {
                    return _enrolledCompetitionList(state);
                  } else {
                    return Center(
                        child: General.customThreeBounce(context,
                            color: Theme.of(context).primaryColor, size: 30.0));
                  }
                }),
              ),
            ),
          )
        ],
      ),
    );
  }

  _enrolledCompetitionList(CompetitionBloc state) {
    return state.enrolledcompetitions != null &&
            state.enrolledcompetitions.isNotEmpty
        ? ListView.builder(
            itemCount: state.enrolledcompetitions.length,
            padding: EdgeInsets.only(
                bottom: 20.0, left: 15.0, right: 15.0, top: 20.0),
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                  onTap: () => openDetails(state.enrolledcompetitions[index]),
                  child: CompetitionCard(
                    competition: state.enrolledcompetitions[index],
                  ));
            })
        : EmptyCompetition(
            text: TranslationBase.of(context)
                .getStringLocaledByKey('NO_JOINED_COMPETITIONS'),
          );
  }
}
