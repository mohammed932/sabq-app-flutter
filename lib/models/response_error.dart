class ResponseError {
  final message;
  List<dynamic> errors;
  ResponseError({this.message, this.errors});
  factory ResponseError.fromJson(Map<String, dynamic> json) {
    List errs = [];
    json['errors'].forEach((k, v) => errs.add(v[0]));
    return ResponseError(message: json['message'], errors: errs);
  }
}
