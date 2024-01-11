// To parse this JSON data, do
//
//     final bannerModel = bannerModelFromJson(jsonString);

import 'dart:convert';

List<BannerModel> bannerModelFromJson(String str) => List<BannerModel>.from(json.decode(str).map((x) => BannerModel.fromJson(x)));

String bannerModelToJson(List<BannerModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BannerModel {
    String id;
    String posterUrl;
    String title;
    String description;
    bool addedToMyList;

    BannerModel({
        required this.id,
        required this.posterUrl,
        required this.title,
        required this.description,
        required this.addedToMyList,
    });

    factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
        id: json["_id"],
        posterUrl: json["posterUrl"],
        title: json["title"],
        description: json["description"],
        addedToMyList: json["addedToMyList"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "posterUrl": posterUrl,
        "title": title,
        "description": description,
        "addedToMyList": addedToMyList,
    };
}
