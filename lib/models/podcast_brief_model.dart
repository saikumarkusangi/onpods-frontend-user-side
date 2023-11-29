// To parse this JSON data, do
//
//     final podcastBriefModel = podcastBriefModelFromJson(jsonString);

import 'dart:convert';

PodcastBriefModel podcastBriefModelFromJson(String str) =>
    PodcastBriefModel.fromJson(json.decode(str));

String podcastBriefModelToJson(PodcastBriefModel data) =>
    json.encode(data.toJson());

class PodcastBriefModel {
  int? count;
  List<Datum>? data;
  int? page;
  int? totalPages;

  PodcastBriefModel({
    this.count,
    this.data,
    this.page,
    this.totalPages,
  });

  factory PodcastBriefModel.fromJson(Map<String, dynamic> json) =>
      PodcastBriefModel(
        count: json["count"],
        data: List<Datum>.from(
            (json["data"] as List<dynamic>? ?? []).map((x) =>
                Datum.fromJson(x))),
        page: json["page"],
        totalPages: json["totalPages"],
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "data": List<dynamic>.from(data?.map((x) => x.toJson()) ?? []),
        "page": page,
        "totalPages": totalPages,
      };
}

class Datum {
  String? id;
  String? title;
  String? description;
  String? posterUrl;

  Datum({
    this.id,
    this.title,
    this.description,
    this.posterUrl,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        title: json["title"],
        description: json["description"],
        posterUrl: json["posterUrl"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "description": description,
        "posterUrl": posterUrl,
      };
}
