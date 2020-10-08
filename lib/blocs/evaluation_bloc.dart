import 'dart:async';

import 'package:Sabq/blocs/bloc_state.dart';
import 'package:Sabq/models/evaluation_history_response.dart';
import 'package:Sabq/models/random_participation.dart';
import 'package:Sabq/models/rate_participation.dart';
import 'package:Sabq/models/test.dart';
import 'package:Sabq/services/api.dart';
import 'package:Sabq/widgets/general.dart';
import 'package:flutter/material.dart';

class EvaluationBloc extends GeneralBlocState {
  num _totalPages;
  RandomParticipation _randomParticipation;
  List<Test> _levelTests;
  String _stopwatchTimePreview = "00:00:00";
  Timer _timer;
  bool _isWaiting = false;
  EvaluationHistoryResponse _evaluationHistoryResponse;
  num get totalPages => _totalPages;
  List<Test> get levelTests => _levelTests;
  RandomParticipation get randomParticipation => _randomParticipation;
  EvaluationHistoryResponse get evaluationHistoryResponse =>
      _evaluationHistoryResponse;
  String get stopwatchTimePreview => _stopwatchTimePreview;
  Timer get timer => _timer;
  bool get isWaiting => _isWaiting;
  Stopwatch stopwatch = Stopwatch();
  var oneSec = const Duration(seconds: 1);
  randomPart({num levelId}) async {
    return await Api().getRandomParticipationToEvaluate(levelId: levelId);
  }

  getLevelTests({num levelId}) async {
    try {
      hasData = false;
      notifyListeners();
      _levelTests = await Api().getLevelTests(levelId: levelId);
      _randomParticipation = await randomPart(levelId: levelId);
      hasData = true;
      setError(null);
      notifyListeners();
    } catch (e) {
      setError(e.message);
      hasData = false;
      notifyListeners();
      print("getRandomParticipationToEvaluate error :$e");
    }
  }

  resetStopwatchTimePreview() {
    _stopwatchTimePreview = "00:00:00";
    notifyListeners();
  }

  evaluationHistory({num page = 1}) async {
    try {
      waiting = true;
      notifyListeners();
      _evaluationHistoryResponse =
          await _loadEvaluationHistory(currentPage: page);
      _totalPages = _evaluationHistoryResponse.totalPages;
      waiting = false;
      notifyListeners();
      setError(null);
    } catch (e) {
      waiting = false;
      notifyListeners();
      setError(e.toString());
      print("evaluationHistoryResponse error :$e");
    }
  }

  rateParticipation({RateParticipation params, BuildContext context}) async {
    try {
      _isWaiting = true;
      notifyListeners();
      await Api().rateParticipation(params: params);
      General.showDialogue(
              actionLabel: "Ok",
              txtWidget: General.buildTxt(
                txt: "تم التقييم بنجاح",
              ),
              context: context)
          .then((value) => Navigator.pop(context));
      _timer.cancel();
      stopwatch.reset();
      _isWaiting = false;
      notifyListeners();
    } catch (e) {
      _isWaiting = false;
      notifyListeners();
      General.showDialogue(
          txtWidget: General.buildTxt(
              txt: e.message.errors[0], fontSize: 13.0, lineHeight: 1.3),
          actionLabel: "Ok",
          context: context);
      print("rateParticipation error :$e");
    }
  }

  loadMoreNotification({page}) async {
    EvaluationHistoryResponse response =
        await _loadEvaluationHistory(currentPage: page);
    _evaluationHistoryResponse.evaluationHistoryList
        .addAll(response.evaluationHistoryList);
    notifyListeners();
  }

  _loadEvaluationHistory({currentPage}) async {
    return await Api().getEvaluationHistory(page: currentPage);
  }

  startTimer() {
    _timer = Timer(
      oneSec,
      keepRunning,
    );
    stopwatch.start();
    notifyListeners();
  }

  keepRunning() {
    if (stopwatch.isRunning) {
      startTimer();
    }
    startStopWatch();
    notifyListeners();
  }

  startStopWatch() {
    _stopwatchTimePreview =
        (stopwatch.elapsed.inHours).toString().padLeft(2, "0") +
            ":" +
            (stopwatch.elapsed.inMinutes % 60).toString().padLeft(2, "0") +
            ":" +
            (stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, "0");
    notifyListeners();
  }

  pauseStopWatch() {
    stopwatch.stop();
    notifyListeners();
  }
}
