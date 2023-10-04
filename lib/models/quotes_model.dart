// To parse this JSON data, do
//
//     final QuotesModel = QuotesModelFromJson(jsonString);

import 'dart:convert';

List<QuotesModel> QuotesModelFromJson(String str) => List<QuotesModel>.from(
    json.decode(str).map((x) => QuotesModel.fromJson(x)));

String QuotesModelToJson(List<QuotesModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class QuotesModel {
  int count;
  int totalPages;
  int page;
  List<data> datas;

  QuotesModel({
    required this.count,
    required this.totalPages,
    required this.page,
    required this.datas,
  });

  factory QuotesModel.fromJson(Map<String, dynamic> json) => QuotesModel(
        count: json["count"],
        totalPages: json["totalPages"],
        page: json["page"],
        datas: List<data>.from(json["data"].map((x) => data.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "totalPages": totalPages,
        "page": page,
        "datas": List<dynamic>.from(datas.map((x) => x.toJson())),
      };
}

class data {
  String userId;
  String imageUrl;
  String category;
  String createdAt;
  String id;

  data(
      {required this.id,
      required this.userId,
      required this.imageUrl,
      required this.category,
      required this.createdAt});

  factory data.fromJson(Map<String, dynamic> json) => data(
      id: json["_id"] ?? '',
      userId: json["userId"] ?? '',
      imageUrl: json["imageUrl"] ?? '',
      category: json["category"] ?? '',
      createdAt: json["createdAt"] ?? '');

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "imageUrl": imageUrl,
        "category": category,
        "createdAt": createdAt
      };
}
