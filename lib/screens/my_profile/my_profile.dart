import 'dart:convert';
import 'dart:io';
import 'package:Sabq/animations/scale-transation-route.dart';
import 'package:Sabq/blocs/authentication_bloc.dart';
import 'package:Sabq/blocs/localization_bloc.dart';
import 'package:Sabq/blocs/user_bloc.dart';
import 'package:Sabq/components/email_field.dart';
import 'package:Sabq/components/name_field.dart';
import 'package:Sabq/components/select_country.dart';
import 'package:Sabq/components/select_gender.dart';
import 'package:Sabq/components/stack_normal_header.dart';
import 'package:Sabq/models/create_account.dart';
import 'package:Sabq/screens/change_password/change_password.dart';
import 'package:Sabq/utils/languages/translations_delegate_base.dart';
import 'package:Sabq/widgets/general.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';

class MyProfileScreen extends StatefulWidget {
  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  double _currentOpacity = 0;
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _secondNameController = TextEditingController();
  TextEditingController _thirdNameController = TextEditingController();
  TextEditingController _fourthNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  FocusNode _firstNameFocus = FocusNode();
  FocusNode _secondNameFocus = FocusNode();
  FocusNode _thirdNameFocus = FocusNode();
  FocusNode _lastNameFocus = FocusNode();
  FocusNode _emailFocus = FocusNode();
  FocusNode _phoneFocus = FocusNode();
  UserBloc userBloc;
  AuthenticationBloc authenticationBloc;
  PhoneNumber phoneNumberInfo;
  String mobile = '';
  File _image;
  _back() {
    Navigator.pop(context);
  }

  _updateProfile() {
    authenticationBloc =
        Provider.of<AuthenticationBloc>(context, listen: false);
    UserBloc userBloc = Provider.of<UserBloc>(context);
    switch (userBloc.user.userInfo.gender) {
      case "MALE":
        userBloc.user.userInfo.gender = "1";
        break;
      case "FEMALE":
        userBloc.user.userInfo.gender = "2";
        break;
      default:
    }
    CreateAccount request = CreateAccount(
      firstName: _firstNameController.text,
      secondName: _secondNameController.text,
      thirdName: _thirdNameController.text,
      fourthName: _fourthNameController.text,
      email: _emailController.text,
      phone: mobile.toString(),
      gender: int.parse(userBloc.user.userInfo.gender),
      country: userBloc.user.userInfo.country.id,
    );
    print("json data is :${jsonEncode(request)}");
    authenticationBloc.setUserData(data: request);
    userBloc.updateUserProfile(context: context);
  }

