import 'dart:convert';

NewChatRoomModel newChatRoomModelFromJson(String str) =>
    NewChatRoomModel.fromJson(json.decode(str));

String newChatRoomModelToJson(NewChatRoomModel data) =>
    json.encode(data.toJson());

class NewChatRoomModel {
  String chatTopic;
  String roomType;
  String ownerId;

  NewChatRoomModel({
    required this.chatTopic,
    required this.roomType,
    required this.ownerId,
  });

  factory NewChatRoomModel.fromJson(Map<String, dynamic> json) =>
      NewChatRoomModel(
        chatTopic: json["chatTopic"],
        roomType: json["roomType"],
        ownerId: json["ownerId"],
      );

  Map<String, dynamic> toJson() => {
        "chatTopic": chatTopic,
        "roomType": roomType,
        "ownerId": ownerId,
      };
}
