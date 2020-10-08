import 'package:Sabq/blocs/localization_bloc.dart';
import 'package:Sabq/blocs/user_bloc.dart';
import 'package:Sabq/components/name_field.dart';
import 'package:Sabq/components/stack_normal_header.dart';
import 'package:Sabq/utils/languages/translations_delegate_base.dart';
import 'package:Sabq/widgets/general.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BankInfoScreen extends StatefulWidget {
  @override
  _BankInfoScreenState createState() => _BankInfoScreenState();
}

class _BankInfoScreenState extends State<BankInfoScreen> {
  double _currentOpacity = 0;
  TextEditingController _bankNameController = TextEditingController();
  TextEditingController _accountNumberController = TextEditingController();
  TextEditingController _ibanNumberController = TextEditingController();
  FocusNode _bankNameFocus = FocusNode();
  FocusNode _accountNumberFocus = FocusNode();
  FocusNode _swiftCodeFocus = FocusNode();
  UserBloc userBloc;
  _back() {
    Navigator.pop(context);
  }

  _updateBankInfo() {
    if (userBloc.user.userInfo.bankAccounts.isNotEmpty) {
      userBloc.editBankAccountInfo(
          context: context,
          accountNumber: _accountNumberController.text,
          bankName: _bankNameController.text,
          ibanNumber: _ibanNumberController.text);
    } else {
      userBloc.addBankAccountInfo(
          context: context,
          accountNumber: _accountNumberController.text,
          bankName: _bankNameController.text,
          ibanNumber: _ibanNumberController.text);
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    await Future.delayed(Duration(milliseconds: 200));
    userBloc = Provider.of<UserBloc>(context);
    await userBloc.getBankAccountInfo();
    if (userBloc.bankAccounts.isNotEmpty) {
      setDefault();
    }
    setState(() => _currentOpacity = 1);
  }

  setDefault() {
    _bankNameController.text = userBloc.bankAccounts[0].bankName;
    _accountNumberController.text = userBloc.bankAccounts[0].accountNumber;
    _ibanNumberController.text = userBloc.bankAccounts[0].ibanNumber;
  }

  @override
  Widget build(BuildContext context) {
    UserBloc userBloc = Provider.of<UserBloc>(context);
    LocalizationBloc localizationBloc = Provider.of<LocalizationBloc>(context);
    return Scaffold(
      backgroundColor: Color(General.getColorHexFromStr('#FAFAFA')),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Stack(
          children: <Widget>[
            Stack(
              children: <Widget>[
                StackNormalHeader(
                    title: TranslationBase.of(context)
                        .getStringLocaledByKey('BANK_INFO'),
                    onPress: _back),
                Positioned(
                    left: localizationBloc.appLocal.languageCode == "ar"
                        ? 20.0
                        : null,
                    right: localizationBloc.appLocal.languageCode == "ar"
                        ? null
                        : 20.0,
                    top: 58.0,
                    child: GestureDetector(
                      onTap: _updateBankInfo,
                      child: userBloc != null && !userBloc.isWaiting
                          ? Container(
                              child: General.buildTxt(
                                  txt: userBloc.bankAccounts != null &&
                                          userBloc.bankAccounts.isNotEmpty
                                      ? TranslationBase.of(context)
                                          .getStringLocaledByKey('EDIT')
                                      : TranslationBase.of(context)
                                          .getStringLocaledByKey('ADD'),
                                  color: Colors.white,
                                  isBold: true),
                            )
                          : General.customThreeBounce(context),
                    ))
              ],
            ),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            General.sizeBoxVerical(30.0),
                            NameField(
                              controller: _bankNameController,
                              node: _bankNameFocus,
                              nextFocusNode: _accountNumberFocus,
                              textLabel: TranslationBase.of(context)
                                  .getStringLocaledByKey('BANK_NAME'),
                              icon: "assets/imgs/bank.png",
                              showAstrek: false,
                            ),
                            General.sizeBoxVerical(20.0),
                            NameField(
                              controller: _accountNumberController,
                              node: _accountNumberFocus,
                              nextFocusNode: _swiftCodeFocus,
                              icon: "assets/imgs/account-number.png",
                              textLabel: TranslationBase.of(context)
                                  .getStringLocaledByKey('ACCOUNT_NUMBER'),
                              showAstrek: false,
                            ),
                            General.sizeBoxVerical(20.0),
                            NameField(
                              controller: _ibanNumberController,
                              node: _swiftCodeFocus,
                              icon: "assets/imgs/world.png",
                              textLabel: TranslationBase.of(context)
                                  .getStringLocaledByKey('IBAN'),
                              showAstrek: false,
                            ),
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
