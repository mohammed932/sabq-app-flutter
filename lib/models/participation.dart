import 'package:Sabq/models/attachment.dart';
import 'package:Sabq/models/competitor.dart';

import 'competition_level.dart';

class Participation {
  num id;
  Competitor competitor;
  CompetitionLevel competitionLevel;
  Attachment attachment;
  Participation(
      {this.id, this.competitor, this.competitionLevel, this.attachment});

  factory Participation.fromJson(json) {
    return Participation(
        id: json['id'],
        competitor: json['competitor'] != null
            ? Competitor.fromJson(json['competitor'])
            : null,
        competitionLevel: json['level'] != null
            ? CompetitionLevel.fromJson(json['level'])
            : null,
        attachment: json['attachment'] != null
            ? Attachment.fromJson(json['attachment'])
            : null);
  }
}
