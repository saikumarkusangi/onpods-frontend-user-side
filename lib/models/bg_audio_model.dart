import 'dart:convert';

List<BgModel> bgModelFromJson(String str) =>
    List<BgModel>.from(json.decode(str).map((x) => BgModel.fromJson(x)));

String bgModelToJson(List<BgModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BgModel {
  String id;
  String category;
  List<Datum> data;

  BgModel({
    required this.id,
    required this.category,
    required this.data,
  });

  factory BgModel.fromJson(Map<String, dynamic> json) => BgModel(
        id: json["_id"],
        category: json["category"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "category": category,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  String name;
  String audioUrl;
  String id;

  Datum({
    required this.name,
    required this.audioUrl,
    required this.id,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        name: json["name"] ?? 'undefined',
        audioUrl: json["audioUrl"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "audioUrl": audioUrl,
        "_id": id,
      };
}