  uploadImage() async {
    final _picker = ImagePicker();
    final pickedImage = await _picker.getImage(
        source: ImageSource.gallery, maxWidth: 600.0, maxHeight: 600.0);
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: pickedImage.path,
    );
    setState(() => _image = croppedFile);
    userBloc.uploadProfileImage(image: _image);
  }

  _openChangePasswordScreen() {
    Navigator.push(context, ScaleTransationRoute(page: ChangePasswordScreen()));
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    await Future.delayed(Duration(milliseconds: 500));
    userBloc = Provider.of<UserBloc>(context, listen: false);
    authenticationBloc =
        Provider.of<AuthenticationBloc>(context, listen: false);
    await userBloc.getUserInfo();
    phoneNumberInfo = await PhoneNumber.getRegionInfoFromPhoneNumber(
        userBloc.user.userInfo.phone);
    mobile = phoneNumberInfo.phoneNumber;
    _firstNameController.text = userBloc.user.userInfo.firstName;
    _secondNameController.text = userBloc.user.userInfo.secondName;
    _thirdNameController.text = userBloc.user.userInfo.thirdName;
    _fourthNameController.text = userBloc.user.userInfo.fourthName;
    _emailController.text =
        userBloc.user.userInfo.email.replaceAll(new RegExp(r"\s+"), "");
    setState(() => _currentOpacity = 1);
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
                        .getStringLocaledByKey('MY_PROFILE'),
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
                      onTap: _updateProfile,
                      child: !userBloc.isWaiting
                          ? Container(
                              child: General.buildTxt(
                                  txt: TranslationBase.of(context)
                                      .getStringLocaledByKey('EDIT'),
                                  color: Colors.white,
                                  isBold: true),
                            )
                          : General.customThreeBounce(context),
                    ))
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 90.0),
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
                      child: Form(child: Consumer<UserBloc>(
                          builder: (BuildContext context, state, __) {
                        if (!state.waiting) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              General.sizeBoxVerical(20.0),
                              _profileImageWidget(),
                              General.sizeBoxVerical(20.0),
                              Container(
                                alignment: Alignment.center,
                                child: General.buildTxt(
                                    txt:
                                        "${TranslationBase.of(context).getStringLocaledByKey('PARTICIPATION_COUNT')} (${userBloc.user.userInfo.competitionsCount})",
                                    color: Theme.of(context).accentColor,
                                    fontSize: 16.0),
                              ),
                              General.sizeBoxVerical(30.0),
                              NameField(
                                controller: _firstNameController,
                                node: _firstNameFocus,
                                nextFocusNode: _emailFocus,
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
                                nextFocusNode: _emailFocus,
                              ),
                              General.sizeBoxVerical(20.0),
                              EmailField(
                                controller: _emailController,
                                node: _emailFocus,
                                nextFocusNode: _phoneFocus,
                              ),
                              General.sizeBoxVerical(20.0),
                              Container(
                                child: InternationalPhoneNumberInput(
                                  onInputChanged: (PhoneNumber number) {
                                    print(number.phoneNumber);
                                    mobile = number.phoneNumber;
                                    print(
                                        'phoneNumberInfo.isoCode :${phoneNumberInfo.isoCode}');
                                  },
                                  onInputValidated: (bool value) {
                                    print(value);
                                  },
                                  focusNode: _phoneFocus,
                                  ignoreBlank: false,
                                  // autoValidate: true,
                                  selectorTextStyle:
                                      TextStyle(color: Colors.black),
                                  initialValue: phoneNumberInfo,
                                  textFieldController: _phoneController,
                                  formatInput: true,
                                  errorMessage: TranslationBase.of(context)
                                      .getStringLocaledByKey('NOT_VALID_PHONE'),
                                  hintText:
                                      localizationBloc.appLocal.languageCode ==
                                              "ar"
                                          ? "رقم الجوال"
                                          : "phone number",
                                  locale: "en",
                                ),
                              ),
                              General.sizeBoxVerical(20.0),
                              SelectCountry(),
                              SelectGender(),
                              General.sizeBoxVerical(30.0),
                              _changePasswordSection(),
                              General.sizeBoxVerical(30.0),
                            ],
                          );
                        } else {
                          return Container();
                        }
                      })),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }

  _changePasswordSection() {
    return GestureDetector(
      onTap: _openChangePasswordScreen,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        alignment: Alignment.topRight,
        child: DottedBorder(
          color: Theme.of(context).primaryColor,
          strokeWidth: 1,
          radius: Radius.circular(50.0),
          strokeCap: StrokeCap.butt,
          borderType: BorderType.RRect,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(50.0)),
            alignment: Alignment.center,
            padding: EdgeInsets.all(15.0),
            child: General.buildTxt(
              txt: TranslationBase.of(context)
                  .getStringLocaledByKey('CHANGE_PASSWORD'),
              fontSize: 14.0,
              isBold: true,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
    );
  }

  _profileImageWidget() {
    return GestureDetector(
      onTap: uploadImage,
      child: Container(
        alignment: Alignment.center,
        child: CircleAvatar(
          radius: 50.0,
          child: Stack(
            children: <Widget>[
              Positioned(
                  bottom: 0.0,
                  right: 0.0,
                  left: 0.0,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(50.0),
                          bottomRight: Radius.circular(50.0),
                        )),
                    child: General.buildTxt(
                        txt: TranslationBase.of(context)
                            .getStringLocaledByKey('CHANGE'),
                        fontSize: 12.0),
                  ))
            ],
          ),
          backgroundImage: _image == null ? _defaultimg() : _selectedImg(),
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }

  _selectedImg() {
    return FileImage(_image);
  }

  _defaultimg() {
    UserBloc userBloc = Provider.of<UserBloc>(context);
    return userBloc.user.userInfo.image == null ||
            userBloc.user.userInfo.image.isEmpty
        ? AssetImage('assets/imgs/profile-img.png')
        : NetworkImage(userBloc.user.userInfo.image);
  }
}
