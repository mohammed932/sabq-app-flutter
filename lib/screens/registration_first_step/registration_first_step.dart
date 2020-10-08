import 'dart:convert';
import 'package:Sabq/animations/scale-transation-route.dart';
import 'package:Sabq/blocs/authentication_bloc.dart';
import 'package:Sabq/blocs/user_bloc.dart';
import 'package:Sabq/components/name_field.dart';
import 'package:Sabq/components/password_field.dart';
import 'package:Sabq/components/round_buttton.dart';
import 'package:Sabq/models/create_account.dart';
import 'package:Sabq/screens/registration_second_step/registration_second_step.dart';
import 'package:Sabq/utils/constants.dart';
import 'package:Sabq/utils/languages/translations_delegate_base.dart';
import 'package:Sabq/widgets/general.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegistrationFirstStepScreen extends StatefulWidget {
  @override
  _RegistrationFirstStepScreenState createState() =>
      _RegistrationFirstStepScreenState();
}

class _RegistrationFirstStepScreenState
    extends State<RegistrationFirstStepScreen> {
  double _currentOpacity = 0;
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _secondNameController = TextEditingController();
  TextEditingController _thirdNameController = TextEditingController();
  TextEditingController _fourthNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  FocusNode _firstNameFocus = FocusNode();
  FocusNode _secondNameFocus = FocusNode();
  FocusNode _thirdNameFocus = FocusNode();
  FocusNode _lastNameFocus = FocusNode();
  FocusNode _passwordFocus = FocusNode();
  FocusNode _confirmPasswordFocus = FocusNode();
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
    await Future.delayed(Duration(milliseconds: 200));
    setState(() => _currentOpacity = 1);
  }

  _openSecondScreen() {
    if (!_formKey.currentState.validate()) {
      return;
    } else {
      _formKey.currentState.save();
    }

    AuthenticationBloc authenticationBloc =
        Provider.of<AuthenticationBloc>(context, listen: false);
    UserBloc userBloc = Provider.of<UserBloc>(context, listen: false);
    CreateAccount request = CreateAccount(
        firstName: _firstNameController.text,
        secondName: _secondNameController.text,
        thirdName: _thirdNameController.text,
        fourthName: _fourthNameController.text,
        type: userBloc.user.userInfo.type == "JUDGE" ? 2 : 1,
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text);
    print("json data is :${jsonEncode(request)}");
    authenticationBloc.setUserData(data: request);
    Navigator.push(
        context, ScaleTransationRoute(page: RegistrationSecondStepScreen()));
  }

  matchPassword(String confirmPassword) {
    if (_passwordController.text.isEmpty) {
      return TranslationBase.of(context)
          .getStringLocaledByKey('CONFIRM_PASSWORD_REQUIRED');
    } else if (_passwordController.text != confirmPassword) {
      return TranslationBase.of(context)
          .getStringLocaledByKey('PASSWORDS_NOT_MATCH');
    } else if (_passwordController.text.length < 8) {
      return TranslationBase.of(context)
          .getStringLocaledByKey('CONFIRM_PASSWORD_MUST_LESS_THAN_8_CHAR');
    } else {
      return null;
    }
  }

  passwordValidation() {
    if (_passwordController.text.isEmpty) {
      return TranslationBase.of(context)
          .getStringLocaledByKey('PASSWORD_REQUIRED');
    } else if (_passwordController.text.length < 8) {
      return TranslationBase.of(context)
          .getStringLocaledByKey('PASSWORD_MUST_LESS_THAN_8_CHAR');
    }
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
                child: AnimatedOpacity(
                  duration: Duration(seconds: 1),
                  opacity: _currentOpacity,
                  curve: Curves.linear,
                  child: SafeArea(
                    child: Container(
                      padding: EdgeInsets.all(15.0),
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
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
                              NameField(
                                controller: _firstNameController,
                                node: _firstNameFocus,
                                nextFocusNode: _secondNameFocus,
                                textLabel: TranslationBase.of(context)
                                    .getStringLocaledByKey('1NAME'),
                                validation: TranslationBase.of(context)
                                    .getStringLocaledByKey('1NAME_REQUIRED'),
                              ),
                              General.sizeBoxVerical(20.0),
                              NameField(
                                controller: _secondNameController,
                                node: _secondNameFocus,
                                nextFocusNode: _thirdNameFocus,
                                textLabel: TranslationBase.of(context)
                                    .getStringLocaledByKey('2NAME'),
                                validation: TranslationBase.of(context)
                                    .getStringLocaledByKey('2NAME_REQUIRED'),
                              ),
                              General.sizeBoxVerical(20.0),
                              NameField(
                                controller: _thirdNameController,
                                node: _thirdNameFocus,
                                nextFocusNode: _lastNameFocus,
                                textLabel: TranslationBase.of(context)
                                    .getStringLocaledByKey('3NAME'),
                                validation: TranslationBase.of(context)
                                    .getStringLocaledByKey('3NAME_REQUIRED'),
                              ),
                              General.sizeBoxVerical(20.0),
                              NameField(
                                controller: _fourthNameController,
                                node: _lastNameFocus,
                                textLabel: TranslationBase.of(context)
                                    .getStringLocaledByKey('LASTNAME'),
                                validation: TranslationBase.of(context)
                                    .getStringLocaledByKey('LASTNAME_REQUIRED'),
                                nextFocusNode: _passwordFocus,
                              ),
                              General.sizeBoxVerical(20.0),
                              PasswordField(
                                controller: _passwordController,
                                node: _passwordFocus,
                                textLabel: TranslationBase.of(context)
                                    .getStringLocaledByKey('PASSWORD'),
                                validation: passwordValidation(),
                                nextFocusNode: _confirmPasswordFocus,
                              ),
                              General.sizeBoxVerical(20.0),
                              Container(
                                child: TextFormField(
                                  controller: _confirmPasswordController,
                                  obscureText: true,
                                  focusNode: _confirmPasswordFocus,
                                  keyboardAppearance: Brightness.light,
                                  validator: (String val) => matchPassword(val),
                                  textInputAction: TextInputAction.done,
                                  decoration: Constants.textFieldDecoration
                                      .copyWith(
                                          prefixIcon: Padding(
                                            padding: EdgeInsets.all(15.0),
                                            child: Image.asset(
                                              "assets/imgs/lock.png",
                                              width: 0.0,
                                              height: 0.0,
                                            ),
                                          ),
                                          contentPadding: EdgeInsets.all(0.0),
                                          labelText:
                                              '${TranslationBase.of(context).getStringLocaledByKey('CONFIRM_PASSWORD')} \*',
                                          labelStyle:
                                              TextStyle(fontSize: 14.0)),
                                ),
                              ),
                              // PasswordField(
                              //   controller: _confirmPasswordController,
                              //   node: _confirmPasswordFocus,
                              //   textLabel: TranslationBase.of(context)
                              //       .getStringLocaledByKey('CONFIRM_PASSWORD'),
                              //   validation: TranslationBase.of(context)
                              //       .getStringLocaledByKey(
                              //           'CONFIRM_PASSWORD_REQUIRED'),
                              // ),
                              General.sizeBoxVerical(30.0),
                              RoundButton(
                                buttonTitle: General.buildTxt(
                                    txt: TranslationBase.of(context)
                                        .getStringLocaledByKey('CONTINUE'),
                                    color: Colors.white,
                                    isBold: true,
                                    fontSize: 16.0),
                                color: Constants.OrangeColor,
                                onPress: _openSecondScreen,
                                roundVal: 100.0,
                              ),
                            ],
                          ),
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
}
