import 'dart:async';
import 'dart:convert';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'models/APIResponses.dart';
import 'dart:developer';

import 'models/APISession.dart';

class FetchDataExceptionBarmap implements Exception {
  final bool isNetworkError;
  final bool isServerError;
  final bool isResponseError;
  final String? message;
  final String? code;
  FetchDataExceptionBarmap({this.isNetworkError = false, this.isServerError = false, this.isResponseError = false, this.message, this.code,});

  String toString() {
    var err = "Invalid exception";
    if (message != null) {
      err = message!;
    }
    else if (isNetworkError) {
      err = "Exception: network error, please check your network connectivity. ";
    }
    else if (isServerError) {
      err = "Exception: an error occured. ";
    }
    else if (isResponseError) {
      err = "Request unsuccessful. ";
    }

    if (code != null) {
      err = "${err} (${code})";
    }

    return err;
  }
}


class APISourcerBaseBarmap {
  final String baseUrl = 'ap.www.vanportdev.com:12111';

  Map<String, dynamic> responseCaches = {};

  Future<dynamic> httpGet(String apiPath, {
    Map<String, dynamic>? queryParameters,
    String? cacheKey,
    Map<String, String>? headers,
  }) async {


    if (cacheKey != null && responseCaches[cacheKey] != null) {
      return responseCaches[cacheKey];
    }

    try {
      log(apiPath);
      log("Z");
      log(queryParameters.toString());
      var uri = Uri.https(baseUrl, apiPath, queryParameters);
      // var body = jsonEncode(data);
      var response = await http.get(uri,
        headers: {
          "Content-Type": "application/json",
          ...APISession.getAPISessionHeader() ?? {},
          ...headers ?? {},
        },
        // body: body
      );
      final statusCode = response.statusCode;
      var json = jsonDecode(utf8.decode(response.bodyBytes));

      log("A");
      if (statusCode != 200 || json == null)
      {
        throw FetchDataExceptionBarmap(
          isServerError: true,
          code: "$statusCode",
        );
      }

      log("B");
      if (json["status"] != "success") {
        throw FetchDataExceptionBarmap(
          isResponseError: true,
          message: json["message"],
        );
      }

      log("C");
      if (cacheKey != null) {
        responseCaches[cacheKey] = json;
      }

      log("D");
      return json;

    } on FetchDataExceptionBarmap catch (e, stacktrace) {
      print(stacktrace.toString());
      rethrow;
    } on Exception catch (e, stacktrace) {
      print(stacktrace.toString());
      throw FetchDataExceptionBarmap(
        isNetworkError: true,
        message: "${e.toString()}",
      );
    }
  }



  Future<dynamic> httpPost(String apiPath, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
    String? cacheKey,
    Map<String, String>? headers,
  }) async {


    if (cacheKey != null && responseCaches[cacheKey] != null) {
      return responseCaches[cacheKey];
    }

    try {
      log("Z");
      var uri = Uri.https(baseUrl, apiPath, queryParameters);
      var body = jsonEncode(data ?? {});
      var __headers = {
        "Content-Type": "application/json",
        ...APISession.getAPISessionHeader() ?? {},
        ...headers ?? {},
      };
      var response = await http.post(uri,
        headers: __headers,
        body: body
      );
      final statusCode = response.statusCode;
      var json = jsonDecode(utf8.decode(response.bodyBytes));

      log("B");
      if (json["status"] != null) {
        if (json["status"] != "success") {
          log(json.toString());
          throw FetchDataExceptionBarmap(
            isResponseError: true,
            message: json["message"],
          );
        }
      }


      log("A");
      if (statusCode != 200 || json == null)
      {
        log(json.toString());
        throw FetchDataExceptionBarmap(
          isServerError: true,
          code: "$statusCode",
        );
      }


      log("C");
      if (cacheKey != null) {
        responseCaches[cacheKey] = json;
      }

      log("D");
      return json;

    } on FetchDataExceptionBarmap catch (e, stacktrace) {
      rethrow;
    } on Exception catch (e, stacktrace) {
      throw FetchDataExceptionBarmap(
        isNetworkError: true,
        message: "${e.toString()}",
      );
    }
  }

}

