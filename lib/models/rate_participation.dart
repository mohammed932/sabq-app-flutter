class RateParticipation {
  num levelId, participationId;
  List<Grade> grades;
  String judgementDuration, notes;
  RateParticipation(
      {this.levelId,
      this.notes,
      this.grades,
      this.judgementDuration,
      this.participationId});
  dynamic toJson() {
    Map json = {
      "level": this.levelId,
      "judgement_duration": this.judgementDuration,
      "notes": this.notes,
      "grades": this.grades,
    };
    json.removeWhere((key, value) {
      return value == null;
    });
    return json;
  }
}

class Grade {
  num testId, value;
  Grade({this.testId, this.value});
  dynamic toJson() {
    Map json = {
      "test_id": this.testId,
      "value": this.value,
    };
    json.removeWhere((key, value) {
      return value == null;
    });
    return json;
  }
}
