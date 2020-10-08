import 'package:Sabq/blocs/authentication_bloc.dart';
import 'package:Sabq/components/password_field.dart';
import 'package:Sabq/components/round_buttton.dart';
import 'package:Sabq/components/stack_normal_header.dart';
import 'package:Sabq/utils/languages/translations_delegate_base.dart';
import 'package:Sabq/widgets/general.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  double _currentOpacity = 0;
  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmNewPasswordController = TextEditingController();
  FocusNode _currentPasswordFocus = FocusNode();
  FocusNode _newPasswordFocus = FocusNode();
  FocusNode _confirmNewPasswordFocus = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AuthenticationBloc authenticationBloc;
  _back() {
    Navigator.pop(context);
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    await Future.delayed(Duration(milliseconds: 200));
    authenticationBloc = Provider.of<AuthenticationBloc>(context);
    setState(() => _currentOpacity = 1);
  }

  _submit() {
    if (!_formKey.currentState.validate()) {
      return;
    } else {
      _formKey.currentState.save();
    }
    authenticationBloc.changePassword(
        context: context,
        oldPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
        confirmNewPassword: _confirmNewPasswordController.text);
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationBloc authBloc = Provider.of<AuthenticationBloc>(context);
    return Scaffold(
      backgroundColor: Color(General.getColorHexFromStr('#FAFAFA')),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Stack(
          children: <Widget>[
            StackNormalHeader(
                title: TranslationBase.of(context)
                    .getStringLocaledByKey('CHANGE_PASSWORD'),
                onPress: _back),
            Positioned(
              left: 0.0,
              right: 0.0,
              top: 90.0,
              height: MediaQuery.of(context).size.height,
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  decoration: BoxDecoration(
                      color: Color(General.getColorHexFromStr('#FAFAFA')),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50.0),
                        topRight: Radius.circular(50.0),
                      )),
                  child: SingleChildScrollView(
                    child: AnimatedOpacity(
                      duration: Duration(seconds: 1),
                      opacity: _currentOpacity,
                      curve: Curves.easeIn,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            General.sizeBoxVerical(30.0),
                            PasswordField(
                              controller: _currentPasswordController,
                              node: _currentPasswordFocus,
                              nextFocusNode: _newPasswordFocus,
                              showAstrek: false,
                              textLabel: TranslationBase.of(context)
                                  .getStringLocaledByKey('CURRENT_PASSWORD'),
                              validation: TranslationBase.of(context)
                                  .getStringLocaledByKey(
                                      'CURRENT_PASSWORD_REQUIRED'),
                            ),
                            General.sizeBoxVerical(20.0),
                            PasswordField(
                              controller: _newPasswordController,
                              node: _newPasswordFocus,
                              nextFocusNode: _confirmNewPasswordFocus,
                              showAstrek: false,
                              textLabel: TranslationBase.of(context)
                                  .getStringLocaledByKey('NEW_PASSWORD'),
                              validation: TranslationBase.of(context)
                                  .getStringLocaledByKey(
                                      'NEW_PASSWORD_REQUIRED'),
                            ),
                            General.sizeBoxVerical(20.0),
                            PasswordField(
                              controller: _confirmNewPasswordController,
                              node: _confirmNewPasswordFocus,
                              showAstrek: false,
                              textLabel: TranslationBase.of(context)
                                  .getStringLocaledByKey(
                                      'CONFIRM_NEW_PASSWORD'),
                              validation: TranslationBase.of(context)
                                  .getStringLocaledByKey(
                                      'CONFIRM_NEW_PASSWORD_REQUIRED'),
                            ),
                            General.sizeBoxVerical(30.0),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: RoundButton(
                                buttonTitle: !authBloc.isWaiting
                                    ? General.buildTxt(
                                        txt: TranslationBase.of(context)
                                            .getStringLocaledByKey(
                                                'CHANGE_PASSWORD'),
                                        color: Colors.white,
                                        isBold: true,
                                        fontSize: 16.0)
                                    : General.customThreeBounce(context),
                                color: Theme.of(context).primaryColor,
                                disableColor: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.6),
                                onPress: !authBloc.isWaiting ? _submit : null,
                                roundVal: 100.0,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
