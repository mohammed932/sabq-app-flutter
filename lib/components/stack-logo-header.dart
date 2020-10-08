import 'package:Sabq/widgets/general.dart';
import 'package:flutter/material.dart';

class StackLogoHeader extends StatelessWidget {
  final Function onPress;
  final num headerHeight, logoDistanceFromTop, logoWidth;
  final bool isHaveBackButton, isHaveLogoImg, isTitleBold;
  final num titleFontSize;
  final String title;
  StackLogoHeader(
      {this.onPress,
      this.headerHeight = 255.0,
      this.logoWidth = 170.0,
      this.logoDistanceFromTop = 30.0,
      this.titleFontSize = 20.0,
      this.isHaveBackButton = true,
      this.isTitleBold = true,
      this.title = '',
      this.isHaveLogoImg = true});
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0.0,
      right: 0.0,
      child: Container(
        color: Theme.of(context).primaryColor,
        height: headerHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            General.sizeBoxVerical(logoDistanceFromTop),
            isHaveBackButton
                ? IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 25.0,
                    ),
                    onPressed: onPress)
                : Container(),
            Center(
              child: isHaveLogoImg
                  ? Image.asset(
                      "assets/imgs/logo.png",
                      width: logoWidth,
                    )
                  : General.buildTxt(
                      txt: title,
                      color: Colors.white,
                      fontSize: titleFontSize,
                      isBold: isTitleBold),
            ),
          ],
        ),
      ),
    );
  }
}
