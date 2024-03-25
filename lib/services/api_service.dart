import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../model/api_response_model.dart';

class ApiService {
  static const int timeOut = 30;

  static String token =
      "eJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyRnVsbE5hbWUiOiJUZXN0aW5nIENsaW5ldCIsIl9pZCI6IjY1Zjk2ZjliMzVjNzcyNzE3MGM2ZDY1NCIsImVtYWlsIjoidXNlci5kaWFsb2dpQGdtYWlsLmNvbSIsInJvbGUiOiJ1c2VyIiwic3Vic2NyaXB0aW9uIjoiZGVmYXVsdCIsImFjdGl2aXR5SWQiOm51bGwsImlhdCI6MTcxMTM0MDAxMywiZXhwIjoxNzQyODk3NjEzfQ.bmjZo35qBlLAD9ZWOWs8omt8SlXKKppGqaDVhx75L7k";

  static String refreshToken =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyRnVsbE5hbWUiOiJUZXN0aW5nIENsaW5ldCIsIl9pZCI6IjY1Zjk2ZjliMzVjNzcyNzE3MGM2ZDY1NCIsImVtYWlsIjoidXNlci5kaWFsb2dpQGdtYWlsLmNvbSIsInJvbGUiOiJ1c2VyIiwic3Vic2NyaXB0aW9uIjoiZGVmYXVsdCIsImlhdCI6MTcxMTM0MDAxMywiZXhwIjoxODY5MTI4MDEzfQ.B44V-jfUW8umDi6HfIq8yNUoWY1AQmwOFDlxVZakWv8";

  static bool unAuthorization = false;

  static Future<ApiResponseModel> postApi(String url, body,
      {Map<String, String>? header}) async {
    dynamic responseJson;

    Map<String, String> mainHeader = {
      'Authorization': "Bearer $token",
      // 'Accept-Language': PrefsHelper.localizationLanguageCode,
    };

    print("==================================================> url $url");
    print(
        "==================================================> url $mainHeader");

    try {
      final response = await http
          .post(Uri.parse(url), body: body, headers: header ?? mainHeader)
          .timeout(const Duration(seconds: timeOut));
      responseJson = handleResponse(response, () {});
      print(response.body);

      // }
    } on SocketException {
      // Utils.toastMessage("please, check your internet connection");

      // Get.toNamed(AppRoutes.noInternet);
      return ApiResponseModel(503, "No internet connection", '');
    } on FormatException {
      return ApiResponseModel(400, "Bad Response Request", '');
    } on TimeoutException {
      // Utils.toastMessage("please, check your internet connection");
      // Get.toNamed(AppRoutes.noInternet);

      return ApiResponseModel(408, "Request Time Out", "");
    }

    return responseJson;
  }

  ///<<<======================== Get Api ==============================>>>

  static Future<ApiResponseModel> getApi(String url,
      {Map<String, String>? header}) async {
    dynamic responseJson;

    Map<String, String> mainHeader = {
      'Authorization': "Bearer $token",
      // 'Accept-Language': PrefsHelper.localizationLanguageCode,
    };

    print("==================================================> url $url");

    try {
      final response = await http
          .get(Uri.parse(url), headers: header ?? mainHeader)
          .timeout(const Duration(seconds: timeOut));

      responseJson = await handleResponse(response, (value) async {
        var aa = await getApi(url, header: header);
        return aa;
      });

      //
      // if (isHeader) {
      // } else {
      //   // final response =
      //   //     await http.get(Uri.parse(url)).timeout(const Duration(seconds: timeOut));
      //   // responseJson = handleResponse(response);
      // }
    } on SocketException {
      // Utils.toastMessage("please, check your internet connection");
      // Get.toNamed(AppRoutes.noInternet);

      return ApiResponseModel(503, "No internet connection", '');
    } on FormatException {
      return ApiResponseModel(400, "Bad Response Request", '');
    } on TimeoutException {
      // Utils.toastMessage("please, check your internet connection");

      // Get.toNamed(AppRoutes.noInternet);

      return ApiResponseModel(408, "Request Time Out", "");
    }

    return responseJson;
  }

