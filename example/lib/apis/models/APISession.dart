
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class APISession {
  static String? access_token;
  
  static ValueNotifier<String?> access_token_reactive = ValueNotifier(access_token);

  static String? getAccessToken() {
    return access_token;
  }

  static Map<String, String>? getAPISessionHeader() {
    if (access_token != null) {
      return {
        "x-access-token": access_token!
      };
    }
    return null;
  }




  static saveSession(String? access_token) async {
    if (access_token != null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('#BARMAP_access_token', access_token);
      APISession.access_token = access_token;
      APISession.access_token_reactive.value = access_token;
    }
  }

  static loadSession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? access_token = prefs.getString('#BARMAP_access_token');
    APISession.access_token = access_token;
    APISession.access_token_reactive.value = access_token;
  }

  static removeSession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('#BARMAP_access_token');
    APISession.access_token = null;
    APISession.access_token_reactive.value = null;
  }


}