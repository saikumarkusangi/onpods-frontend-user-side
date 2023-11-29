import 'dart:convert';

class PodcastModel {
  String? id;
  String? userId;
  String? category;
  String? title;
  String? description;
  List<Episode>? episodes;
  DateTime? createdAt;

  PodcastModel({
    this.id,
    this.userId,
    this.category,
    this.title,
    this.description,
    this.episodes,
    this.createdAt,
  });

  factory PodcastModel.fromJson(Map<String, dynamic> json) => PodcastModel(
        id: json["_id"],
        userId: json["userId"],
        category: json["category"],
        title: json["title"],
        description: json["description"],
        episodes: (json["episodes"] as List<dynamic>?)
            ?.map((x) => Episode.fromJson(x as Map<String, dynamic>))
            .toList(),
        createdAt: json["createdAt"] != null
            ? DateTime.parse(json["createdAt"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "category": category,
        "title": title,
        "description": description,
        "episodes": episodes?.map((x) => x.toJson()).toList(),
        "createdAt": createdAt?.toIso8601String(),
      };
}

class Episode {
  String? title;
  String? description;
  String? id;
  String? audioUrl;
  String? posterUrl;

  Episode({
    this.title,
    this.description,
    this.id,
    this.audioUrl,
    this.posterUrl,
  });

  factory Episode.fromJson(Map<String, dynamic> json) => Episode(
        title: json["title"],
        description: json["description"],
        id: json["_id"],
        audioUrl: json["audioUrl"],
        posterUrl: json["posterUrl"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "_id": id,
        "audioUrl": audioUrl,
        "posterUrl": posterUrl,
      };
}

// To parse this JSON data, do
//
//     final podcastModel = podcastModelFromJson(jsonString);

PodcastModel podcastModelFromJson(String str) =>
    PodcastModel.fromJson(json.decode(str) as Map<String, dynamic>);

String podcastModelToJson(PodcastModel data) =>
    json.encode(data.toJson() as Map<String, dynamic>);
