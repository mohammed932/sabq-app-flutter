import 'dart:async';
import 'package:Sabq/blocs/authentication_bloc.dart';
import 'package:Sabq/blocs/user_bloc.dart';
import 'package:Sabq/components/stack-logo-header.dart';
import 'package:Sabq/utils/languages/translations_delegate_base.dart';
import 'package:Sabq/widgets/general.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class VerficationCodeScreen extends StatefulWidget {
  @override
  _VerficationCodeScreenState createState() => _VerficationCodeScreenState();
}

class _VerficationCodeScreenState extends State<VerficationCodeScreen> {
  double _curentOpacity = 0;
  String currentText = "";
  StreamController<ErrorAnimationType> errorController;
  TextEditingController textEditingController = TextEditingController();
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
    errorController = StreamController<ErrorAnimationType>();
    await Future.delayed(Duration(milliseconds: 200));
    setState(() => _curentOpacity = 1);
  }

  _resend() {
    print("adsf");
    AuthenticationBloc authBloc =
        Provider.of<AuthenticationBloc>(context, listen: false);
    authBloc.resend(email: authBloc.createAccount.email, context: context);
  }

  @override
  void dispose() {
    errorController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationBloc authenticationBloc =
        Provider.of<AuthenticationBloc>(context);
    UserBloc userBloc = Provider.of<UserBloc>(context);
    return Scaffold(
      backgroundColor: Color(General.getColorHexFromStr('#FAFAFA')),
      body: Container(
        child: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            StackLogoHeader(
              onPress: _back,
            ),
            Wrap(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 210.0),
                  padding: EdgeInsets.all(20.0),
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
                      child: Container(
                        padding: EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            General.sizeBoxVerical(15.0),
                            General.buildTxt(
                                txt: TranslationBase.of(context)
                                    .getStringLocaledByKey('VERFICATION_CODE'),
                                fontSize: 22.0,
                                isBold: true,
                                color: Theme.of(context).primaryColor),
                            General.sizeBoxVerical(15.0),
                            General.buildTxt(
                                txt: TranslationBase.of(context)
                                    .getStringLocaledByKey(
                                        'WE_HAVE_SENT_EMAIL_ON'),
                                fontSize: 12.0,
                                lineHeight: 1.3,
                                color: Colors.black38),
                            General.sizeBoxVerical(5.0),
                            General.buildTxt(
                                txt: authenticationBloc.createAccount != null
                                    ? authenticationBloc.createAccount.email
                                    : userBloc.user.userInfo.email,
                                fontSize: 12.0,
                                lineHeight: 1.3,
                                color: Colors.black38),
                            General.sizeBoxVerical(5.0),
                            General.buildTxt(
                                txt: TranslationBase.of(context)
                                    .getStringLocaledByKey(
                                        'WITH_VERFICATION_CODE_WHICH_COMPROMISE_OF_FOUR_DIGITS'),
                                fontSize: 12.0,
                                lineHeight: 1.3,
                                color: Colors.black38),
                            General.sizeBoxVerical(5.0),
                            Container(
                              alignment: Alignment.center,
                              child: GestureDetector(
                                onTap: _resend,
                                child: RichText(
                                    text: TextSpan(
                                        text: TranslationBase.of(context)
                                            .getStringLocaledByKey(
                                                'NOT_GET_CODE'),
                                        style: TextStyle(
                                            fontSize: 16.0, color: Colors.grey),
                                        children: [
                                      TextSpan(
                                          text: TranslationBase.of(context)
                                              .getStringLocaledByKey('RESEND'),
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color:
                                                Theme.of(context).primaryColor,
                                          )),
                                    ])),
                              ),
                            ),
                            General.sizeBoxVerical(30.0),
                            _pinCodeWidget(),
                            // General.sizeBoxVerical(30.0),
                            // RoundButton(
                            //   buttonTitle: General.buildTxt(
                            //       txt: "تأكيد",
                            //       color: Colors.white,
                            //       isBold: true,
                            //       fontSize: 16.0),
                            //   color: Constants.OrangeColor,
                            //   onPress: _next,
                            //   roundVal: 100.0,
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Positioned(
            //   // margin: EdgeInsets.only(top: 500.0),
            //   left: 0.0,
            //   right: 0.0,
            //   top: 600.0,
            //   child: Center(
            //     child: GestureDetector(
            //       onTap: _resend,
            //       child: RichText(
            //           text: TextSpan(
            //               text: TranslationBase.of(context)
            //                   .getStringLocaledByKey('NOT_GET_CODE'),
            //               style: TextStyle(fontSize: 16.0, color: Colors.grey),
            //               children: [
            //             TextSpan(
            //                 text: TranslationBase.of(context)
            //                     .getStringLocaledByKey('RESEND'),
            //                 style: TextStyle(
            //                   fontSize: 16.0,
            //                   color: Theme.of(context).primaryColor,
            //                 )),
            //           ])),
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  _pinCodeWidget() {
    AuthenticationBloc authenticationBloc =
        Provider.of<AuthenticationBloc>(context);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        child: PinCodeTextField(
          length: 4,
          obsecureText: false,
          autoFocus: true,
          textInputType: TextInputType.number,
          animationType: AnimationType.fade,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(5),
            fieldHeight: 50,
            fieldWidth: 40,
            activeFillColor: Colors.white,
          ),
          animationDuration: Duration(milliseconds: 300),
          errorAnimationController: errorController,
          controller: textEditingController,
          onCompleted: (val) {
            authenticationBloc.verifyAccount(code: val, context: context);
            print("Completed $val");
          },
          onChanged: (value) {
            setState(() => currentText = value);
          },
          beforeTextPaste: (text) {
            print("Allowing to paste $text");
            //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
            //but you can show anything you want here, like your pop up saying wrong paste format or etc
            return true;
          },
        ),
      ),
    );
  }
}
