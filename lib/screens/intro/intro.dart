import 'package:Sabq/blocs/general_bloc.dart';
import 'package:Sabq/screens/create-account/create-account.dart';
import 'package:Sabq/screens/login/login.dart';
import 'package:Sabq/widgets/general.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
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
                    height: 300.0,
                    child: Center(
                      child: Image.asset(
                        "assets/imgs/logo.png",
                        width: 180.0,
                      ),
                    ),
                  ),
                ),
                _showAppropriateScreen()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _showAppropriateScreen() {
    GenenralBloc genenralBloc = Provider.of<GenenralBloc>(context);
    if (genenralBloc.isCreateNewAccountButtonPressed) {
      return CreateAccountScreen();
    } else if (!genenralBloc.isCreateNewAccountButtonPressed &&
        genenralBloc.isLoginButtonPressed) {
      return LoginScreen();
    } else {
      return LoginScreen();
    }
  }
}
