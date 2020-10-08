import 'package:Sabq/animations/scale-transation-route.dart';
import 'package:Sabq/blocs/authentication_bloc.dart';
import 'package:Sabq/blocs/general_bloc.dart';
import 'package:Sabq/blocs/localization_bloc.dart';
import 'package:Sabq/components/email_field.dart';
import 'package:Sabq/components/password_field.dart';
import 'package:Sabq/components/round_buttton.dart';
import 'package:Sabq/screens/forget_password/forget_password.dart';
import 'package:Sabq/utils/constants.dart';
import 'package:Sabq/utils/languages/translations_delegate_base.dart';
import 'package:Sabq/widgets/general.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  double _curentOpacity = 0;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  FocusNode _passwordFocus = FocusNode();
  FocusNode _emailFocus = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _openCreateAccountScreen() {
    GenenralBloc genenralBloc =
        Provider.of<GenenralBloc>(context, listen: false);
    genenralBloc.setIsCreateNewAccountButtonPressed(status: true);
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    await Future.delayed(Duration(milliseconds: 200));
    setState(() => _curentOpacity = 1);
  }

  _login() {
    AuthenticationBloc authenticationBloc =
        Provider.of<AuthenticationBloc>(context, listen: false);
    if (!_formKey.currentState.validate()) {
      return;
    } else {
      _formKey.currentState.save();
    }
    print('email : ${_emailController.text}');
    print('pass : ${_passwordController.text}');
    authenticationBloc.login(
        context: context,
        email: _emailController.text.replaceAll(new RegExp(r"\s+"), ""),
        password: _passwordController.text);
  }

  _openForgetPasswordScreen() {
    Navigator.push(context, ScaleTransationRoute(page: ForgetPasswordScreen()));
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationBloc authenticationBloc =
        Provider.of<AuthenticationBloc>(context);
    return Container(
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Container(
              // top: 250.0,
              // left: 0.0,
              // right: 0.0,
              margin: EdgeInsets.only(top: 250.0),
              height: MediaQuery.of(context).size.height,
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
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.all(15.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            General.sizeBoxVerical(20.0),
                            General.buildTxt(
                                txt: TranslationBase.of(context)
                                    .getStringLocaledByKey('LOGIN'),
                                fontSize: 20.0,
                                isBold: true,
                                color: Theme.of(context).primaryColor),
                            EmailField(
                              controller: _emailController,
                              node: _emailFocus,
                              nextFocusNode: _passwordFocus,
                            ),
                            General.sizeBoxVerical(20.0),
                            PasswordField(
                              controller: _passwordController,
                              node: _passwordFocus,
                              validation: TranslationBase.of(context)
                                  .getStringLocaledByKey('PASSWORD_REQUIRED'),
                              textLabel: TranslationBase.of(context)
                                  .getStringLocaledByKey('PASSWORD'),
                            ),
                            General.sizeBoxVerical(20.0),
                            GestureDetector(
                              onTap: _openForgetPasswordScreen,
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: General.buildTxt(
                                    txt: TranslationBase.of(context)
                                        .getStringLocaledByKey(
                                            'FORGOT_PASSWORD'),
                                    fontSize: 12.0,
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                            General.sizeBoxVerical(30.0),
                            RoundButton(
                              buttonTitle: !authenticationBloc.isWaiting
                                  ? General.buildTxt(
                                      txt: TranslationBase.of(context)
                                          .getStringLocaledByKey('LOGIN'),
                                      color: Colors.white,
                                      fontSize: 16.0)
                                  : General.customThreeBounce(context),
                              disableColor:
                                  Constants.OrangeColor.withOpacity(0.6),
                              color: Constants.OrangeColor,
                              onPress:
                                  !authenticationBloc.isWaiting ? _login : null,
                              roundVal: 100.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )),
          Positioned(
            top: 600.0,
            left: 0.0,
            right: 0.0,
            child: Center(
              child: GestureDetector(
                onTap: _openCreateAccountScreen,
                child: RichText(
                    text: TextSpan(
                        text: TranslationBase.of(context)
                            .getStringLocaledByKey('NOT_HAVE_ACCOUNT'),
                        style: TextStyle(fontSize: 16.0, color: Colors.grey),
                        children: [
                      TextSpan(
                          text: TranslationBase.of(context)
                              .getStringLocaledByKey('CREATE_ACCOUNT'),
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Theme.of(context).primaryColor,
                          )),
                    ])),
              ),
            ),
          ),
          Positioned(
            top: 650.0,
            left: 0.0,
            right: 0.0,
            child: GestureDetector(
              onTap: _changeLang,
              child: Container(
                child: General.buildTxt(
                    txt: TranslationBase.of(context)
                        .getStringLocaledByKey('CHANGE_LANGUAGE'),
                    isBold: true,
                    isUnderLine: true,
                    color: Theme.of(context).primaryColor),
              ),
            ),
          )
        ],
      ),
    );
  }

  _changeLang() {
    LocalizationBloc localizationBloc = Provider.of<LocalizationBloc>(context);
    localizationBloc.changeDirection();
    General.showToast(txt: "تم تغيير اللغة");
  }
}
