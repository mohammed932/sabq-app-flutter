import 'dart:convert';
import 'dart:io';

import 'package:Sabq/animations/scale-transation-route.dart';
import 'package:Sabq/blocs/user_bloc.dart';
import 'package:Sabq/models/create_account.dart';
import 'package:Sabq/models/user.dart';
import 'package:Sabq/screens/judge/judge-tabs/judge-tabs.dart';
import 'package:Sabq/screens/registration_success/registration_success.dart';
import 'package:Sabq/screens/tabs/tabs.dart';
import 'package:Sabq/screens/verfication_code.dart/verfication_code.dart';
import 'package:Sabq/services/api.dart';
import 'package:Sabq/utils/global_functions.dart';
import 'package:Sabq/utils/languages/translations_delegate_base.dart';
import 'package:Sabq/utils/shared_preference.dart';
import 'package:Sabq/widgets/general.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:provider/provider.dart';
import 'bloc_state.dart';

class AuthenticationBloc extends GeneralBlocState {
  bool _isWaiting = false;
  String _uploadCvTaskId;
  String _cvPath;
  CreateAccount _createAccount;
  CreateAccount get createAccount => _createAccount;
  bool get isWaiting => _isWaiting;
  String get uploadCvTaskId => _uploadCvTaskId;
  String get cvPath => _cvPath;
  setUserData({CreateAccount data}) {
    _createAccount = data;
    notifyListeners();
  }

  login({BuildContext context, String email, String password}) async {
    UserBloc userBloc = Provider.of<UserBloc>(context, listen: false);
    try {
      _isWaiting = true;
      notifyListeners();
      User user = await Api().login(email: email, password: password);
      userBloc.setUser(currentUser: user);
      _isWaiting = false;
      notifyListeners();

      if (user.userInfo.type == "JUDGE") {
        if (user.userInfo.status == "PENDING") {
          General.showDialogue(
              txtWidget: General.buildTxt(
                  lineHeight: 1.5,
                  txt: TranslationBase.of(context).getStringLocaledByKey(
                    'MANAGMENT_MUST_APPROVED_FIRST',
                  )),
              context: context);
        } else {
          await SharedPreferenceHandler.setUserData(user);

          Navigator.pushAndRemoveUntil(
              context,
              ScaleTransationRoute(page: JudgeTabsScreen()),
              (Route<dynamic> route) => false);
        }
      } else {
        if (user.userInfo.status == "PENDING") {
          General.showDialogue(
                  txtWidget: General.buildTxt(
                      txt: TranslationBase.of(context).getStringLocaledByKey(
                        'WE_SENT_ACTIVATION_CODE_TO_UR_EMAIL',
                      ),
                      lineHeight: 1.5),
                  actionLabel: "Ok",
                  context: context)
              .then((value) {
            Navigator.push(
                context, ScaleTransationRoute(page: VerficationCodeScreen()));
          });
        } else if (user.userInfo.status == "APPROVED") {
          await SharedPreferenceHandler.setUserData(user);
          Navigator.pushAndRemoveUntil(
              context,
              ScaleTransationRoute(page: TabsScreen()),
              (Route<dynamic> route) => false);
        }
      }
    } catch (e) {
      _isWaiting = false;
      notifyListeners();
      General.showDialogue(
          txtWidget: General.buildTxt(
              txt: e.message.errors[0], fontSize: 13.0, lineHeight: 1.3),
          context: context);
      print("login error :$e");
    }
  }

  forgetPassword({BuildContext context, String email}) async {
    try {
      _isWaiting = true;
      notifyListeners();
      await Api().forgetPassword(email: email);
      _isWaiting = false;
      notifyListeners();
      General.showDialogue(
              txtWidget: General.buildTxt(
                  txt: "تم ارسال الرقم السري الجديد الي الايميل الخاص بك",
                  fontSize: 13.0,
                  lineHeight: 1.3),
              context: context)
          .then((value) => Navigator.pop(context));
    } catch (e) {
      _isWaiting = false;
      notifyListeners();
      General.showDialogue(
          txtWidget: General.buildTxt(
              txt: e.message.errors[0], fontSize: 13.0, lineHeight: 1.3),
          context: context);
      print("forget password error :$e");
    }
  }

