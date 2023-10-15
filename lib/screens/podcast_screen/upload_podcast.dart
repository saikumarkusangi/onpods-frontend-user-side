import 'dart:io';
import 'package:onpods/utils/exports.dart';


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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  'New Episode',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24),
                ),
              ),
              const SizedBox(
                height: 20,
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
                          maxLines: 2,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              overflow: TextOverflow.ellipsis),
                        ),
                        trailing: IconButton(
                            iconSize: 32,
                            onPressed: () => Get.to(
                                const FinalUploadPage(
                                  poster:
                                      'https://img.freepik.com/free-vector/gradient-podcast-cover-template_23-2149449551.jpg',
                                ),
                                transition: Transition.cupertino),
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                            )),
                      ),
                    );
                  }),
              const SizedBox(
                height: 20,
              ),
              const Center(
                child: Text(
                  'OR',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
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

class FinalUploadPage extends StatefulWidget {
  const FinalUploadPage({super.key, required this.poster});
  final String poster;
  @override
  FinalUploadPageState createState() => FinalUploadPageState();
}

class FinalUploadPageState extends State<FinalUploadPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
String imagePath = '';
  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void handleUpload() {
    // Implement your upload logic here
    String title = titleController.text;
    String description = descriptionController.text;
  }
  
  Future<void> _pickImage() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
   setState(() {
     imagePath = pickedFile.path;
   });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: blueColor,
        title: const Text(
          'Episode Details',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: SingleChildScrollView(
          reverse: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              Stack(
                children: [
                      ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child:imagePath.isNotEmpty
                        ? Image.file(
                            File(imagePath),
                            height: 200,
                            width: double.maxFinite,
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                        widget.poster,
                        height: 200,
                        width: double.maxFinite,
                        fit: BoxFit.cover,
                      )),
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: blueColor,
                            borderRadius: BorderRadius.circular(100)
                          ),
                          child: IconButton(
                            color: blueColor,
                            onPressed:_pickImage, icon: const Icon(Icons.edit,color: Colors.white,)),
                        ),
                      )
                    ],
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                style: const TextStyle(color: Colors.white),
                controller: titleController,
                decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: blueColor)),
                  labelStyle: TextStyle(color: Colors.white),
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                style: const TextStyle(color: Colors.white),
                controller: descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelStyle: TextStyle(color: Colors.white),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: blueColor)),
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: handleUpload,
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16.0), backgroundColor: blueColor),
          child: const Text(
            'Upload',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
