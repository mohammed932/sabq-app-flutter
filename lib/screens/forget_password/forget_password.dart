import 'dart:async';
import 'package:Sabq/blocs/authentication_bloc.dart';
import 'package:Sabq/components/email_field.dart';
import 'package:Sabq/components/round_buttton.dart';
import 'package:Sabq/components/stack-logo-header.dart';
import 'package:Sabq/utils/constants.dart';
import 'package:Sabq/utils/languages/translations_delegate_base.dart';
import 'package:Sabq/widgets/general.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForgetPasswordScreen extends StatefulWidget {
  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  double _curentOpacity = 0;
  TextEditingController _emailController = TextEditingController();
  FocusNode _emailFocus = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AuthenticationBloc authenticationBloc;
  _back() {
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    await Future.delayed(Duration(milliseconds: 200));
    authenticationBloc = Provider.of<AuthenticationBloc>(context);
    setState(() => _curentOpacity = 1);
  }

  _submit() {
    if (!_formKey.currentState.validate()) {
      return;
    } else {
      _formKey.currentState.save();
    }
    authenticationBloc.forgetPassword(
        context: context, email: _emailController.text);
  }

  @override
  Widget build(BuildContext context) {
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
              StackLogoHeader(
                headerHeight: 255.0,
                onPress: _back,
              ),
              Positioned(
                top: 210.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50.0),
                          topRight: Radius.circular(50.0),
                          bottomLeft: Radius.circular(50.0),
                          bottomRight: Radius.circular(50.0))),
                  child: AnimatedOpacity(
                    duration: Duration(seconds: 1),
                    opacity: _curentOpacity,
                    curve: Curves.linear,
                    child: Container(
                      padding: EdgeInsets.all(15.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            General.sizeBoxVerical(15.0),
                            General.buildTxt(
                                txt: TranslationBase.of(context)
                                    .getStringLocaledByKey('FORGOT_PASSWORD'),
                                fontSize: 20.0,
                                isBold: true,
                                color: Theme.of(context).primaryColor),
                            General.sizeBoxVerical(15.0),
                            EmailField(
                              controller: _emailController,
                              node: _emailFocus,
                            ),
                            General.sizeBoxVerical(30.0),
                            _submitBtn(),
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

  _submitBtn() {
    AuthenticationBloc authBloc = Provider.of<AuthenticationBloc>(context);
    return RoundButton(
      buttonTitle: !authBloc.isWaiting
          ? General.buildTxt(
              txt: TranslationBase.of(context)
                  .getStringLocaledByKey('RESET_PASSWORD'),
              color: Colors.white,
              fontSize: 16.0)
          : General.customThreeBounce(context),
      color: Constants.OrangeColor,
      disableColor: Constants.OrangeColor.withOpacity(0.6),
      onPress: !authBloc.isWaiting ? () => _submit() : null,
      roundVal: 100.0,
    );
  }
}
