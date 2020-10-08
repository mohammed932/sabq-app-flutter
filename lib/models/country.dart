class Country {
  String name;
  num id;
  Country({this.id, this.name});

  factory Country.fromJson(json) {
    return Country(id: json['id'], name: json['name']);
  }
}
