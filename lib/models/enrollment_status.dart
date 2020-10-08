class EnrollmentStatus {
  bool competitionStatus,
      canEnrollInCompetition,
      initialLevelStatus,
      isEnrolledInCompetition,
      hasUploadedTempParticipation,
      hasUploadedNormalParticipationToInitialLevel;
  num intialLevel;
  EnrollmentStatus(
      {this.canEnrollInCompetition,
      this.competitionStatus,
      this.hasUploadedNormalParticipationToInitialLevel,
      this.hasUploadedTempParticipation,
      this.initialLevelStatus,
      this.isEnrolledInCompetition,
      this.intialLevel});

  factory EnrollmentStatus.fromJson(json) {
    return EnrollmentStatus(
        canEnrollInCompetition: json['can_enroll_in_competition'],
        hasUploadedNormalParticipationToInitialLevel:
            json['has_uploaded_normal_participation_to_initial_level'],
        hasUploadedTempParticipation: json['has_uploaded_temp_participation'],
        initialLevelStatus: json['initial_level_status'],
        isEnrolledInCompetition: json['is_enrolled_in_competition'],
        intialLevel: json['initial_level'],
        competitionStatus: json['competition_status']);
  }
}