  ///<<<======================== Put Api ==============================>>>

  static Future<ApiResponseModel> putApi(String url, Map<String, String> body,
      {Map<String, String>? header}) async {
    dynamic responseJson;

    Map<String, String> mainHeader = {
      'Authorization': "Bearer $token",
      // 'Accept-Language': PrefsHelper.localizationLanguageCode,
    };

    try {
      final response = await http
          .put(Uri.parse(url), body: body, headers: header ?? mainHeader)
          .timeout(const Duration(seconds: timeOut));
      responseJson = handleResponse(response, () {});
    } on SocketException {
      // Utils.toastMessage("please, check your internet connection");
      // Get.toNamed(AppRoutes.noInternet);

      return ApiResponseModel(503, "No internet connection", '');
    } on FormatException {
      return ApiResponseModel(400, "Bad Response Request", '');
    } on TimeoutException {
      // Utils.toastMessage("please, check your internet connection");
      // Get.toNamed(AppRoutes.noInternet);
      return ApiResponseModel(408, "Request Time Out", "");
    }

    return responseJson;
  }

  static Future<ApiResponseModel> deleteApi(String url,
      {Map<String, String>? body, Map<String, String>? header}) async {
    dynamic responseJson;

    Map<String, String> mainHeader = {
      'Authorization': "Bearer $token",
      // 'Accept-Language': PrefsHelper.localizationLanguageCode,
    };

    try {
      if (body != null) {
        final response = await http
            .delete(Uri.parse(url), body: body, headers: header ?? mainHeader)
            .timeout(const Duration(seconds: timeOut));
        responseJson = handleResponse(response, () {});
      } else {
        final response = await http
            .delete(Uri.parse(url), headers: header ?? mainHeader)
            .timeout(const Duration(seconds: timeOut));
        responseJson = handleResponse(response, () {});
      }

      ;
    } on SocketException {
      // Get.toNamed(AppRoutes.noInternet);
      return ApiResponseModel(503, "No internet connection", '');
    } on FormatException {
      return ApiResponseModel(400, "Bad response request", '');
    } on TimeoutException {
      return ApiResponseModel(408, "Request time out", "");
    }
    return responseJson;
  }

  static dynamic handleResponse(http.Response response, callback) async {
    switch (response.statusCode) {
      case 200:
        return ApiResponseModel(response.statusCode,
            jsonDecode(response.body)['message'], response.body);
      case 201:
        return ApiResponseModel(response.statusCode,
            jsonDecode(response.body)['message'], response.body);
      case 401:
        if (!unAuthorization) {
          token = await getRefreshToken();
          return await callback(true);
        } else {
          return ApiResponseModel(response.statusCode,
              jsonDecode(response.body)['message'], response.body);
        }

      case 400:
        return ApiResponseModel(response.statusCode,
            jsonDecode(response.body)['message'], response.body);
      case 404:
        return ApiResponseModel(response.statusCode,
            jsonDecode(response.body)['message'], response.body);
      case 409:
        return ApiResponseModel(response.statusCode,
            jsonDecode(response.body)['message'], response.body);
      default:
        print(response.statusCode);
        return ApiResponseModel(response.statusCode,
            jsonDecode(response.body)['message'], response.body);
    }
  }

  static Future<String> getRefreshToken() async {
    dynamic responseJson;

    Map<String, String> mainHeader = {
      'Refresh-token': "Refresh-token $refreshToken",
      // 'Accept-Language': PrefsHelper.localizationLanguageCode,
    };

    try {
      final response = await http
          .get(
              Uri.parse(
                  "https://api.dialogi.net/api/users/sign-in-with-refresh-token"),
              headers: mainHeader)
          .timeout(const Duration(seconds: timeOut));

      print(
          "================================> accessToken ${jsonDecode(response.body)['data']['accessToken']}");
      // responseJson = handleResponse(response);

      return jsonDecode(response.body)['data']['accessToken'];
    } on SocketException {
      return " ";
    } on FormatException {
      return "";
    } on TimeoutException {
      return "";
    }

    return responseJson;
  }
}
