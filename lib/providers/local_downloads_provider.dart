import 'dart:io';
import 'package:onpods/utils/exports.dart';

class LocalDownloadProvider extends ChangeNotifier {
  List<File> _audioFiles = [];
  List<File> get audioFiles => _audioFiles;

  List _episodeTitles = [];
  List get episodeTitles => _episodeTitles;

  List<File> _imageFiles = [];
  List<File> get imageFiles => _imageFiles;

  updatedEpisodeTitles(title) {
    _episodeTitles.add(title);
    notifyListeners();
  }

  Future<void> loadLocalDownloads() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    String audioFolderPath = appDocPath;

    var files = Directory(audioFolderPath).listSync();

    _audioFiles = files
        .where((file) {
          _episodeTitles.add(file.path
              .toString()
              .split('/')[6]
              .toString()
              .replaceAll('.mp3', ''));

          return file is File && file.path.toString().endsWith('.mp3');
        })
        .cast<File>()
        .toList();

    notifyListeners();
  }

  checkForDownload(title) {
    return _episodeTitles.contains(title);
  }
}
