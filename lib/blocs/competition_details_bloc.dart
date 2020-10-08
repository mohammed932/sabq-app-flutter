import 'dart:convert';
import 'dart:io';
import 'package:Sabq/animations/scale-transation-route.dart';
import 'package:Sabq/blocs/bloc_state.dart';
import 'package:Sabq/models/competition.dart';
import 'package:Sabq/models/competition_level.dart';
import 'package:Sabq/models/enrollment_status.dart';
import 'package:Sabq/models/participationLevel.dart';
import 'package:Sabq/models/user.dart';
import 'package:Sabq/screens/supscription-done/supscription-done.dart';
import 'package:Sabq/services/api.dart';
import 'package:Sabq/utils/shared_preference.dart';
import 'package:Sabq/widgets/general.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uploader/flutter_uploader.dart';

class CompetitionDetailsBloc extends GeneralBlocState {
  Competition _competition;
  bool _isWaiting = false;
  bool _waitingLevel = false;
  List<CompetitionLevel> _competitionLevels;
  EnrollmentStatus _enrollmentStatus;
  bool _isDialogueDismissed = false;
  int _progressIndicator = 0;
  String _uploadMediaTaskId;
  List<ParticipationLevel> _participationLevels;
  Competition get competition => _competition;
  List<CompetitionLevel> get competitionLevels => _competitionLevels;
  EnrollmentStatus get enrollmentStatus => _enrollmentStatus;
  bool get isDialogueDismissed => _isDialogueDismissed;
  int get progressIndicator => _progressIndicator;
  String get uploadMediaTaskId => _uploadMediaTaskId;
  bool get isWaiting => _isWaiting;
  bool get waitingLevel => _waitingLevel;
  List<ParticipationLevel> get participationLevels => _participationLevels;
  getCompetition({num id}) async {
    try {
      waiting = true;
      notifyListeners();
      User userData = await SharedPreferenceHandler.getuserData();
      if (userData.userInfo.type == 'COMPETITOR') {
        await getEnrollmentStatus(competitionId: id);
      }
      _competition = await Api().getCompetition(id: id);
      await getCompetitionLevels(compId: id);
      print('kk :${_competition.competitionLevels}');
      if (_competition.competitionLevels.isNotEmpty) {
        _competition.competitionLevels.first.isActive = true;
        await getLevelAttachments(
            levelId: _competition.competitionLevels.first.id);
      } else {
        print("hi moo");
        _participationLevels = [];
      }
      waiting = false;
      notifyListeners();
      setError(null);
    } catch (e) {
      waiting = false;
      notifyListeners();
      setError(e.toString());
      print("competition error :$e");
    }
  }

  getLevelAttachments({@required num levelId}) async {
    try {
      _waitingLevel = true;
      notifyListeners();
      _participationLevels =
          await getParticipationByGivenLevel(levelId: levelId);
      print('_participationLevels_participationLevels :$_participationLevels');
      _waitingLevel = false;
      notifyListeners();
    } catch (e) {
      _waitingLevel = false;
      notifyListeners();
      print('getLevelAttachments error :$e');
    }
  }

  enrollInCompetition({num competitionId}) async {
    try {
      _isWaiting = true;
      notifyListeners();
      await Api().enrollInCompetition(competitionId: competitionId);
      _isWaiting = false;
      notifyListeners();
    } catch (e) {
      _isWaiting = false;
      notifyListeners();
      print('enroll in competition error  :$e');
      throw e;
    }
  }

  getParticipationByGivenLevel({num levelId}) async {
    try {
      return await Api().getParticipationByGivenLevel(levelId: levelId);
    } catch (e) {
      print("getCompetitionLevels error :$e");
    }
  }

  getCompetitionLevels({num compId}) async {
    try {
      _competitionLevels =
          await Api().getCompetitionLevels(competitionId: compId);
    } catch (e) {
      print("getCompetitionLevels error :$e");
    }
  }

  getEnrollmentStatus({num competitionId}) async {
    try {
      _enrollmentStatus =
          await Api().checkEnrollmentStatus(competitionId: competitionId);
    } catch (e) {
      print("getEnrollmentStatus error :$e");
    }
  }

  uploadMedia({File file, BuildContext context, @required num fileType}) async {
    try {
      await Api().uploadMedia(
          file: file, url: "competitor/upload-attachment", context: context);
      final uploader = FlutterUploader();
      uploader.result.listen((result) async {
        Map<String, dynamic> responseJson = json.decode(result.response);
        print("json response : ${responseJson['path']}");
        if (!_enrollmentStatus.initialLevelStatus ||
            _enrollmentStatus.intialLevel == null) {
          await attachTempParticipation(
              filePath: responseJson['path'],
              context: context,
              fileType: fileType);
        } else {
          print("in level attach Participation");
          await attachLevelParticipation(
              filePath: responseJson['path'],
              context: context,
              fileType: fileType);
        }
      }, onError: (ex, stacktrace) {
        print("my result media err is :$ex");
        print('_isDialogueDismissed :$_isDialogueDismissed');
        if (!_isDialogueDismissed) {
          Navigator.pop(context);
          General.showDialogue(
              txtWidget: General.buildTxt(
                  txt: "صيغة المقطع المرفق غير مدعومة",
                  fontSize: 13.0,
                  lineHeight: 1.3),
              actionLabel: "Ok",
              context: context);
        }
      });
    } catch (e) {
      print("upload media file error :$e");
    }
  }

  attachLevelParticipation(
      {String filePath, BuildContext context, num fileType}) async {
    try {
      await Api().attachLevelParticipation(
          filePath: filePath,
          levelId: _competition.intailLevel,
          fileType: fileType);
      Navigator.pop(context);
      Navigator.push(context, ScaleTransationRoute(page: SupscriptionDone()));
    } catch (e) {
      Navigator.pop(context);
      General.showDialogue(
          txtWidget: General.buildTxt(
              txt: e.message.errors[0], fontSize: 13.0, lineHeight: 1.3),
          actionLabel: "Ok",
          context: context);
      print("attachTempParticipation err :$e");
    }
  }

  attachTempParticipation(
      {String filePath, BuildContext context, num fileType}) async {
    try {
      await Api().attachTempParticipation(
          filePath: filePath,
          competitionId: _competition.id,
          fileType: fileType);
      Navigator.pop(context);
      Navigator.push(context, ScaleTransationRoute(page: SupscriptionDone()));
    } catch (e) {
      Navigator.pop(context);
      General.showDialogue(
          txtWidget: General.buildTxt(
              txt: e.message.errors[0], fontSize: 13.0, lineHeight: 1.3),
          actionLabel: "Ok",
          context: context);
      print("attachTempParticipation err :$e");
    }
  }

  setIsDialogueDissmissed({bool val}) {
    _isDialogueDismissed = val;
    notifyListeners();
  }

  setProgressIndicator({int val}) {
    if (val == -1)
      _progressIndicator = 0;
    else
      _progressIndicator = val;
    notifyListeners();
  }

  setTaskId({String val}) {
    _uploadMediaTaskId = val;
    notifyListeners();
  }
}
