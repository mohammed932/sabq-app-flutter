import 'package:Sabq/models/attachment.dart';
import 'competitor.dart';

class RandomParticipation {
  num id;
  Competitor competitor;
  Attachment attachment;
  RandomParticipation({this.id, this.attachment, this.competitor});
  factory RandomParticipation.fromJson(json) {
    return RandomParticipation(
        id: json['id'],
        attachment: Attachment.fromJson(json['attachment']),
        competitor: json['competitor'] != null
            ? Competitor.fromJson(json['competitor'])
            : null);
  }
}
