import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:Sabq/blocs/authentication_bloc.dart';
import 'package:Sabq/blocs/localization_bloc.dart';
import 'package:Sabq/blocs/user_bloc.dart';
import 'package:Sabq/components/email_field.dart';
import 'package:Sabq/components/round_buttton.dart';
import 'package:Sabq/components/select_country.dart';
import 'package:Sabq/components/select_gender.dart';
import 'package:Sabq/utils/constants.dart';
import 'package:Sabq/utils/languages/translations_delegate_base.dart';
import 'package:Sabq/widgets/general.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:path/path.dart' as path;
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class RegistrationSecondStepScreen extends StatefulWidget {
  @override
  _RegistrationSecondStepScreenState createState() =>
      _RegistrationSecondStepScreenState();
}

class _RegistrationSecondStepScreenState
    extends State<RegistrationSecondStepScreen> {
  double _curentOpacity = 0;
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  FocusNode _emailFocus = FocusNode();

  FocusNode _mobileFocus = FocusNode();
  PhoneNumber phoneNumber = PhoneNumber(isoCode: 'SA');
  String mobile = '';
  File _file;
  num uploadProgress = 0;
  String selectedValueSingleDialog = '';
  final FlutterUploader uploader = FlutterUploader();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  _back() {
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    await Future.delayed(Duration(milliseconds: 500));
    initProgress();
    setState(() => _curentOpacity = 1);
  }

  initProgress() {
    uploader.progress.listen((progress) {
      print("my progress is :${progress.progress}");
      if (mounted) {
        setState(() {
          uploadProgress = progress.progress;
        });
      }
    });
  }

  @override
  void dispose() {
    uploader.cancelAll();
    super.dispose();
  }

  _cancelUpload() {
    AuthenticationBloc authBloc = Provider.of<AuthenticationBloc>(context);
    uploader.cancel(taskId: authBloc.uploadCvTaskId);
    _file = null;
    setState(() {});
  }

  _next(UserBloc userBloc) {
    if (!_formKey.currentState.validate()) {
      return;
    } else {
      _formKey.currentState.save();
    }

    AuthenticationBloc authenticationBloc =
        Provider.of<AuthenticationBloc>(context, listen: false);
    UserBloc userBloc = Provider.of<UserBloc>(context, listen: false);
    if (userBloc.user.userInfo.type == "JUDGE" && _file == null) {
      General.showDialogue(
          txtWidget: General.buildTxt(
              txt: TranslationBase.of(context)
                  .getStringLocaledByKey('U_MUST_UPLOAD_CV_FIRST'),
              fontSize: 13.0,
              lineHeight: 1.3),
          context: context);
      return;
    }
    if (authenticationBloc.createAccount.gender == null) {
      General.showDialogue(
          txtWidget: General.buildTxt(
              txt: TranslationBase.of(context)
                  .getStringLocaledByKey('GENDER_TYPE_REQUIRED'),
              fontSize: 13.0,
              lineHeight: 1.3),
          context: context);
      return;
    } else if (authenticationBloc.createAccount.country == null) {
      General.showDialogue(
          txtWidget: General.buildTxt(
              txt: TranslationBase.of(context)
                  .getStringLocaledByKey('COUNTRY_REQUIRED'),
              fontSize: 13.0,
              lineHeight: 1.3),
          context: context);
      return;
    } else {
      authenticationBloc.createAccount.country =
          authenticationBloc.createAccount.country;
      authenticationBloc.createAccount.cv = authenticationBloc.cvPath;
      authenticationBloc.createAccount.email =
          _emailController.text.replaceAll(new RegExp(r"\s+"), "");
      authenticationBloc.createAccount.phone = mobile;
      authenticationBloc.register(
          data: authenticationBloc.createAccount, context: context);
      print("json data is :${jsonEncode(authenticationBloc.createAccount)}");
    }
  }

  _uploadCv() async {
    AuthenticationBloc authenticationBloc =
        Provider.of<AuthenticationBloc>(context, listen: false);
    try {
      _file = await FilePicker.getFile(
          type: FileType.custom, allowedExtensions: ['pdf', 'doc', 'docx']);
      if (_file.lengthSync() / 1000 >= 2000) {
        General.showDialogue(
            txtWidget: General.buildTxt(
                txt: TranslationBase.of(context)
                    .getStringLocaledByKey('MAX_SIZE_2_MEGA')),
            context: context);
      } else {
        authenticationBloc.uploadCv(file: _file, context: context);
        setState(() {});
        print('selected file is :$_file');
      }
    } catch (e) {
      print('file picker error :$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    UserBloc userBloc = Provider.of<UserBloc>(context, listen: false);
    AuthenticationBloc authenticationBloc =
        Provider.of<AuthenticationBloc>(context);
    LocalizationBloc localizationBloc = Provider.of<LocalizationBloc>(context);
    return Scaffold(
      backgroundColor: Color(General.getColorHexFromStr('#FAFAFA')),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          child: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Positioned(
                left: 0.0,
                right: 0.0,
                child: Container(
                  color: Theme.of(context).primaryColor,
                  height: 255.0,
                  child: Column(
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
                      Center(
                        child: Image.asset(
                          "assets/imgs/logo.png",
                          width: 170.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 210.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50.0),
                        topRight: Radius.circular(50.0),
                        bottomLeft: Radius.circular(50.0),
                        bottomRight: Radius.circular(50.0))),
                child: Form(
                  key: _formKey,
                  child: AnimatedOpacity(
                    duration: Duration(seconds: 1),
                    opacity: _curentOpacity,
                    curve: Curves.linear,
                    child: SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            General.sizeBoxVerical(15.0),
                            General.buildTxt(
                                txt: TranslationBase.of(context)
                                    .getStringLocaledByKey('CREATE_ACCOUNT'),
                                fontSize: 22.0,
                                isBold: true,
                                color: Theme.of(context).primaryColor),
                            General.sizeBoxVerical(15.0),
                            SelectCountry(),
                            General.sizeBoxVerical(15.0),
                            SelectGender(),
                            General.sizeBoxVerical(15.0),
                            EmailField(
                              controller: _emailController,
                              node: _emailFocus,
                              nextFocusNode: _mobileFocus,
                            ),
                            General.sizeBoxVerical(15.0),
                            Container(
                              child: InternationalPhoneNumberInput(
                                onInputChanged: (PhoneNumber number) {
                                  print(number.phoneNumber);
                                  mobile = number.phoneNumber;
                                },
                                onInputValidated: (bool value) {
                                  // print("kk  :$value");
                                },
                                focusNode: _mobileFocus,
                                ignoreBlank: false,
                                selectorTextStyle:
                                    TextStyle(color: Colors.black),
                                initialValue: phoneNumber,
                                textFieldController: _mobileController,
                                errorMessage: TranslationBase.of(context)
                                    .getStringLocaledByKey('NOT_VALID_PHONE'),
                                formatInput: true,
                                hintText:
                                    localizationBloc.appLocal.languageCode ==
                                            "ar"
                                        ? "رقم الجوال"
                                        : "phone number",
                                locale: "en",
                              ),
                            ),
                            userBloc.user.userInfo.type == "JUDGE"
                                ? _uploadCvSection()
                                : Container(),
                            General.sizeBoxVerical(20.0),
                            RoundButton(
                              buttonTitle: !authenticationBloc.isWaiting
                                  ? General.buildTxt(
                                      txt: TranslationBase.of(context)
                                          .getStringLocaledByKey('CONTINUE'),
                                      color: Colors.white,
                                      isBold: true,
                                      fontSize: 16.0)
                                  : General.customThreeBounce(context),
                              color: Constants.OrangeColor,
                              disableColor:
                                  Constants.OrangeColor.withOpacity(0.6),
                              onPress: !authenticationBloc.isWaiting
                                  ? () => _next(userBloc)
                                  : null,
                              roundVal: 100.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _uploadCvSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        General.sizeBoxVerical(30.0),
        Text.rich(
          TextSpan(
            text:
                TranslationBase.of(context).getStringLocaledByKey('UPLOAD_CV'),
            children: <InlineSpan>[
              TextSpan(
                text: ' *',
                style: TextStyle(color: Colors.red),
              ),
            ],
            style: TextStyle(color: Colors.grey, fontSize: 16.0),
          ),
        ),
        General.sizeBoxVerical(10.0),
        General.buildTxt(
            txt: TranslationBase.of(context)
                .getStringLocaledByKey('PLS_UPLOAD_PDF_OR_WORD_FILE'),
            isCenter: false,
            fontSize: 12.0,
            color: Theme.of(context).primaryColor),
        General.sizeBoxVerical(6.0),
        General.buildTxt(
            txt: TranslationBase.of(context)
                .getStringLocaledByKey('MAX_SIZE_2_MEGA'),
            isCenter: false,
            fontSize: 12.0,
            color: Theme.of(context).primaryColor),
        General.sizeBoxVerical(15.0),
        _file == null
            ? GestureDetector(
                onTap: _uploadCv,
                child: DottedBorder(
                  color: Constants.OrangeColor,
                  strokeWidth: 1,
                  radius: Radius.circular(5.0),
                  strokeCap: StrokeCap.butt,
                  borderType: BorderType.RRect,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(15.0),
                    child: General.buildTxt(
                      txt: TranslationBase.of(context)
                          .getStringLocaledByKey('UPLOAD_FILE'),
                      fontSize: 14.0,
                      isBold: true,
                      color: Constants.OrangeColor,
                    ),
                  ),
                ),
              )
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: LinearPercentIndicator(
                  lineHeight: 16.0,
                  leading: _file != null
                      ? Container(
                          padding: EdgeInsets.only(left: 10.0),
                          child: General.buildTxt(txt: "$uploadProgress%"),
                        )
                      : null,
                  trailing: _file != null
                      ? IconButton(
                          icon: Icon(Icons.close), onPressed: _cancelUpload)
                      : null,
                  percent: uploadProgress / 100,
                  backgroundColor: Color(General.getColorHexFromStr('#B4B4B4')),
                  progressColor: Constants.OrangeColor,
                ),
              ),
        _file != null
            ? General.buildTxt(txt: path.basename(_file.path))
            : Container()
      ],
    );
  }
}
