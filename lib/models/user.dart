import 'package:Sabq/models/bank_account.dart';
import 'package:Sabq/models/country.dart';

class User {
  String accessToken;
  UserInfo userInfo;
  User({
    this.userInfo,
    this.accessToken,
  });

  factory User.fromJson(json) {
    return User(
        userInfo: UserInfo.fromJson(json['data']),
        accessToken: json['token'] ?? null);
  }

  dynamic toJson() {
    Map json = {"token": this.accessToken, "data": this.userInfo};
    json.removeWhere((key, value) {
      return value == null;
    });
    return json;
  }

  // @override
  // String toString() {
  //   return "{'id':${this.id},'token':${this.accessToken},'phone':${this.phone}}";
  // }
}

class UserInfo {
  String gender,
      email,
      phone,
      type,
      image,
      status,
      firstName,
      secondName,
      thirdName,
      fourthName;
  num id, competitionsCount, levelsCount, bankAccountCount;
  List<BankAccount> bankAccounts;
  Country country;
  UserInfo({
    this.id,
    this.gender,
    this.type,
    this.email,
    this.firstName,
    this.image,
    this.fourthName,
    this.competitionsCount,
    this.levelsCount,
    this.bankAccountCount,
    this.secondName,
    this.country,
    this.bankAccounts,
    this.thirdName,
    this.status,
    this.phone,
  });
  factory UserInfo.fromJson(json) {
    Iterable bankAccountList = json['bankAccounts'];
    return UserInfo(
      id: json['id'],
      firstName: json['first_name'],
      secondName: json['second_name'],
      thirdName: json['third_name'],
      fourthName: json['fourth_name'],
      email: json['email'],
      country:
          json['country'] != null ? Country.fromJson(json['country']) : null,
      image: json['image'] ?? null,
      gender: json['gender'],
      bankAccounts: json['bankAccounts'] != null
          ? bankAccountList
              .map((account) => BankAccount.fromJson(account))
              .toList()
          : [],
      competitionsCount: json['competitions_count'] ?? 0,
      phone: json['phone'],
      status: json['status'],
      type: json['type'],
    );
  }

  dynamic toJson() {
    Map json = {
      "id": this.id,
      "first_name": this.firstName,
      "second_name": this.secondName,
      "third_name": this.thirdName,
      "fourth_name": this.fourthName,
      "image": this.image,
      "email": this.email,
      "gender": this.gender,
      "type": this.type
    };
    json.removeWhere((key, value) {
      return value == null;
    });
    return json;
  }
}
