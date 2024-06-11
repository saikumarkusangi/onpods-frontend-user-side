import 'package:flutter/material.dart';

class CreateChatRoom extends StatelessWidget {
  const CreateChatRoom({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.black,
          title: const Text(
            'Create Chat Room',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: const Center(
          child: Text(
            "Coming Soon...",
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
        ));
  }
}
