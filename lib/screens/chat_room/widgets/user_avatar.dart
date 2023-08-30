import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final int index;
  final String name;
  
  const UserAvatar({super.key, required this.index, required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(
              'https://randomuser.me/api/portraits/men/$index.jpg'),
        ),
         Text(
          name,
          style:const TextStyle(color: Colors.white, fontSize: 14),
        )
      ],
    );
  }
}
