// To parse this JSON data, do
//
//     final dummyDataModel = dummyDataModelFromJson(jsonString);

import 'dart:convert';

List<DummyDataModel> dummyDataModelFromJson(String str) => List<DummyDataModel>.from(json.decode(str).map((x) => DummyDataModel.fromJson(x)));

String dummyDataModelToJson(List<DummyDataModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DummyDataModel {
    String name;
    String description;
    String rating;
    String posterUrl;
    String avatar;
    List<Episode> episodes;
    String id;
    String title;

    DummyDataModel({
        required this.name,
        required this.description,
        required this.rating,
        required this.posterUrl,
        required this.avatar,
        required this.episodes,
        required this.id,
        required this.title,
    });

    factory DummyDataModel.fromJson(Map<String, dynamic> json) => DummyDataModel(
        name: json["name"],
        description: json["description"],
        rating: json["rating"],
        posterUrl: json["posterUrl"],
        avatar: json["avatar"],
        episodes: List<Episode>.from(json["episodes"].map((x) => Episode.fromJson(x))),
        id: json["id"],
        title: json["title"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "rating": rating,
        "posterUrl": posterUrl,
        "avatar": avatar,
        "episodes": List<dynamic>.from(episodes.map((x) => x.toJson())),
        "id": id,
        "title": title,
    };
}

class Episode {
    String songUrl;
    String title;
    String description;

    Episode({
        required this.songUrl,
        required this.title,
        required this.description,
    });

    factory Episode.fromJson(Map<String, dynamic> json) => Episode(
        songUrl: json["songUrl"],
        title: json["title"],
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "songUrl": songUrl,
        "title": title,
        "description": description,
    };
}
