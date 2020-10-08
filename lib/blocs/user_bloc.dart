import 'dart:convert';
import 'dart:io';
import 'package:Sabq/animations/scale-transation-route.dart';
import 'package:Sabq/blocs/authentication_bloc.dart';
import 'package:Sabq/models/bank_account.dart';
import 'package:Sabq/models/user.dart';
import 'package:Sabq/screens/message_sent_successfully/message_sent_successfully.dart';
import 'package:Sabq/services/api.dart';
import 'package:Sabq/utils/shared_preference.dart';
import 'package:Sabq/widgets/general.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'bloc_state.dart';

class UserBloc extends GeneralBlocState {
  User _user;
  List<BankAccount> _bankAccounts;
  bool _isWaiting = false;
  String _imagePath;
  User get user => _user;
  bool get isWaiting => _isWaiting;
  List<BankAccount> get bankAccounts => _bankAccounts;
  setUser({User currentUser}) {
    _user = currentUser;
    notifyListeners();
  }

  getUserInfo() async {
    try {
      waiting = true;
      notifyListeners();
      _user = await Api().getUserData();
      waiting = false;
      notifyListeners();
    } catch (e) {
      waiting = false;
      notifyListeners();
      print("profile info err :$e");
    }
  }

  getBankAccountInfo() async {
    try {
      waiting = true;
      notifyListeners();
      _bankAccounts = await Api().getBankAccounts();
      waiting = false;
      notifyListeners();
    } catch (e) {
      waiting = false;
      notifyListeners();
      print("bank info err :$e");
    }
  }

  uploadProfileImage({File image}) async {
    try {
      Map response = await Api().multipartRequest(
          file: image,
          fileKey: "file",
          method: "POST",
          url: "uploud?type=image");
      _imagePath = response['path'];
      print("image path is :$_imagePath");
    } catch (e) {
      print("upload image file error :$e");
    }
  }

  updateUserProfile({BuildContext context}) async {
    AuthenticationBloc authenticationBloc =
        Provider.of<AuthenticationBloc>(context, listen: false);
    try {
      _isWaiting = true;
      notifyListeners();
      if (_imagePath != null) {
        authenticationBloc.createAccount.image = _imagePath;
      }
      print("json data is :${jsonEncode(authenticationBloc.createAccount)}");
      _user = await Api()
          .updateUserProfile(params: authenticationBloc.createAccount);
      General.showToast(txt: "تم تعديل البيانات بنجاح");
      setUser(currentUser: _user);
      await SharedPreferenceHandler.setUserData(user);
      Navigator.pop(context);
      _isWaiting = false;
      notifyListeners();
    } catch (e) {
      _isWaiting = false;
      notifyListeners();
      print("update user error :$e");
    }
  }

  editBankAccountInfo(
      {BuildContext context,
      String bankName,
      String accountNumber,
      String ibanNumber}) async {
    try {
      _isWaiting = true;
      notifyListeners();
      await Api().editBankAccountInfo(
          accountNumber: accountNumber,
          bankName: bankName,
          accountId: _bankAccounts[0].id,
          ibanNumber: ibanNumber);
      _isWaiting = false;
      General.showDialogue(
              txtWidget: General.buildTxt(
                  txt: "تم تعديل المعلومات البنكية بنجاح",
                  fontSize: 13.0,
                  lineHeight: 1.3),
              actionLabel: "Ok",
              context: context)
          .then((value) => Navigator.pop(context));
      notifyListeners();
    } catch (e) {
      print("bank info error: $e");
      _isWaiting = false;
      notifyListeners();
      General.showDialogue(
          txtWidget: General.buildTxt(
              txt: e.message.errors[0], fontSize: 13.0, lineHeight: 1.3),
          context: context);
    }
  }

  addBankAccountInfo(
      {BuildContext context,
      String bankName,
      String accountNumber,
      String ibanNumber}) async {
    try {
      UserBloc userBloc = Provider.of<UserBloc>(context);
      _isWaiting = true;
      notifyListeners();
      BankAccount bankAccount = await Api().addBankAccountInfo(
          accountNumber: accountNumber,
          bankName: bankName,
          ibanNumber: ibanNumber);
      userBloc.user.userInfo.bankAccounts.add(bankAccount);
      General.showDialogue(
              txtWidget: General.buildTxt(
                  txt: "تم اضافة المعلومات البنكية بنجاح",
                  fontSize: 13.0,
                  lineHeight: 1.3),
              actionLabel: "Ok",
              context: context)
          .then((value) => Navigator.pop(context));
      _isWaiting = false;
      notifyListeners();
    } catch (e) {
      print("bank info : $e");
      _isWaiting = false;
      notifyListeners();
      General.showDialogue(
          txtWidget: General.buildTxt(
              txt: e.message.errors[0], fontSize: 13.0, lineHeight: 1.3),
          context: context);
    }
  }

  contactUs({String msg, String subject, BuildContext context}) async {
    try {
      _isWaiting = true;
      notifyListeners();
      await Api().contactUs(message: msg, subject: subject);
      Navigator.push(
          context, ScaleTransationRoute(page: MessageSentSuccessfullyScreen()));
      _isWaiting = false;
      notifyListeners();
    } catch (e) {
      _isWaiting = false;
      notifyListeners();
      print("contact us error :$e");
    }
  }
}
