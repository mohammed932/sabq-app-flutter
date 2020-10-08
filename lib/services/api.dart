import 'dart:convert';
import 'dart:io';
import 'package:Sabq/blocs/authentication_bloc.dart';
import 'package:Sabq/blocs/competition_bloc.dart';
import 'package:Sabq/blocs/competition_details_bloc.dart';
import 'package:Sabq/models/bank_account.dart';
import 'package:Sabq/models/competition.dart';
import 'package:Sabq/models/competition_level.dart';
import 'package:Sabq/models/enrollment_status.dart';
import 'package:Sabq/models/evaluation_history_response.dart';
import 'package:Sabq/models/participationLevel.dart';
import 'package:Sabq/models/random_participation.dart';
import 'package:Sabq/models/rate_participation.dart';
import 'package:Sabq/models/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:path/path.dart' as path;
import 'package:Sabq/models/country.dart';
import 'package:Sabq/models/create_account.dart';
import 'package:Sabq/models/response_error.dart';
import 'package:Sabq/models/user.dart';
import 'package:Sabq/utils/constants.dart';
import 'package:Sabq/utils/shared_preference.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class Api {
  Future registration({CreateAccount params}) async {
    try {
      String responseBody = await postServices('register', params);
      Map<String, dynamic> responseJson = json.decode(responseBody);
      print('responseJson :$responseJson');
      // 1 competitor
      // 2 judge
      if (params.type == 2) {
        return User.fromJson(responseJson);
      } else {
        return responseJson['message'];
      }
    } catch (e) {
      throw e;
    }
  }

  Future verify({String email, String code}) async {
    try {
      Map params = {"email": email, "code": code};
      String responseBody = await postServices('activate', params);
      Map<String, dynamic> responseJson = json.decode(responseBody);
      User user = User.fromJson(responseJson);
      print('verify user response  :$user');
      return user;
    } catch (e) {
      throw e;
    }
  }

  Future resend({String email}) async {
    try {
      Map params = {"email": email};
      String responseBody = await postServices('resend', params);
      Map<String, dynamic> responseJson = json.decode(responseBody);
      print('responseJson  :$responseJson');
    } catch (e) {
      throw e;
    }
  }

  Future rateParticipation({RateParticipation params}) async {
    try {
      String responseBody = await postServices(
          'judge/${params.participationId}/rate-participation', params);
      Map<String, dynamic> responseJson = json.decode(responseBody);
      print('rate participation responseJson  :$responseJson');
    } catch (e) {
      throw e;
    }
  }

  Future changePassword(
      {String oldPassword,
      String newPassword,
      String confirmNewPassword}) async {
    try {
      String responseBody;
      Map params = {
        "old_password": oldPassword,
        "password": newPassword,
        "password_confirmation": confirmNewPassword
      };
      User userData = await SharedPreferenceHandler.getuserData();
      if (userData.userInfo.type == 'JUDGE') {
        responseBody =
            await putServices(url: 'judge/update-password', params: params);
      } else {
        responseBody = await putServices(
            url: 'competitor/update-password', params: params);
      }
      Map<String, dynamic> responseJson = json.decode(responseBody);
      print('change password response  :$responseJson');
    } catch (e) {
      throw e;
    }
  }

  Future forgetPassword({String email}) async {
    try {
      Map params = {"email": email};
      String responseBody = await postServices('forget', params);
      Map<String, dynamic> responseJson = json.decode(responseBody);
      print('forget password response  :$responseJson');
    } catch (e) {
      throw e;
    }
  }

  Future enrollInCompetition({num competitionId}) async {
    try {
      String responseBody = await postServices(
          'competitor/$competitionId/enroll-in-competition', {});
      Map<String, dynamic> responseJson = json.decode(responseBody);
      print('enroll in competition response  :$responseJson');
    } catch (e) {
      throw e;
    }
  }

  Future enrollInLevelCompetition({num competitionId}) async {
    try {
      String responseBody = await postServices(
          'competitor/$competitionId/enroll-in-competition', {});
      Map<String, dynamic> responseJson = json.decode(responseBody);
      print('enroll in competition response  :$responseJson');
    } catch (e) {
      throw e;
    }
  }

  Future editBankAccountInfo({
    String bankName,
    String accountNumber,
    num accountId,
    String ibanNumber,
  }) async {
    try {
      String responseBody;
      Map params = {
        "bank_name": bankName,
        "account_number": accountNumber,
        "iban_number": ibanNumber
      };
      User userData = await SharedPreferenceHandler.getuserData();
      if (userData.userInfo.type == 'JUDGE') {
        responseBody = await putServices(
            url: 'judge/$accountId/update-bank-account', params: params);
      } else {
        responseBody = await putServices(
            url: 'competitor/$accountId/update-bank-account', params: params);
      }

      Map<String, dynamic> responseJson = json.decode(responseBody)['data'];
      print('edit bank account response  :$responseJson');
      BankAccount bankAccount = BankAccount.fromJson(responseJson);
      return bankAccount;
    } catch (e) {
      throw e;
    }
  }

  Future addBankAccountInfo(
      {String bankName, String accountNumber, String ibanNumber}) async {
    try {
      String responseBody;
      Map params = {
        "bank_name": bankName,
        "account_number": accountNumber,
        "iban_number": ibanNumber
      };
      User userData = await SharedPreferenceHandler.getuserData();
      if (userData.userInfo.type == 'JUDGE') {
        responseBody = await postServices('judge/create-bank-account', params);
      } else {
        responseBody =
            await postServices('competitor/create-bank-account', params);
      }

      Map<String, dynamic> responseJson = json.decode(responseBody)['data'];
      print('add bank account response  :$responseJson');
      BankAccount bankAccount = BankAccount.fromJson(responseJson);
      return bankAccount;
    } catch (e) {
      throw e;
    }
  }

  Future contactUs({String subject, String message}) async {
    try {
      User userData = await SharedPreferenceHandler.getuserData();
      Map params = {
        "subject": subject,
        "email": userData.userInfo.email,
        "message": message
      };
      String responseBody = await postServices('contact', params);
      Map<String, dynamic> responseJson = json.decode(responseBody);
      print('contact us response  :$responseJson');
    } catch (e) {
      throw e;
    }
  }

  Future login({String email, String password}) async {
    try {
      Map params = {"email": email, "password": password};
      String responseBody = await postServices('login', params);
      Map<String, dynamic> responseJson = json.decode(responseBody);
      print('login responseJson  :$responseJson');
      User user = User.fromJson(responseJson);
      print('login response  :$user');
      return user;
    } catch (e) {
      throw e;
    }
  }

  attachTempParticipation(
      {String filePath, num competitionId, num fileType}) async {
    try {
      Map params = {
        "type": fileType,
        "path": filePath,
        "competition_id": competitionId
      };
      String responseBody =
          await postServices('competitor/attach-temp-participation', params);
      Map<String, dynamic> responseJson = json.decode(responseBody);
      print('attachTempParticipation response  :$responseJson');
    } catch (e) {
      throw e;
    }
  }

  attachLevelParticipation({String filePath, num levelId, num fileType}) async {
    try {
      Map params = {"type": fileType, "path": filePath, "level_id": levelId};
      String responseBody =
          await postServices('competitor/attach-material', params);
      Map<String, dynamic> responseJson = json.decode(responseBody);
      print('attachLevelParticipation response  :$responseJson');
    } catch (e) {
      throw e;
    }
  }

  getNotEnrolledCompetitions() async {
    try {
      List<Competition> competitions = [];
      String responseBody = await getServices('competitor/competitions');
      Iterable list = json.decode(responseBody)['data'];
      competitions = list.map((comp) => Competition.fromJson(comp)).toList();
      print("not enrolled competitons : $competitions");
      return competitions;
    } catch (err) {
      print("get not enrolled competitions error :$err");
      throw err;
    }
  }

  getAssignedCompetitions() async {
    try {
      User userData = await SharedPreferenceHandler.getuserData();
      List<Competition> competitions = [];
      String responseBody =
          await getServices('judge/${userData.userInfo.id}/competitions');
      Iterable list = json.decode(responseBody)['data'];
      competitions = list.map((comp) => Competition.fromJson(comp)).toList();
      print("assigned competitons : $competitions");
      return competitions;
    } catch (err) {
      print("get assigned competitions error :$err");
      throw err;
    }
  }

  getExpiredCompetitions() async {
    try {
      List<Competition> competitions = [];
      String responseBody = await getServices('judge/ended-competitions');
      Iterable list = json.decode(responseBody)['data'];
      competitions = list.map((comp) => Competition.fromJson(comp)).toList();
      print("expired competitons : $competitions");
      return competitions;
    } catch (err) {
      print("get expired competitions error :$err");
      throw err;
    }
  }

  getCountries() async {
    try {
      List<Country> countries = [];
      String responseBody = await getServices('countries');
      Iterable list = json.decode(responseBody)['data'];
      countries = list.map((country) => Country.fromJson(country)).toList();
      return countries;
    } catch (err) {
      print("get countries error :$err");
      throw err;
    }
  }

  getBankAccounts() async {
    try {
      List<BankAccount> bankAccounts = [];
      String responseBody;
      User userData = await SharedPreferenceHandler.getuserData();
      if (userData.userInfo.type == 'JUDGE') {
        responseBody = await getServices('judge/load-bank-accounts');
      } else {
        responseBody = await getServices('competitor/load-bank-accounts');
      }
      Iterable list = json.decode(responseBody)['data'];
      bankAccounts =
          list.map((account) => BankAccount.fromJson(account)).toList();
      return bankAccounts;
    } catch (err) {
      print("get bank accounts error :$err");
      throw err;
    }
  }

  getEnrolledCompetitions() async {
    try {
      List<Competition> competitions = [];
      String responseBody =
          await getServices('competitor/enrolled-in-competitions');
      Iterable list = json.decode(responseBody)['data'];
      competitions = list.map((comp) => Competition.fromJson(comp)).toList();
      print("enrolled competitons : $competitions");
      return competitions;
    } catch (err) {
      print("get enrolled competitions error :$err");
      throw err;
    }
  }

  getLevelTests({@required num levelId}) async {
    try {
      List<Test> tests = [];
      String responseBody = await getServices('judge/$levelId/tests');
      Iterable list = json.decode(responseBody)['data'];
      tests = list.map((test) => Test.fromJson(test)).toList();
      print("tests are : $tests");
      return tests;
    } catch (err) {
      print("get tests error :$err");
      throw err;
    }
  }

  getParticipationByGivenLevel({@required num levelId}) async {
    try {
      List<ParticipationLevel> participationLevels = [];
      String responseBody =
          await getServices('judge/$levelId/participations-by-given-level');
      Iterable list = json.decode(responseBody)['data'];
      participationLevels =
          list.map((item) => ParticipationLevel.fromJson(item)).toList();
      print("participationLevels are : $participationLevels");
      return participationLevels;
    } catch (err) {
      print("get participationLevels error :$err");
      throw err;
    }
  }

  getRandomParticipationToEvaluate({num levelId}) async {
    try {
      String responseBody = await getServices(
          'judge/$levelId/get-random-participation-to-evaluate');
      var responseJson = json.decode(responseBody)['data'];
      print("sss :$responseJson");
      RandomParticipation randomParticipation =
          RandomParticipation.fromJson(responseJson);
      return randomParticipation;
    } catch (err) {
      print("randomParticipation error :$err");
      throw err;
    }
  }

  getEvaluationHistory({num page = 1}) async {
    try {
      String responseBody =
          await getServices('judge/evaluation-history?page=$page');
      var responseJson = json.decode(responseBody);
      print("sss :$responseJson");
      EvaluationHistoryResponse evaluationHistoryResponse =
          EvaluationHistoryResponse.fromJson(responseJson);
      return evaluationHistoryResponse;
    } catch (err) {
      print("evaluationHistoryResponse error :$err");
      throw err;
    }
  }

  getCompetitionLevels({num competitionId}) async {
    try {
      List<CompetitionLevel> competitionLevels = [];
      String responseBody;
      User userData = await SharedPreferenceHandler.getuserData();
      if (userData.userInfo.type == 'JUDGE') {
        responseBody =
            await getServices('judge/levels/$competitionId/competition');
      } else {
        responseBody = await getServices('competitor/$competitionId/levels');
      }
      Iterable list = json.decode(responseBody)['data'];
      competitionLevels =
          list.map((level) => CompetitionLevel.fromJson(level)).toList();
      return competitionLevels;
    } catch (err) {
      print("competitionLevels error :$err");
      throw err;
    }
  }

  updateUserProfile({CreateAccount params}) async {
    print("my phone is :${params.phone}");
    try {
      User user;
      String responseBody;
      User userData = await SharedPreferenceHandler.getuserData();
      print("id :${userData.userInfo.id}");
      if (userData.userInfo.type == 'JUDGE') {
        responseBody = await putServices(
            url: "judge/${userData.userInfo.id}/update-profile",
            params: params);
      } else {
        responseBody = await putServices(
            url: "competitor/${userData.userInfo.id}/update-profile",
            params: params);
      }
      Map<String, dynamic> responseJson = json.decode(responseBody);
      print("update user response : $responseJson");
      user = User.fromJson(responseJson);
      user.accessToken = userData.accessToken;
      print(' user my loooo  :$user');
      return user;
    } catch (e) {
      throw e;
    }
  }

  getUserData() async {
    try {
      User user;
      User userData = await SharedPreferenceHandler.getuserData();
      String responseBody;
      if (userData.userInfo.type == 'JUDGE') {
        responseBody = await getServices(
            'judge/${userData.userInfo.id}?with[]=competitions&with[]=country&with[]=bankAccounts&with[]=levels&count[]=competitions&count[]=levels&count[]=bankAccounts');
      } else {
        responseBody = await getServices(
            'competitor/${userData.userInfo.id}?with[]=competitions&with[]=country&with[]=bankAccounts&with[]=levels&count[]=competitions&count[]=levels&count[]=bankAccounts');
      }

      var responseJson = json.decode(responseBody);
      user = User.fromJson(responseJson);
      user.accessToken = userData.accessToken;
      return user;
    } catch (err) {
      print("get user data error :$err");
      throw err;
    }
  }

  checkEnrollmentStatus({num competitionId}) async {
    try {
      String responseBody = await getServices(
          'competitor/$competitionId/check-enrollment-status');
      var responseJson = json.decode(responseBody)['data'];
      EnrollmentStatus enrollmentStatus =
          EnrollmentStatus.fromJson(responseJson);
      return enrollmentStatus;
    } catch (err) {
      print("checkEnrollmentStatus error :$err");
      throw err;
    }
  }

  getCompetition({num id}) async {
    try {
      String responseBody;
      User userData = await SharedPreferenceHandler.getuserData();
      if (userData.userInfo.type == 'JUDGE') {
        responseBody = await getServices('judge/$id/view-competition');
      } else {
        responseBody = await getServices('competitor/$id/view-competition');
      }
      var responseJson = json.decode(responseBody)['data'];
      Competition competition = Competition.fromJson(responseJson);
      print("lol competition :$competition");
      return competition;
    } catch (err) {
      print("get competition  error :$err");
      throw err;
    }
  }

  static Future getServices(String url, {String tag}) async {
    print('get url  is :${Constants.baseUrl}$url');
    try {
      String accessToken = await SharedPreferenceHandler.getAccessToken();
      // print(accessToken);
      Response response = await http.get('${Constants.baseUrl}$url', headers: {
        'Content-Type': 'application/json',
        'Accept-Language': await SharedPreferenceHandler.getLang() ?? 'ar',
        'Accept': 'application/json',
        'Authorization': accessToken != null ? 'Bearer $accessToken' : null
      }).timeout(Duration(seconds: 60));
      if (response.statusCode == 200) {
        return response.body;
      } else {
        var responseJson = json.decode(response.body);
        print("error stack is:$responseJson");

        ResponseError error = ResponseError.fromJson(responseJson);
        print(error.message);
        throw Exception(error.errors[0]);
      }
    } catch (err) {
      print('catch get error is :$err');
      throw err;
    }
  }

  Future putServices({
    String url,
    dynamic params,
  }) async {
    print(url);
    try {
      String accessToken = await SharedPreferenceHandler.getAccessToken();
      String request = jsonEncode(params);
      var response = await http
          .put('${Constants.baseUrl}$url',
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'Accept-Language': await SharedPreferenceHandler.getLang(),
                'Authorization':
                    accessToken != null ? 'Bearer $accessToken' : null,
              },
              body: request)
          .timeout(Duration(seconds: 60));
      if (response.statusCode == 200) {
        return response.body;
      } else {
        var responseJson = json.decode(response.body);
        print("error stack is:$responseJson");
        ResponseError error = ResponseError.fromJson(responseJson);
        print(error.message);
        print(error.errors);
        throw Exception(error);
      }
    } catch (error) {
      print("error :$error");
      throw error;
    }
  }

  Future postServices(
    String url,
    dynamic params,
  ) async {
    print('url :${Constants.baseUrl}$url');
    try {
      String accessToken = await SharedPreferenceHandler.getAccessToken();
      String request = jsonEncode(params);
      var response = await http
          .post('${Constants.baseUrl}$url',
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'Accept-Language':
                    await SharedPreferenceHandler.getLang() ?? 'ar',
                'Authorization':
                    accessToken != null ? 'Bearer $accessToken' : null,
              },
              body: request)
          .timeout(Duration(minutes: 1));
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.body;
      } else {
        var responseJson = json.decode(response.body);
        print("error stack is :$responseJson");
        ResponseError error = ResponseError.fromJson(responseJson);
        print(error.message);
        print(error.errors);
        throw Exception(error);
      }
    } catch (error) {
      print("error :$error");
      throw error;
    }
  }

  static Future deleteServices(String url) async {
    print(url);
    try {
      String accessToekn = await SharedPreferenceHandler.getAccessToken();
      Response response =
          await http.delete('${Constants.baseUrl}$url', headers: {
        'Content-Type': 'application/json',
        'Accept-Language': await SharedPreferenceHandler.getLang() ?? 'ar',
        'Accept': 'application/json',
        'Authorization': accessToekn
      }).timeout(Duration(seconds: 60));
      if (response.statusCode == 200) {
        return response.body;
      } else {
        var responseJson = json.decode(response.body);
        print("error stack is:$responseJson");
        ResponseError error = ResponseError.fromJson(responseJson);
        print(error.message);
        throw Exception(error.message);
      }
    } catch (err) {
      throw err;
    }
  }

  Future<dynamic> uploadMedia(
      {@required file, String url, BuildContext context}) async {
    CompetitionDetailsBloc competitionDetailsBloc =
        Provider.of<CompetitionDetailsBloc>(context);
    AuthenticationBloc authBloc = Provider.of<AuthenticationBloc>(context);
    print("url :${Constants.baseUrl + url}");
    final uploader = FlutterUploader();
    final taskId = await uploader.enqueue(
        url: Constants.baseUrl + url,
        files: [
          FileItem(
              filename: basename(file.path),
              savedDir: dirname(file.path),
              fieldname: "file")
        ],
        method: UploadMethod.POST,
        headers: {
          "Authorization":
              'Bearer ${await SharedPreferenceHandler.getAccessToken()}',
          'Accept': 'application/json',
          'Content-Type': 'multipart/form-data',
          'Accept-Language': 'ar',
        },
        showNotification: false,
        tag: "media");
    competitionDetailsBloc.setTaskId(val: taskId);
    authBloc.setTaskId(val: taskId);
  }

  Future multipartRequest(
      {String url,
      String method,
      dynamic requestBody,
      File file,
      String fileKey}) async {
    try {
      var uri = Uri.parse('${Constants.baseUrl}$url');
      var request = new http.MultipartRequest(method, uri);
      String token = await SharedPreferenceHandler.getAccessToken();
      Map<String, String> headers = {"Authorization": token};
      request.headers.addAll(headers);
      print(json.encode(requestBody));
      request.fields['data'] = json.encode(requestBody);
      if (file != null) {
        String imageName = path.basename(file.path);
        http.MultipartFile newFile = new http.MultipartFile.fromBytes(
            fileKey, file.readAsBytesSync(),
            filename: imageName);
        request.files.add(newFile);
      }
      var response = await request.send();
      String responseBodyString = await response.stream.bytesToString();
      print(responseBodyString);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(responseBodyString);
      } else {
        throw Exception("Failed to upload your files");
      }
    } catch (error) {
      print(error.toString());
      throw Exception("Failed to upload your files");
    }
  }
}
