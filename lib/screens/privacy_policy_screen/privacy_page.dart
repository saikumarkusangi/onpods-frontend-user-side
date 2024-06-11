import 'package:flutter/material.dart';
import 'package:onpods/constants/constants.dart';

class PrivacyPolicyPage extends StatelessWidget {
 
  const PrivacyPolicyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: const Text(
          'Privacy & Policy',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildSections(privacyAndPolicies),
        ),
      ),
    );
  }

  List<Widget> _buildSections(List<dynamic> sections) {
    return sections.map<Widget>((section) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              section['title'] ?? '',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              section['content'] ?? '',
              style: const TextStyle(fontSize: 16,color: Colors.white70),
            ),
            const SizedBox(height: 16),
          ],
        ),
      );
    }).toList();
  }
}
