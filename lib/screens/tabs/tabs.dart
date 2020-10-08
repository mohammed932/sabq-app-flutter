import 'package:Sabq/screens/competitions/competitions.dart';
import 'package:Sabq/screens/joined_competitions/joined_competitions.dart';
import 'package:Sabq/screens/profile/profile.dart';
import 'package:Sabq/utils/languages/translations_delegate_base.dart';
import 'package:Sabq/widgets/general.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TabsScreen extends StatefulWidget {
  final int tabIndex;
  TabsScreen({this.tabIndex});
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _currentIndex = 1;
  final List<Widget> _children = [
    JoinedCompetitionsScreen(),
    CompetitionsScreen(),
    ProfileScreen()
  ];

  @override
  void initState() {
    if (widget.tabIndex != null) {
      setState(() => _currentIndex = widget.tabIndex);
    }
    super.initState();
  }

  onTabTapped(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
          body: _children[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            onTap: onTabTapped,
            backgroundColor: Colors.white,
            currentIndex: _currentIndex,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                  icon: Image.asset(
                    _currentIndex == 0
                        ? 'assets/imgs/list.png'
                        : 'assets/imgs/list.png',
                    width: 25.0,
                    height: 25.0,
                  ),
                  title: Container(
                    margin: EdgeInsets.only(top: 5.0),
                    child: General.buildTxt(
                        txt: TranslationBase.of(context)
                            .getStringLocaledByKey('JOINED'),
                        fontSize: 12.0,
                        color: Theme.of(context).primaryColor),
                  )),
              BottomNavigationBarItem(
                  icon: Image.asset(
                    _currentIndex == 1
                        ? 'assets/imgs/bubble-list.png'
                        : 'assets/imgs/bubble-list-inactive.png',
                    width: 25.0,
                    height: 25.0,
                  ),
                  title: Container(
                    margin: EdgeInsets.only(top: 5.0),
                    child: General.buildTxt(
                        txt: TranslationBase.of(context)
                            .getStringLocaledByKey('COMPETITIONS'),
                        fontSize: 12.0,
                        color: Theme.of(context).primaryColor),
                  )),
              BottomNavigationBarItem(
                  icon: Image.asset(
                    _currentIndex == 2
                        ? 'assets/imgs/user.png'
                        : 'assets/imgs/user-inactive.png',
                    width: 25.0,
                    height: 25.0,
                  ),
                  title: Container(
                    margin: EdgeInsets.only(top: 5.0),
                    child: General.buildTxt(
                        txt: TranslationBase.of(context)
                            .getStringLocaledByKey('MY_ACCOUNT'),
                        fontSize: 12.0,
                        color: Theme.of(context).primaryColor),
                  )),
            ],
          )),
    );
  }
}
