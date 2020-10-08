import 'package:Sabq/animations/scale-transation-route.dart';
import 'package:Sabq/blocs/evaluation_bloc.dart';
import 'package:Sabq/components/evaluation_history_card.dart';
import 'package:Sabq/components/stack_normal_header.dart';
import 'package:Sabq/models/competition.dart';
import 'package:Sabq/models/evaluation_history.dart';
import 'package:Sabq/screens/judge/evaluation_result/evaluation_result.dart';
import 'package:Sabq/screens/judge/judge-competition-details/judge-competition-details.dart';
import 'package:Sabq/utils/global_functions.dart';
import 'package:Sabq/utils/languages/translations_delegate_base.dart';
import 'package:Sabq/widgets/general.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class EvaluationHistoryScreen extends StatefulWidget {
  @override
  _EvaluationHistoryScreenState createState() =>
      _EvaluationHistoryScreenState();
}

class _EvaluationHistoryScreenState extends State<EvaluationHistoryScreen> {
  double _currentOpacity = 0;
  num currentPage = 0;
  EvaluationBloc evaluationBloc;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  @override
  void initState() {
    init();
    super.initState();
  }

  openResult({EvaluationHistory evaluationHistory}) {
    Navigator.push(
        context,
        ScaleTransationRoute(
            page: EvaluationResultScreen(
          evaluationHistory: evaluationHistory,
        )));
  }

  init() async {
    await Future.delayed(Duration(milliseconds: 200));
    evaluationBloc = Provider.of<EvaluationBloc>(context, listen: false);
    evaluationBloc.evaluationHistory(page: currentPage);
    setState(() => _currentOpacity = 1);
  }

  openDetails(Competition competition) {
    Navigator.push(
        context,
        ScaleTransationRoute(
            page: JudgeCompetitionDetailsScreen(
          competition: competition,
        )));
  }

  _back() {
    Navigator.pop(context);
  }

  _onLoading(EvaluationBloc state) {
    currentPage += 1;
    if (currentPage < state.totalPages) {
      state.loadMoreNotification(page: currentPage);
      _refreshController.loadComplete();
    } else {
      _refreshController.loadNoData();
    }
  }

  _onRefresh() {
    currentPage = 0;
    evaluationBloc.evaluationHistory(page: currentPage);
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          StackNormalHeader(
              title: TranslationBase.of(context)
                  .getStringLocaledByKey('REVIEW_HISTORY'),
              onPress: _back),
          Positioned(
            left: 0.0,
            right: 0.0,
            top: 90.0,
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
          Positioned(
            left: 0.0,
            right: 0.0,
            top: 110.0,
            height: MediaQuery.of(context).size.height,
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 500),
              opacity: _currentOpacity,
              curve: Curves.easeIn,
              child: Container(
                child: Consumer<EvaluationBloc>(
                    builder: (BuildContext context, state, __) {
                  if (state.error != null) {
                    return Center(child: General.buildTxt(txt: state.error));
                  } else if (!state.waiting) {
                    return SmartRefresher(
                      controller: _refreshController,
                      enablePullDown: true,
                      enablePullUp: true,
                      header: WaterDropHeader(
                        waterDropColor: Colors.blueAccent,
                      ),
                      footer: GlobalFunctions.smartRefresherFooter(
                          endResultMsg: "No more evaluation history"),
                      onRefresh: _onRefresh,
                      onLoading: () => _onLoading(state),
                      child: ListView.builder(
                          itemCount: state.evaluationHistoryResponse
                              .evaluationHistoryList.length,
                          padding: EdgeInsets.only(
                              left: 15.0,
                              right: 15.0,
                              top: 20.0,
                              bottom: 100.0),
                          itemBuilder: (BuildContext context, int index) {
                            EvaluationHistory evaluationHistory = state
                                .evaluationHistoryResponse
                                .evaluationHistoryList[index];
                            return GestureDetector(
                                onTap: () => openResult(
                                    evaluationHistory: evaluationHistory),
                                child: EvaluationHistoryCard(
                                  evaluationHistory: evaluationHistory,
                                ));
                          }),
                    );
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
}
