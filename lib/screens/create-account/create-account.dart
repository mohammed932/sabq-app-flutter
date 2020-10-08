import 'package:Sabq/animations/scale-transation-route.dart';
import 'package:Sabq/blocs/general_bloc.dart';
import 'package:Sabq/blocs/user_bloc.dart';
import 'package:Sabq/mocks/mocks.dart';
import 'package:Sabq/models/user.dart';
import 'package:Sabq/models/user_type.dart';
import 'package:Sabq/screens/registration_first_step/registration_first_step.dart';
import 'package:Sabq/utils/languages/translations_delegate_base.dart';
import 'package:Sabq/widgets/general.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateAccountScreen extends StatefulWidget {
  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  double _cuurentOpacity = 0;
  _openLoginScreen() {
    GenenralBloc genenralBloc =
        Provider.of<GenenralBloc>(context, listen: false);
    genenralBloc.setIsCreateNewAccountButtonPressed(status: false);
    genenralBloc.setisLoginButtonPressed(status: true);
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    await Future.delayed(Duration(milliseconds: 200));
    setState(() => _cuurentOpacity = 1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Positioned(
              top: 250.0,
              left: 0.0,
              right: 0.0,
              height: MediaQuery.of(context).size.height,
              child: Container(
                height: 300.0,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50.0),
                        topRight: Radius.circular(50.0),
                        bottomLeft: Radius.circular(50.0),
                        bottomRight: Radius.circular(50.0))),
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        General.sizeBoxVerical(20.0),
                        General.buildTxt(
                            txt: TranslationBase.of(context)
                                .getStringLocaledByKey('CREATE_ACCOUNT'),
                            fontSize: 20.0,
                            isBold: true,
                            color: Theme.of(context).primaryColor),
                        General.sizeBoxVerical(20.0),
                        AnimatedOpacity(
                          duration: Duration(seconds: 1),
                          opacity: _cuurentOpacity,
                          curve: Curves.linear,
                          child: Container(
                            height: 200.0,
                            child: GridView.count(
                              crossAxisCount: 2,
                              padding: EdgeInsets.all(8.0),
                              mainAxisSpacing: 4.0,
                              crossAxisSpacing: 8.0,
                              children: Mocks.userTypes.map<Widget>((userType) {
                                return applicantCard(userType);
                              }).toList(),
                            ),
                          ),
                        )
                      ],
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
                onTap: _openLoginScreen,
                child: RichText(
                    text: TextSpan(
                        text: TranslationBase.of(context)
                            .getStringLocaledByKey('U_HAVE_ALREADY_ACCOUNT'),
                        style: TextStyle(fontSize: 16.0, color: Colors.grey),
                        children: [
                      TextSpan(
                          text: TranslationBase.of(context)
                              .getStringLocaledByKey('LOGIN'),
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Theme.of(context).primaryColor,
                          )),
                    ])),
              ),
            ),
          )
        ],
      ),
    );
  }

  _openScreen(String type) {
    UserBloc userBloc = Provider.of<UserBloc>(context, listen: false);
    if (type == 'JUDGE') {
      userBloc.setUser(currentUser: User(userInfo: UserInfo(type: "JUDGE")));
    } else {
      userBloc.setUser(
          currentUser: User(userInfo: UserInfo(type: "COMPETITOR")));
    }
    Navigator.push(
        context, ScaleTransationRoute(page: RegistrationFirstStepScreen()));
  }

  applicantCard(UserType userType) {
    return GestureDetector(
      onTap: () => _openScreen(userType.type),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(5.0)),
        child: Column(
          children: <Widget>[
            Image.asset(
              userType.img,
              width: 140.0,
              height: 120.0,
            ),
            General.buildTxt(txt: userType.txt)
          ],
        ),
      ),
    );
  }
}
