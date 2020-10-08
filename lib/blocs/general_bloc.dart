import 'package:Sabq/models/country.dart';
import 'package:Sabq/models/criteria.dart';
import 'package:Sabq/services/api.dart';

import 'bloc_state.dart';

class GenenralBloc extends GeneralBlocState {
  bool _isCreateNewAccountButtonPressed = false;
  bool _isLoginButtonPressed = false;
  Criteria _criteria;
  List<Country> _countries;
  bool get isCreateNewAccountButtonPressed => _isCreateNewAccountButtonPressed;
  bool get isLoginButtonPressed => _isLoginButtonPressed;
  Criteria get criteria => _criteria;
  List<Country> get countries => _countries;

  GenenralBloc() {
    _criteria = Criteria(
        value1: 1, value2: 1, value3: 1, value4: 1, value5: 1, value6: 1);
  }
  setIsCreateNewAccountButtonPressed({bool status}) {
    _isCreateNewAccountButtonPressed = status;
    notifyListeners();
  }

  setisLoginButtonPressed({bool status}) {
    _isLoginButtonPressed = status;
    notifyListeners();
  }

  getCountries() async {
    try {
      waiting = true;
      _countries = await Api().getCountries();
      waiting = false;
      notifyListeners();
    } catch (e) {
      waiting = false;
      notifyListeners();
      print("countries error :$e");
    }
  }

  setCritria({val1, val2, val3, val4, val5, val6}) {
    if (val1 != null) {
      _criteria.value1 = val1;
    } else if (val2 != null) {
      _criteria.value2 = val2;
    } else if (val3 != null) {
      _criteria.value3 = val3;
    } else if (val4 != null) {
      _criteria.value4 = val4;
    } else if (val5 != null) {
      _criteria.value5 = val5;
    } else if (val6 != null) {
      _criteria.value6 = val6;
    }
    notifyListeners();
  }
}
