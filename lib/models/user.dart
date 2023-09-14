// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
    Data data;

    UserModel({
        required this.data,
    });

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "data": data.toJson(),
    };
}

class Data {
    String username;
    String id;

    Data({
        required this.username,
        required this.id,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        username: json["username"],
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "username": username,
        "id": id,
    };
}
