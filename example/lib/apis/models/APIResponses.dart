
import 'dart:developer';

class APIResponseBase {
  String? status;
  String? message;
  APIResponseBase();

  factory APIResponseBase.fromJson(Map<String, dynamic> json) {
    var it = APIResponseBase();
    it.status = json['status'];
    it.message = json['message'];
    return it;
  }
}