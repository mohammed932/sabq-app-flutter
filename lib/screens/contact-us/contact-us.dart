import 'package:Sabq/blocs/user_bloc.dart';
import 'package:Sabq/components/name_field.dart';
import 'package:Sabq/components/round_buttton.dart';
import 'package:Sabq/components/stack_normal_header.dart';
import 'package:Sabq/utils/languages/translations_delegate_base.dart';
import 'package:Sabq/widgets/general.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactUsScreen extends StatefulWidget {
  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  double _currentOpacity = 0;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _messageController = TextEditingController();
  FocusNode _titleFocus = FocusNode();
  FocusNode _messageFocus = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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

    setState(() => _currentOpacity = 1);
  }

  _sendMessage() {
    UserBloc userBloc = Provider.of<UserBloc>(context);
    if (!_formKey.currentState.validate()) {
      return;
    } else {
      _formKey.currentState.save();
    }
    userBloc.contactUs(
        subject: _titleController.text,
        msg: _messageController.text,
        context: context);
  }

  @override
  Widget build(BuildContext context) {
    UserBloc userBloc = Provider.of<UserBloc>(context);
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
                    .getStringLocaledByKey('CONTACT_US'),
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
                            NameField(
                              controller: _titleController,
                              node: _titleFocus,
                              nextFocusNode: _messageFocus,
                              showAstrek: false,
                              validation: TranslationBase.of(context)
                                  .getStringLocaledByKey('SUBJECT_REQUIRED'),
                              textLabel: TranslationBase.of(context)
                                  .getStringLocaledByKey('SUBJECT'),
                            ),
                            General.sizeBoxVerical(20.0),
                            NameField(
                              controller: _messageController,
                              node: _messageFocus,
                              lines: 5,
                              showAstrek: false,
                              action: "newline",
                              icon: "assets/imgs/empty-email.png",
                              validation: TranslationBase.of(context)
                                  .getStringLocaledByKey('MSG_REQUIRED'),
                              textLabel: TranslationBase.of(context)
                                  .getStringLocaledByKey('WRITE_UR_MSG_HERE'),
                            ),
                            General.sizeBoxVerical(30.0),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: RoundButton(
                                buttonTitle: !userBloc.isWaiting
                                    ? General.buildTxt(
                                        txt: TranslationBase.of(context)
                                            .getStringLocaledByKey('SEND'),
                                        color: Colors.white,
                                        isBold: true,
                                        fontSize: 16.0)
                                    : General.customThreeBounce(context),
                                color: Theme.of(context).primaryColor,
                                disableColor: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.6),
                                onPress:
                                    !userBloc.isWaiting ? _sendMessage : null,
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
