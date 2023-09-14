import 'package:flutter/material.dart';

class ChatRoomProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // ---------------------------- New Chat Room -----------------------------------------

  Future<void> createChatRoom(chatTopic, roomType, ownerId) async {
    _isLoading = true;
    notifyListeners();
    try {} catch (error) {
      throw Exception(error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
