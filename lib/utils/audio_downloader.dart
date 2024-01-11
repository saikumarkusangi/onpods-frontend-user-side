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
  DownloadStatus _downloadStatus = DownloadStatus.notStarted;
  int _downloadPercentage = 0;
  String _downloadedFile = "";

  final ValueNotifier<int> downloadPercentageNotifier = ValueNotifier<int>(0);

  DownloadStatus get downloadStatus => _downloadStatus;
  String get downloadedFile => _downloadedFile;

  Future<void> downloadFileWithPoster(
      String audioUrl, String posterUrl, String filename) async {
    bool permissionReady = await _checkPermission();
    final Completer<void> completer = Completer<void>();

    if (!permissionReady) {
      await Permission.storage.request();
      completer.complete();

      return;
    }

    var audioRequest = http.Request('GET', Uri.parse(audioUrl));
    var posterRequest = http.Request('GET', Uri.parse(posterUrl));

    try {
      print('downloading starting');
      var audioResponse = await http.Client().send(audioRequest);
      var posterResponse = await http.Client().send(posterRequest);

      final dir = (await getApplicationDocumentsDirectory()).path;

      Directory('$dir/downloads/').create(recursive: true);

      List<List<int>> audioChunks = <List<int>>[];
      List<List<int>> posterChunks = <List<int>>[];
      int audioDownloaded = 0;
      int posterDownloaded = 0;

      updateDownloadStatus(DownloadStatus.started);

      _audioDownloadSubscription = audioResponse.stream.listen(
        (List<int> chunk) {
          audioChunks.add(chunk);
          audioDownloaded += chunk.length;
          _downloadPercentage =
              ((audioDownloaded / audioResponse.contentLength!) * 50).round();
          print('Audio Download Progress: $_downloadPercentage%');
          notifyListeners();
        },
      );

      _posterDownloadSubscription = posterResponse.stream.listen(
        (List<int> chunk) {
          posterChunks.add(chunk);
          posterDownloaded += chunk.length;
          _downloadPercentage = 50 +
              ((posterDownloaded / posterResponse.contentLength!) * 50).round();
          print('Poster Download Progress: $_downloadPercentage%');
          notifyListeners();
        },
      );

      await Future.wait([
        _audioDownloadSubscription.asFuture(),
        _posterDownloadSubscription.asFuture(),
      ]);

      _downloadPercentage = 100; // Ensure it's 100% when done
      notifyListeners();

      File audioFile = File('$dir/$filename.mp3');
      File posterFile = File('$dir/$filename.jpg');

      _downloadedFile = '$dir/$filename.mp3';
      print('Downloaded audio file: $_downloadedFile');

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

      await posterFile.writeAsBytes(posterBytes);

      updateDownloadStatus(DownloadStatus.completed);
      _audioDownloadSubscription.cancel();
      _posterDownloadSubscription.cancel();
      _downloadPercentage = 0;

      notifyListeners();
      print('DownloadFile: Completed');
      completer.complete();
    } catch (e) {
      print('Error during download: $e');
      updateDownloadStatus(DownloadStatus.notStarted);
      notifyListeners();
      completer.completeError(e);
    }

    await completer.future;
  }

  void updateDownloadStatus(DownloadStatus status) {
    _downloadStatus = status;
    print('updateDownloadStatus: $status');
    notifyListeners();
  }

  Future<bool> _checkPermission() async {
    var status = await Permission.storage.status;
    print(status.isGranted.toString() +
        '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
    if (status.isGranted) {
      return true;
    } else {
      var result = await Permission.storage.request();
      print(result.isGranted.toString() +
          '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
      if (result.isGranted) {
        print(result.isGranted.toString() +
            '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');

        return true;
      }
    }
    return false;
  }
}
