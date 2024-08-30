// To parse this JSON data, do
//
//     final data = dataFromJson(jsonString);

import 'dart:convert';

List<Data> dataFromJson(String str) => List<Data>.from(json.decode(str).map((x) => Data.fromJson(x)));

String dataToJson(List<Data> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Data {
    String? appName;
    int? appVersion;
    int? appVersionCode;
    String? appDownloadLink;
    String? appUUID;

    Data({
        this.appName,
        this.appVersion,
        this.appVersionCode,
        this.appDownloadLink,
        this.appUUID
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        appName: json["appName"],
        appVersion: json["appVersion"],
        appVersionCode: json["appVersionCode"],
        appDownloadLink : json["appDownloadLink"],
        appUUID: json["appUUID"]
    );

    Map<String, dynamic> toJson() => {
        "appName": appName,
        "appVersion": appVersion,
        "appVersionCode": appVersionCode,
        "appDownloadLink": appDownloadLink,
        "appUUID" : appUUID
    };
}
