class Test {
  num id;
  String name;

  List<TestItem> testItems;
  Test({this.id, this.name, this.testItems});
  factory Test.fromJson(json) {
    Iterable testItemList = json['tests'];
    return Test(
        id: json['id'],
        name: json['name']['ar'],
        testItems: json['tests'] != null
            ? testItemList
                .map((testItem) => TestItem.fromJson(testItem))
                .toList()
            : []);
  }
}

class TestItem {
  num id, levelId, points;
  Criteria criteria;
  double testValue;
  TestItem(
      {this.id,
      this.levelId,
      this.points,
      this.testValue = 0.0,
      this.criteria});
  factory TestItem.fromJson(json) {
    return TestItem(
        id: json['id'],
        levelId: json['level_id'],
        points: json['points'],
        criteria: json['criteria'] != null
            ? Criteria.fromJosn(json['criteria'])
            : null);
  }
}

class Criteria {
  num id;
  String name;
  Criteria({this.id, this.name});
  factory Criteria.fromJosn(json) {
    return Criteria(id: json['id'], name: json['name']['ar']);
  }
}
