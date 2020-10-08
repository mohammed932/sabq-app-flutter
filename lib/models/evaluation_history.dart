import 'participation.dart';

class EvaluationHistory {
  num id;
  String judgePrice, totalRate, notes, judgementDuration, participationDate;
  Participation participation;
  List<Grade> grades;
  EvaluationHistory(
      {this.id,
      this.notes,
      this.judgementDuration,
      this.judgePrice,
      this.participationDate,
      this.grades,
      this.participation,
      this.totalRate});
  factory EvaluationHistory.fromJson(json) {
    Iterable gradeList = json['grades'];
    return EvaluationHistory(
        id: json['id'],
        participationDate: json['created_at'],
        judgePrice: json['judge_price'],
        notes: json['notes'],
        totalRate: json['total_rate'],
        grades: json['grades'] != null
            ? gradeList.map((grade) => Grade.fromJson(grade)).toList()
            : [],
        participation: json['participation'] != null
            ? Participation.fromJson(json['participation'])
            : null,
        judgementDuration: json['judgement_duration']);
  }
}

class Grade {
  num id, value;
  String criteriaName;
  Grade({this.id, this.value, this.criteriaName});
  factory Grade.fromJson(json) {
    return Grade(
        id: json['id'],
        value: json['value'],
        criteriaName: json['criteria_name']);
  }
}
