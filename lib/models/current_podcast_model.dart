// To parse this JSON data, do
//
//     final currentPodcastModel = currentPodcastModelFromJson(jsonString);

import 'dart:convert';

CurrentPodcastModel currentPodcastModelFromJson(String str) =>
    CurrentPodcastModel.fromJson(json.decode(str));

String currentPodcastModelToJson(CurrentPodcastModel data) =>
    json.encode(data.toJson());

class CurrentPodcastModel {
  User user;
  String categoryId;
  DateTime createdAt;
  String followers;
  bool following;
  double rating;
  String rated;
  String certificate;
  String totalListens;
  List<Episode> episodes;
  bool addedToMyList;

  CurrentPodcastModel(
      {required this.user,
      required this.categoryId,
      required this.createdAt,
      required this.followers,
      required this.following,
      required this.rating,
      required this.rated,
      required this.episodes,
      required this.totalListens,
      required this.addedToMyList,
      required this.certificate});

  factory CurrentPodcastModel.fromJson(Map<String, dynamic> json) =>
      CurrentPodcastModel(
        user: User.fromJson(json["user"]),
        categoryId: json["categoryId"],
        createdAt: DateTime.parse(json["createdAt"]),
        followers: json["followers"],
        following: json["following"] ?? false,
        rating: json["rating"]?.toDouble() ?? 0,
        rated: json["rated"] ?? '0',
        certificate: json['certificate'],
        totalListens: json['totalListens'],
        addedToMyList:json['addedToMyList'],
        episodes: List<Episode>.from(
            json["episodes"].map((x) => Episode.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "categoryId": categoryId,
        "createdAt": createdAt.toIso8601String(),
        "followers": followers,
        "following": following,
        "rating": rating,
        "rated": rated,
        "totalListens": totalListens,
        "certificate": certificate,
        "addedToMyList":addedToMyList,
        "episodes": List<dynamic>.from(episodes.map((x) => x.toJson())),
      };
}

class Episode {
  String title;
  String description;
  String audioUrl;
  String posterUrl;
  String id;
  int listens;

  Episode({
    required this.title,
    required this.description,
    required this.audioUrl,
    required this.posterUrl,
    required this.id,
    required this.listens,
  });

  factory Episode.fromJson(Map<String, dynamic> json) => Episode(
        title: json["title"],
        description: json["description"],
        audioUrl: json["audioUrl"],
        posterUrl: json["posterUrl"] ?? '',
        id: json["_id"],
        listens: json["listens"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "audioUrl": audioUrl,
        "posterUrl": posterUrl,
        "_id": id,
        "listens": listens,
      };
}

class User {
  String id;
  String username;
  String profilePic;

  User({
    required this.id,
    required this.username,
    required this.profilePic,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        username: json["username"],
        profilePic: json["profilePic"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "username": username,
        "profilePic": profilePic,
      };
}
