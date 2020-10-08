class CreateAccount {
  String firstName,
      secondName,
      thirdName,
      fourthName,
      email,
      password,
      confirmPassword,
      phone,
      cv,
      image;
  num type, gender, country;
  CreateAccount(
      {this.type,
      this.confirmPassword,
      this.email,
      this.firstName,
      this.fourthName,
      this.gender,
      this.password,
      this.phone,
      this.cv,
      this.country,
      this.image,
      this.secondName,
      this.thirdName});

  dynamic toJson() {
    Map json = {
      'first_name': this.firstName,
      'second_name': this.secondName,
      'third_name': this.thirdName,
      'fourth_name': this.fourthName,
      'country_id': this.country,
      'email': this.email,
      'password': this.password,
      'password_confirmation': this.confirmPassword,
      'gender': this.gender,
      'phone': this.phone,
      'type': this.type,
      'image': this.image,
      'cv': this.cv,
    };
    json.removeWhere((key, value) {
      return value == null || value == '';
    });
    return json;
  }
}
