import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'APISourcerBaseBarmap.dart';
import 'models/APIResponses.dart';
import 'models/APIResponsesShop.dart';

class APISourcerShops {
  Future<List<Shop>?> get_shops({
    required Map<String, dynamic> query,
    int limit = 20,
    int skip = 0,
  }) async {
    try {
      Map<String, dynamic> params = {
        "query": "${jsonEncode(query)}",
        "limit": "${limit}",
        "skip": "${skip}",
      };

      var json = await APISourcerBaseBarmap().httpGet(
        '/api/shops',
        queryParameters: params,
      );
      log(json.toString());

      var obj = APIResponseShopList.fromJson(json);
      return obj.data;
    } on FetchDataExceptionBarmap catch (e, stacktrace) {
      log(e.toString());
      log(stacktrace.toString());
      rethrow;
    } catch (e, stacktrace) {
      log(e.toString());
      log(stacktrace.toString());
      throw FetchDataExceptionBarmap(
        message: "${e.toString()}, ${stacktrace.toString()}",
      );
    }
  }


}

