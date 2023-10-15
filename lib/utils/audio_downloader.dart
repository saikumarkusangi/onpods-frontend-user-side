import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:onpods/utils/exports.dart';

enum DownloadStatus { notStarted, started, downloading, completed }

class FileDownloaderProvider with ChangeNotifier {
  late StreamSubscription _downloadSubscription;
  DownloadStatus _downloadStatus = DownloadStatus.notStarted;
  int _downloadPercentage = 0;
  String _downloadedFile = "";

  int get downloadPercentage => _downloadPercentage;
  DownloadStatus get downloadStatus => _downloadStatus;
  String get downloadedFile => _downloadedFile;

  Future<void> downloadFile(String url, String filename) async {
    bool permissionReady = await _checkPermission();
    final Completer<void> completer = Completer<void>();

    if (!permissionReady) {
      print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@m');
      _checkPermission().then((hasGranted) {
        permissionReady = hasGranted;
      });
    } else {
      print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
      var httpClient = http.Client();
      var request = http.Request('GET', Uri.parse(url));
      var response = await httpClient.send(request); // Await for the response

      final dir = Platform.isAndroid
          ? '/sdcard/download'
          : (await getApplicationDocumentsDirectory()).path;

      List<List<int>> chunks = <List<int>>[];
      int downloaded = 0;

      updateDownloadStatus(DownloadStatus.started);

      _downloadSubscription = response.stream.listen((List<int> chunk) async {
        updateDownloadStatus(DownloadStatus.downloading);
        // Display percentage of completion
        print('downloadPercentage onListen: $_downloadPercentage');

        chunks.add(chunk);
        downloaded += chunk.length;
        _downloadPercentage =
            ((downloaded / response.contentLength!) * 100).round();
        notifyListeners();
      }, onDone: () async {
        // Display percentage of completion
        _downloadPercentage = 100; // Ensure it's 100% when done
        notifyListeners();
        print('downloadPercentage onDone: $_downloadPercentage');

        // Save the file
        File file = File('$dir/$filename');

        _downloadedFile = '$dir/$filename';
        print(_downloadedFile);

        final Uint8List bytes = Uint8List(response.contentLength!);
        int offset = 0;
        for (List<int> chunk in chunks) {
          bytes.setRange(offset, offset + chunk.length, chunk);
          offset += chunk.length;
        }
        await file.writeAsBytes(bytes);

        updateDownloadStatus(DownloadStatus.completed);
        _downloadSubscription.cancel();
        _downloadPercentage = 0;

        notifyListeners();
        print('DownloadFile: Completed');
        completer.complete();
      });
    }

    await completer.future;
  }

  void updateDownloadStatus(DownloadStatus status) {
    _downloadStatus = status;
    print('updateDownloadStatus: $status');
    notifyListeners();
  }

  Future<bool> _checkPermission() async {
    PermissionStatus permission = await Permission.storage.status;
    if (permission != PermissionStatus.granted) {
      var result = await Permission.storage.request();
      if (result.isGranted) {
        return true;
      }
    } else {
      return true;
    }

    return false;
  }
}
