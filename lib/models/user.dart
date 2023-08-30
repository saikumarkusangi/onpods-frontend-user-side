import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String message;
  User user;

  UserModel({
    required this.message,
    required this.user,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        message: json["message"] ?? "No message available", // Provide a default message
        user: User.fromJson(json["user"] ?? {}), // Provide an empty object as default
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "user": user.toJson(),
      };
}

class User {
  Favorites savedHistory;
  Favorites favorites;
  bool verified;
  String id;
  String userName;
  String userEmail;
  String userPassword;
  String userRole;
  bool isPublic;
  DateTime registeredDate;
  int v;
  List<String> followers;
  List<String> following;
  List<String> interests;
  String userProfilePic;
  List<String> userDownloads;
  List<String> userPlayedHistory;

  User({
    required this.savedHistory,
    required this.favorites,
    required this.verified,
    required this.id,
    required this.userName,
    required this.userEmail,
    required this.userPassword,
    required this.userRole,
    required this.isPublic,
    required this.registeredDate,
    required this.v,
    required this.followers,
    required this.following,
    required this.interests,
    required this.userProfilePic,
    required this.userDownloads,
    required this.userPlayedHistory,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        savedHistory: Favorites.fromJson(json["saved_history"] ?? {}), // Provide an empty object as default
        favorites: Favorites.fromJson(json["favorites"] ?? {}), // Provide an empty object as default
        verified: json["verified"] ?? false, // Provide a default value
        id: json["_id"] ?? "",
        userName: json["user_name"] ?? "",
        userEmail: json["user_email"] ?? "",
        userPassword: json["user_password"] ?? "",
        userRole: json["user_role"] ?? "",
        isPublic: json["is_public"] ?? false, // Provide a default value
        registeredDate: json["registered_date"] != null
            ? DateTime.parse(json["registered_date"])
            : DateTime.now(), // Provide a default value
        v: json["__v"] ?? 0, // Provide a default value
        followers: List<String>.from(json["followers"] ?? []),
        following: List<String>.from(json["following"] ?? []),
        interests: List<String>.from(json["interests"] ?? []),
        userProfilePic: json["user_profile_pic"] ?? "https://stickerly.pstatic.net/sticker_pack/Y61nTUogwQGJK8vjhqjY2g/6YBDVS/2/7f647b6b-3351-49ad-8e7d-1fdd627453b4.png",
        userDownloads: List<String>.from(json["user_downloads"] ?? []),
        userPlayedHistory: List<String>.from(json["user_played_history"] ?? []),
      );

  Map<String, dynamic> toJson() => {
        "saved_history": savedHistory.toJson(),
        "favorites": favorites.toJson(),
        "verified": verified,
        "_id": id,
        "user_name": userName,
        "user_email": userEmail,
        "user_password": userPassword,
        "user_role": userRole,
        "is_public": isPublic,
        "registered_date": registeredDate.toIso8601String(),
        "__v": v,
        "followers": followers,
        "following": following,
        "interests": interests,
        "user_profile_pic": userProfilePic,
        "user_downloads": userDownloads,
        "user_played_history": userPlayedHistory,
      };
}

class Favorites {
  List<String> episode;
  List<String> podcasts;
  List<String> posts;

  Favorites({
    required this.episode,
    required this.podcasts,
    required this.posts,
  });

  factory Favorites.fromJson(Map<String, dynamic> json) => Favorites(
        episode: List<String>.from(json["episode"] ?? []), 
        podcasts: List<String>.from(json["podcasts"] ?? []), 
        posts: List<String>.from(json["posts"] ?? []), 
      );

  Map<String, dynamic> toJson() => {
        "episode": episode,
        "podcasts": podcasts,
        "posts": posts,
      };
}
