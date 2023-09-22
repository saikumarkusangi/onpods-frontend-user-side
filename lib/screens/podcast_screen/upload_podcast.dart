import 'package:flutter/material.dart';
import 'package:onpods/utils/colors.dart';
import 'package:onpods/widgets/custom_button.dart';

class PodcastUploadPage extends StatefulWidget {
  const PodcastUploadPage({super.key});

  @override
  State<PodcastUploadPage> createState() => _PodcastUploadPageState();
}

class _PodcastUploadPageState extends State<PodcastUploadPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              const Text(
                'Add to Existing Podcast',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24),
              ),
              const SizedBox(
                height: 40,
              ),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        leading: Image.network(
                            'https://img.freepik.com/free-vector/gradient-podcast-cover-template_23-2149449551.jpg'),
                        title: const Text(
                          'Podcast Title',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        trailing: IconButton(
                            iconSize: 32,
                            onPressed: () {},
                            icon: const Icon(
                              Icons.add_circle_outline,
                              color: Colors.white,
                            )),
                      ),
                    );
                  }),
              const SizedBox(
                height: 20,
              ),
              const Text('OR',style: TextStyle(
                color: Colors.white,
                fontSize: 20
              ),),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.maxFinite, 50),
                      backgroundColor: blueColor),
                  onPressed: () {},
                  child: const Text(
                    'New Podcast',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
