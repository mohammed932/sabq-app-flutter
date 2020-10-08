import 'package:Sabq/models/competition.dart';

class CompetitionLevel {
  String name, description, from, to, status, attachmentControl;
  num id, maxOfRates;
  bool isInitialLevel, skipContinueButton, isActive;
  Evaluation evaluation;
  Competition competition;

  CompetitionLevel(
      {this.id,
      this.name,
      this.from,
      this.description,
      this.to,
      this.evaluation,
      this.attachmentControl,
      this.isActive = false,
      this.competition,
      this.isInitialLevel,
      this.skipContinueButton,
      this.maxOfRates,
      this.status});

  factory CompetitionLevel.fromJson(json) {
    return CompetitionLevel(
        id: json['id'],
        name: json['name'],
        from: json['from'],
        to: json['to'],
        maxOfRates: json['max_of_rates'] ?? null,
        attachmentControl: json['attachment_control'] ?? null,
        isInitialLevel: json['is_initial_level'],
        skipContinueButton:
            json['skip_attachment_control'] == 'INACTIVE' ? false : true,
        status: json['status'],
        evaluation: json['evaluation'] != null
            ? Evaluation.fromJson(json['evaluation'])
            : null,
        competition: json['competition'] != null
            ? Competition.fromJson(json['competition'])
            : null,
        description: json['description'] ?? null);
  }
}

class Evaluation {
  String score;
  String evaluated;
  String file;
  Evaluation({this.score, this.evaluated, this.file});
  factory Evaluation.fromJson(json) {
    var newScore;
    if (json['score'].runtimeType == String)
      newScore = json['score'];
    else
      newScore = json['score'].toString();
    return Evaluation(
        score: newScore, evaluated: json['evaluated'], file: json['file']);
  }
}
