import 'package:Sabq/models/evaluation_history.dart';

class EvaluationHistoryResponse {
  List<EvaluationHistory> evaluationHistoryList;
  num totalPages;
  EvaluationHistoryResponse({this.evaluationHistoryList, this.totalPages});

  factory EvaluationHistoryResponse.fromJson(json) {
    Iterable list = json['data'];
    return EvaluationHistoryResponse(
        totalPages: json['meta']['last_page'],
        evaluationHistoryList: json['data'] != null
            ? list
                .map((history) => EvaluationHistory.fromJson(history))
                .toList()
            : []);
  }
}
