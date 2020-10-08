import 'package:Sabq/blocs/bloc_state.dart';
import 'package:Sabq/models/competition.dart';
import 'package:Sabq/services/api.dart';

class CompetitionBloc extends GeneralBlocState {
  num _totalPages;
  bool _isWaiting = false;
  bool _waitingCompetition = true;
  List<Competition> _notEnrolledcompetitions;
  List<Competition> _assignedcompetitions;
  List<Competition> _expiredCompetitions;
  List<Competition> _enrolledcompetitions;
  List<Competition> get notEnrolledcompetitions => _notEnrolledcompetitions;
  List<Competition> get enrolledcompetitions => _enrolledcompetitions;
  List<Competition> get assignedcompetitions => _assignedcompetitions;
  List<Competition> get expiredCompetitions => _expiredCompetitions;

  num get totalPages => _totalPages;
  bool get isWaiting => _isWaiting;
  bool get waitingCompetition => _waitingCompetition;
  Stopwatch stopwatch = Stopwatch();

  getNotEnrolledCompetitions() async {
    try {
      waiting = true;
      notifyListeners();
      _notEnrolledcompetitions = await Api().getNotEnrolledCompetitions();
      waiting = false;
      notifyListeners();
      setError(null);
    } catch (e) {
      waiting = false;
      notifyListeners();
      setError(e.toString());
      print("all competitions error :$e");
    }
  }

  getAssignedCompetitions() async {
    try {
      waiting = true;
      notifyListeners();
      _assignedcompetitions = await Api().getAssignedCompetitions();
      waiting = false;
      notifyListeners();
      setError(null);
    } catch (e) {
      waiting = false;
      notifyListeners();
      setError(e.toString());
      print("all assigned competitions error :$e");
    }
  }

  getExpiredCompetitions() async {
    try {
      waiting = true;
      notifyListeners();
      _expiredCompetitions = await Api().getExpiredCompetitions();
      waiting = false;
      notifyListeners();
      setError(null);
    } catch (e) {
      waiting = false;
      notifyListeners();
      setError(e.toString());
      print("all expired competitions error :$e");
    }
  }

  getEnrolledCompetitions() async {
    try {
      waiting = true;
      notifyListeners();
      _enrolledcompetitions = await Api().getEnrolledCompetitions();
      waiting = false;
      notifyListeners();
      setError(null);
    } catch (e) {
      waiting = false;
      notifyListeners();
      setError(e.toString());
      print("all competitions error :$e");
    }
  }
}
