import 'package:flutter/material.dart';

class QuotesScreen extends StatefulWidget {
  const QuotesScreen({super.key});

  @override
  State<QuotesScreen> createState() => _QuotesScreenState();
}

class _QuotesScreenState extends State<QuotesScreen> {
  @override
  Widget build(BuildContext context) {
  return const Scaffold(
      body: Center(child: Text('quotes page',style: TextStyle(
        color: Colors.white
      ),),),
    );
  }
}