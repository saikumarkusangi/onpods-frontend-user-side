import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:onpods/utils/images.dart';

class DownloadItem {
  final String taskId;
  final String filename;
  final String thumbnailUrl;
  final double progress;

  DownloadItem({
    required this.taskId,
    required this.filename,
    required this.thumbnailUrl,
    required this.progress,
  });
}

class DownloadsPage extends StatefulWidget {
  const DownloadsPage({super.key});

  @override
  _DownloadsPageState createState() => _DownloadsPageState();
}

class _DownloadsPageState extends State<DownloadsPage> {
  List<DownloadItem> downloadItems = [];

  @override
  void initState() {
    super.initState();
    loadDownloadTasks();
  }

  Future<void> loadDownloadTasks() async {
    final tasks = await FlutterDownloader.loadTasks();
    downloadItems = tasks!.map((task) {
      return DownloadItem(
        taskId: task.taskId,
        filename: task.filename!,
        thumbnailUrl: 'your_thumbnail_url_here',
        progress: task.progress.toDouble(),
      );
    }).toList();
    setState(() {});
  }

  Future<void> deleteDownloadTask(String taskId) async {
    await FlutterDownloader.remove(taskId: taskId, shouldDeleteContent: true);
    downloadItems.removeWhere((item) => item.taskId == taskId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: const Text(
          'Downloads',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: downloadItems.isEmpty
          ? Column(
            children: [
            Image.asset(emptyImage,scale:2.5),
              const Center(
                child: Text(
                  'No Downloads Available.',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: Text(
                    'Explore and download your favourite podcasts and listen when your offline.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 14,
                    ),
                  ),
                ),
              )
            ],
          )
          : ListView.builder(
              itemCount: downloadItems.length,
              itemBuilder: (context, index) {
                final item = downloadItems[index];
                return DownloadItemWidget(
                    item: item, onDelete: deleteDownloadTask);
              },
            ),
    );
  }
}

class DownloadItemWidget extends StatelessWidget {
  final DownloadItem item;
  final void Function(String) onDelete;

  const DownloadItemWidget({
    super.key,
    required this.item,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CachedNetworkImage(
        imageUrl: item.thumbnailUrl,
        placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) => const Icon(Icons.error),
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      ),
      title: Text(item.filename),
      subtitle: Text('${(item.progress / 100).toStringAsFixed(2)}%'),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () => onDelete(item.taskId),
      ),
    );
  }
}
