import 'package:Sabq/models/gender.dart';
import 'package:Sabq/models/user_type.dart';

class Mocks {
  static List<UserType> userTypes = [
    UserType(
        id: "1",
        type: "COMPETITOR",
        img: "assets/imgs/competitor.png",
        txt: "متسابق"),
    UserType(id: "2", type: "JUDGE", img: "assets/imgs/judge.png", txt: "مقيم")
  ];

  static List<Gender> genders = [
    Gender(id: 1, textAr: "ذكر", textEn: "Male", type: "male"),
    Gender(id: 2, textAr: "أنثى", textEn: "Female", type: "female"),
  ];
}
