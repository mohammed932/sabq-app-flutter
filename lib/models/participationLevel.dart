import 'package:Sabq/models/attachment.dart';
import 'package:Sabq/models/competitor.dart';

class ParticipationLevel {
  Competitor competitor;
  Attachment attachment;
  ParticipationLevel({this.attachment, this.competitor});
  factory ParticipationLevel.fromJson(json) {
    return ParticipationLevel(
        attachment: Attachment.fromJson(json['attachment']),
        competitor: Competitor.fromJson(json['competitor']));
  }
}
