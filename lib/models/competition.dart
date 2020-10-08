import 'competition_level.dart';

class Competition {
  String image,
      name,
      description,
      enrollment,
      from,
      to,
      firstPostion,
      secondPostion,
      thirdPostion,
      targetGroup,
      status;
  num id, externalId, intailLevel;
  bool isWaiting;
  List<CompetitionLevel> competitionLevels;
  Competition(
      {this.image,
      this.status,
      this.description,
      this.thirdPostion,
      this.enrollment,
      this.intailLevel,
      this.isWaiting = false,
      this.externalId,
      this.firstPostion,
      this.from,
      this.id,
      this.competitionLevels,
      this.name,
      this.secondPostion,
      this.targetGroup,
      this.to});

  factory Competition.fromJson(json) {
    Iterable levelList = json['levels'];
    return Competition(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        externalId: json['external_id'],
        from: json['from'],
        to: json['to'],
        intailLevel: json['initial_level'] ?? null,
        image: json['image'],
        competitionLevels: json['levels'] != null
            ? levelList
                .map((level) => CompetitionLevel.fromJson(level))
                .toList()
            : [],
        status: json['status'],
        targetGroup: json['target_group'],
        firstPostion: json['first_position'],
        secondPostion: json['second_position'],
        thirdPostion: json['third_position'],
        enrollment: json['enrollment']);
  }
}