  changePassword(
      {BuildContext context,
      String oldPassword,
      String newPassword,
      String confirmNewPassword}) async {
    try {
      _isWaiting = true;
      notifyListeners();
      await Api().changePassword(
          oldPassword: oldPassword,
          newPassword: newPassword,
          confirmNewPassword: confirmNewPassword);
      _isWaiting = false;
      notifyListeners();
      General.showDialogue(
              txtWidget: General.buildTxt(
                  txt: TranslationBase.of(context)
                      .getStringLocaledByKey('PASSWORD_CHANGED_SUCCESSFULLY'),
                  fontSize: 13.0,
                  lineHeight: 1.3),
              actionLabel: "Ok",
              context: context)
          .then((value) => GlobalFunctions.logout(context: context));
    } catch (e) {
      _isWaiting = false;
      notifyListeners();
      General.showDialogue(
          txtWidget: General.buildTxt(
              txt: e.message.errors[0], fontSize: 13.0, lineHeight: 1.3),
          context: context);
      print("change password error :$e");
    }
  }

  register({CreateAccount data, BuildContext context}) async {
    UserBloc userBloc = Provider.of<UserBloc>(context, listen: false);
    try {
      _isWaiting = true;
      notifyListeners();
      if (userBloc.user.userInfo.type == "JUDGE") {
        User user = await Api().registration(params: data);
        General.showDialogue(
                txtWidget: General.buildTxt(
                    txt: 'شكرا ${user.userInfo.firstName} لقد تم التسجيل بنجاح',
                    fontSize: 13.0,
                    lineHeight: 1.3),
                actionLabel: "Ok",
                context: context)
            .then((__) {
          Navigator.push(
              context, ScaleTransationRoute(page: RegistationSuccessScreen()));
        });
        print("register judge user :$user");
      } else {
        String response = await Api().registration(params: data);
        General.showDialogue(
                txtWidget: General.buildTxt(
                    txt: response, fontSize: 13.0, lineHeight: 1.3),
                actionLabel: "Ok",
                context: context)
            .then((__) {
          Navigator.push(
              context, ScaleTransationRoute(page: VerficationCodeScreen()));
        });
      }

      _isWaiting = false;
      notifyListeners();
    } catch (e) {
      _isWaiting = false;
      notifyListeners();
      print("register err : $e");
      List<dynamic> errors = e.message.errors;
      Widget err = Column(
        children: errors.map<Widget>((err) {
          return Container(
            margin: EdgeInsets.only(bottom: 5.0),
            child: General.buildTxt(txt: err, fontSize: 13.0, lineHeight: 1.5),
          );
        }).toList(),
      );
      General.showDialogue(txtWidget: err, context: context);
    }
  }

  uploadCv({File file, BuildContext context}) async {
    try {
      await Api().uploadMedia(
          file: file, url: "uploud?type=document", context: context);
      final FlutterUploader uploader = FlutterUploader();
      uploader.result.listen((result) async {
        Map<String, dynamic> responseJson = json.decode(result.response);
        _cvPath = responseJson['path'];
        print("json response asd: ${responseJson['path']}");
      }, onError: (ex, stacktrace) {
        print("my result cv err is :$ex");
      });
    } catch (e) {
      print("upload cv file error :$e");
    }
  }

  setTaskId({String val}) {
    _uploadCvTaskId = val;
    notifyListeners();
  }

  verifyAccount({String code, BuildContext context}) async {
    try {
      UserBloc userBloc = Provider.of<UserBloc>(context, listen: false);
      General.showLoadingDialog(context);
      User user = await Api().verify(code: code, email: _createAccount.email);
      userBloc.setUser(currentUser: user);
      SharedPreferenceHandler.setUserData(user);
      General.dismissLoadingDialog(context);
      Navigator.pushAndRemoveUntil(
          context,
          ScaleTransationRoute(page: TabsScreen()),
          (Route<dynamic> route) => false);
    } catch (e) {
      print("verification error :$e");
      General.dismissLoadingDialog(context);
      General.showDialogue(
          txtWidget: General.buildTxt(
              txt: e.message.errors[0], fontSize: 13.0, lineHeight: 1.3),
          context: context);
    }
  }

  resend({String email, BuildContext context}) async {
    try {
      General.showLoadingDialog(context);
      await Api().resend(email: email);
      General.showToast(
          txt: TranslationBase.of(context)
              .getStringLocaledByKey('WE_SENT_ACTIVATION_CODE_TO_UR_EMAIL'));
      General.dismissLoadingDialog(context);
    } catch (e) {
      print("resend error :$e");
      General.dismissLoadingDialog(context);
      General.showDialogue(
          txtWidget: General.buildTxt(
              txt: e.message.message, fontSize: 13.0, lineHeight: 1.3),
          context: context);
    }
  }
}
