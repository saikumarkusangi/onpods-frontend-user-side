// To parse this JSON data, do
//
//     final podcastCategoryModel = podcastCategoryModelFromJson(jsonString);

import 'dart:convert';

PodcastCategoryModel podcastCategoryModelFromJson(String str) => PodcastCategoryModel.fromJson(json.decode(str));

String podcastCategoryModelToJson(PodcastCategoryModel data) => json.encode(data.toJson());

class PodcastCategoryModel {
    String id;
    String name;
    String imageUrl;
    String color;

    PodcastCategoryModel({
        required this.id,
        required this.name,
        required this.imageUrl,
        required this.color,
    });

    factory PodcastCategoryModel.fromJson(Map<String, dynamic> json) => PodcastCategoryModel(
        id: json["_id"],
        name: json["name"],
        imageUrl: json["imageUrl"],
        color: json["color"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "imageUrl": imageUrl,
        "color": color,
    };
}
