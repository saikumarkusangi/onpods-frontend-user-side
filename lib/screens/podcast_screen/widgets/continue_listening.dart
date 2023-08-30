import 'package:flutter/material.dart';

class ContinueListening extends StatefulWidget {
  const ContinueListening({super.key});

  @override
  State<ContinueListening> createState() => _ContinueListeningState();
}

class _ContinueListeningState extends State<ContinueListening> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
       Text(
          'Continue Listening',
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
      ],
    );
  }
}