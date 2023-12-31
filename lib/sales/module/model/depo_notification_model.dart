// To parse this JSON data, do
//
//     final depositNotificationModel = depositNotificationModelFromJson(jsonString);

import 'dart:convert';

List<DepositNotificationModel> depositNotificationModelFromJson(String str) =>
    List<DepositNotificationModel>.from(
        json.decode(str).map((x) => DepositNotificationModel.fromJson(x)));

String depositNotificationModelToJson(List<DepositNotificationModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DepositNotificationModel {
  String xdepositnum;
  String xdate;
  String xcus;
  String cusname;
  String xstatus;
  String xbank;
  String bankName;
  String xbranch;
  String xdepositref;
  String xamount;

  DepositNotificationModel({
    required this.xdepositnum,
    required this.xdate,
    required this.xcus,
    required this.cusname,
    required this.xstatus,
    required this.xbank,
    required this.bankName,
    required this.xbranch,
    required this.xdepositref,
    required this.xamount,
  });

  factory DepositNotificationModel.fromJson(Map<String, dynamic> json) =>
      DepositNotificationModel(
        xdepositnum: json["xdepositnum"],
        xdate: json["xdate"],
        xcus: json["xcus"],
        cusname: json["cusname"],
        xstatus: json["xstatus"],
        xbank: json["xbank"],
        bankName: json["bankName"],
        xbranch: json["xbranch"],
        xdepositref: json["xdepositref"],
        xamount: json["xamount"],
      );

  Map<String, dynamic> toJson() => {
        "xdepositnum": xdepositnum,
        "xdate": xdate,
        "xcus": xcus,
        "cusname": cusname,
        "xstatus": xstatus,
        "xbank": xbank,
        "bankName": bankName,
        "xbranch": xbranch,
        "xdepositref": xdepositref,
        "xamount": xamount,
      };
}
