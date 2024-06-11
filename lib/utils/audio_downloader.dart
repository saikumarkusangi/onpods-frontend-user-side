import 'dart:ffi';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';

enum DownloadStatus { notStarted, started, downloading, completed }

class FileDownloaderProvider with ChangeNotifier {
  late StreamSubscription<List<int>> _audioDownloadSubscription;
  late StreamSubscription<List<int>> _posterDownloadSubscription;
  late StreamSubscription<List<int>> _albumDownloadSubscription;
  DownloadStatus _downloadStatus = DownloadStatus.notStarted;
  int downloadPercentage = 0;
  String _downloadedFile = "";

  final ValueNotifier<int> downloadPercentageNotifier = ValueNotifier<int>(0);

  DownloadStatus get downloadStatus => _downloadStatus;
  String get downloadedFile => _downloadedFile;

  Future<void> downloadFileWithPoster(
      String audioUrl, String posterUrl, String filename,String albumImage) async {
    bool permissionReady = await _checkPermission();
    final Completer<void> completer = Completer<void>();

    if (!permissionReady) {
      await Permission.storage.request();
      completer.complete();

      return;
    }

    var audioRequest = http.Request('GET', Uri.parse(audioUrl));
    var posterRequest = http.Request('GET', Uri.parse(posterUrl));
    var albumRequest = http.Request('GET', Uri.parse(albumImage));

    try {
      var audioResponse = await http.Client().send(audioRequest);
      var posterResponse = await http.Client().send(posterRequest);
      var albumResponse = await http.Client().send(albumRequest);

      final dir = (await getApplicationDocumentsDirectory()).path;

      Directory('$dir/downloads/').create(recursive: true);

      List<List<int>> audioChunks = <List<int>>[];
      List<List<int>> posterChunks = <List<int>>[];
      List<List<int>> albumChunks = <List<int>>[];
      int audioDownloaded = 0;
      int posterDownloaded = 0;
      int albumDownloaded = 0;
    
      updateDownloadStatus(DownloadStatus.started);

      _audioDownloadSubscription = audioResponse.stream.listen(
        (List<int> chunk) {
          audioChunks.add(chunk);
          audioDownloaded += chunk.length;
          downloadPercentage =
              ((audioDownloaded / audioResponse.contentLength!) * 100).round();

          notifyListeners();
        },
      );

      _posterDownloadSubscription = posterResponse.stream.listen(
        (List<int> chunk) {
          posterChunks.add(chunk);
          posterDownloaded += chunk.length;
          downloadPercentage = 50 +
              ((posterDownloaded / posterResponse.contentLength!) * 50).round();

          notifyListeners();
        },
      );

 _albumDownloadSubscription = albumResponse.stream.listen(
        (List<int> chunk) {
          albumChunks.add(chunk);
          albumDownloaded += chunk.length;
          downloadPercentage =
              ((albumDownloaded / albumResponse.contentLength!) * 100).round();

          notifyListeners();
        },
      );

      await Future.wait([
        _audioDownloadSubscription.asFuture(),
        _posterDownloadSubscription.asFuture(),
        _albumDownloadSubscription.asFuture()
      ]);
      updateDownloadStatus(DownloadStatus.completed);

      downloadPercentage = 100;
      updateDownloadStatus(DownloadStatus.completed);
      notifyListeners();

      File audioFile = File('$dir/$filename.mp3');
      File posterFile = File('$dir/$filename.jpg');                
      File albumFile = File('$dir/$filename.png');                

      _downloadedFile = '$dir/$filename.mp3';

      final Uint8List audioBytes = Uint8List(audioResponse.contentLength!);
      int audioOffset = 0;
      for (List<int> chunk in audioChunks) {
        audioBytes.setRange(audioOffset, audioOffset + chunk.length, chunk);
        audioOffset += chunk.length;
      }

      await audioFile.writeAsBytes(audioBytes);

      final Uint8List posterBytes = Uint8List(posterResponse.contentLength!);
      int posterOffset = 0;
      for (List<int> chunk in posterChunks) {
        posterBytes.setRange(posterOffset, posterOffset + chunk.length, chunk);
        posterOffset += chunk.length;
      }
 final Uint8List albumBytes = Uint8List(albumResponse.contentLength!);
       int albumOffset = 0;
      for (List<int> chunk in albumChunks) {
        albumBytes.setRange(albumOffset, albumOffset + chunk.length, chunk);
        albumOffset += chunk.length;
      }

      await posterFile.writeAsBytes(posterBytes);
      await albumFile.writeAsBytes(albumBytes);

      updateDownloadStatus(DownloadStatus.completed);
      _audioDownloadSubscription.cancel();
      _posterDownloadSubscription.cancel();
      _albumDownloadSubscription.cancel();
      downloadPercentage = 0;

      notifyListeners();

      completer.complete();
    } catch (e) {
      updateDownloadStatus(DownloadStatus.notStarted);
      notifyListeners();
      completer.completeError(e);
    }

    await completer.future;
  }

  void updateDownloadStatus(DownloadStatus status) {
    _downloadStatus = status;

    notifyListeners();
  }

  void updateDownloadPercentage(int percentage) {
    downloadPercentage = percentage;

    notifyListeners();
  }

  Future<bool> _checkPermission() async {
    var status = await Permission.storage.status;
    if (status.isGranted) {
      return true;
    } else {
      var result = await Permission.notification.request();
      if (result.isGranted) {
        return true;
      }
    }
    return false;
  }
}
