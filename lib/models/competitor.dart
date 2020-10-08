class Competitor {
  num id;
  String firstname,
      secondname,
      thirdname,
      fourthname,
      email,
      gender,
      phone,
      image,
      status;
  Competitor(
      {this.id,
      this.email,
      this.firstname,
      this.fourthname,
      this.gender,
      this.status,
      this.image,
      this.phone,
      this.secondname,
      this.thirdname});

  factory Competitor.fromJson(json) {
    return Competitor(
        id: json['id'],
        firstname: json['first_name'],
        secondname: json['second_name'],
        thirdname: json['third_name'],
        fourthname: json['fourth_name'],
        email: json['email'],
        image: json['image'] ?? null,
        status: json['status'],
        gender: json['gender'],
        phone: json['phone']);
  }
}
