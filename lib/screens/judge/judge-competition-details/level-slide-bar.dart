import 'package:Sabq/models/competition_level.dart';
import 'package:Sabq/widgets/general.dart';
import 'package:flutter/material.dart';

class LevelBar extends StatelessWidget {
  final List<CompetitionLevel> levels;
  final Function onLevelPress;
  LevelBar({@required this.levels, @required this.onLevelPress}) {
    print('levels :$levels');
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: levels
            .map<Widget>((level) => _tabItem(level: level, context: context))
            .toList(),
      ),
    );
  }

  _tabItem({CompetitionLevel level, BuildContext context}) {
    return GestureDetector(
      onTap: () => onLevelPress(level),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            color: level.isActive
                ? Colors.grey.withOpacity(0.6)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(100.0)),
        padding: EdgeInsets.all(10.0),
        child: General.buildTxt(txt: level.name),
      ),
    );
  }
}
