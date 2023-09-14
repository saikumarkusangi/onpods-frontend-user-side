// To parse this JSON data, do
//
//     final quotesCategoryModel = quotesCategoryModelFromJson(jsonString);

import 'dart:convert';

List<QuotesCategoryModel> quotesCategoryModelFromJson(String str) => List<QuotesCategoryModel>.from(json.decode(str).map((x) => QuotesCategoryModel.fromJson(x)));

String quotesCategoryModelToJson(List<QuotesCategoryModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class QuotesCategoryModel {
    String id;
    String name;
    String imageUrl;

    QuotesCategoryModel({
        required this.id,
        required this.name,
        required this.imageUrl,
    });

    factory QuotesCategoryModel.fromJson(Map<String, dynamic> json) => QuotesCategoryModel(
        id: json["_id"],
        name: json["name"],
        imageUrl: json["imageUrl"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "imageUrl": imageUrl,
    };
}
