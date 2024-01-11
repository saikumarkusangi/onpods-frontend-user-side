// To parse this JSON data, do
//
//     final PodcastModel = PodcastModelFromJson(jsonString);

import 'dart:convert';

PodcastModel PodcastModelFromJson(String str) =>
    PodcastModel.fromJson(json.decode(str));

String PodcastModelToJson(PodcastModel data) => json.encode(data.toJson());

class PodcastModel {
  int? count;
  List<Datum>? data;
  int? page;
  int? totalPages;

  PodcastModel({
    this.count,
    this.data,
    this.page,
    this.totalPages,
  });

  factory PodcastModel.fromJson(Map<String, dynamic> json) => PodcastModel(
        count: json["count"],
        data: List<Datum>.from((json["data"] as List<dynamic>? ?? [])
            .map((x) => Datum.fromJson(x))),
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
  String? totalListens;
  String? rating;

  Datum(
      {this.id,
      this.title,
      this.description,
      this.posterUrl,
      this.rating,
      this.totalListens});

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
      id: json["_id"],
      title: json["title"],
      description: json["description"],
      posterUrl: json["posterUrl"],
      totalListens: json['totalListens'],
      rating: json['rating']);

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "description": description,
        "posterUrl": posterUrl,
        "rating": rating,
        "totalListens":totalListens
      };
}
