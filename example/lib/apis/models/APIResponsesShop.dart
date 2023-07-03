
import 'dart:developer';

import 'package:flutter/cupertino.dart';

import 'APIResponses.dart';

class APIResponseShopList extends APIResponseBase {
  List<Shop>? data;

  APIResponseShopList();

  factory APIResponseShopList.fromJson(Map<String, dynamic> json) {
    var it = APIResponseShopList();
    it.status = json['status'];
    it.message = json['message'];
    it.data = (json['data'] as List)?.map((item) {
      return Shop.fromJson(item);
    })?.toList();
    return it;
  }
}


class Shop {
  String? _id;
  String? qbl;
  String? name;
  String? name_en;
  String? address;
  String? address_en;
  double? latitude;
  double? longitude;
  List<double>? lnglat;

  Shop();

  String? getId() {
    return _id;
  }

  String? getName(BuildContext context) {
    return name_en;
  }

  String? getAddress(BuildContext context) {
    return address_en;
  }

  factory Shop.fromJson(Map<String, dynamic> json) {
    var it = Shop();
    it._id = json['_id'];
    it.qbl = json['qbl'];
    it.name = json['name'];
    it.name_en = json['name_en'];
    it.address = json['address'];
    it.address_en = json['address_en'];
    it.latitude = json['latitude'];
    it.longitude = json['longitude'];
    it.lnglat = json['lnglat'] != null ? (json['lnglat'] as List)?.where((element) => element != null).map((item) {
      return item as double;
    })?.toList() : null;
    return it;
  }
}

