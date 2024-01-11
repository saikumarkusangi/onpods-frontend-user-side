import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:onpods/screens/player/offline_player_screen.dart';
import 'package:rxdart/rxdart.dart';
import 'package:get/route_manager.dart';

class PositionData {
  const PositionData(this.position, this.bufferPosition, this.duration);
  final Duration position;
  final Duration bufferPosition;
  final Duration duration;
}

class MiniPlayerProvider extends ChangeNotifier {
  String _title = '';

  String get title => _title;

  String _podcastId = '';

  String get podcastId => _podcastId;
  String _poster = '';

  String get poster => _poster;

  List _episodes = [];
  List get episodes => _episodes;

  final player = AudioPlayer();

  Stream<PositionData>? get positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          player.positionStream,
          player.bufferedPositionStream,
          player.durationStream,
          (position, bufferPosition, duration) => PositionData(
              position, bufferPosition, duration ?? Duration.zero));

  dynamic getValue(dynamic item, String key) {
    if (item is Map<String, dynamic>) {
      return item[key];
    } else {
      // Assuming item is an object with properties
      switch (key) {
        case 'audioUrl':
          return item.audioUrl;
        case 'posterUrl':
          return item.posterUrl;
        case 'title':
          return item.title;
        case 'id':
          return item.id;
        // Add other properties as needed
        default:
          return null;
      }
    }
  }

  Future<void> play() async {
    final playList = ConcatenatingAudioSource(
      children: episodes.map((e) {
        final audioUrl = getValue(e, 'audioUrl') ?? '';
        final posterUrl = getValue(e, 'posterUrl') ?? '';
        final title = getValue(e, 'title') ?? '';
        final podcastId = getValue(e, 'id') ?? '';

        return AudioSource.uri(
          Uri.parse(audioUrl),
          tag: MediaItem(
            id: podcastId,
            album: _title,
            title: title,
            artist: '',
            artUri: Uri.parse(posterUrl ?? _poster),
          ),
        );
      }).toList(),
    );

    // Use the provider to set the current audio

    await player.setAudioSource(playList);

    player.play();
   
  }

  void updateId(id) {
    _podcastId = id;
    notifyListeners();
    print('##########################################################' +
        _podcastId);
  }

  void clearEpisodes() {
    _episodes.clear();
    notifyListeners();
    print('#########################################################');
    print(_episodes);
  }

  void update(String newTitle, String newPoster, List newEpisodes) {
    _title = newTitle;
    _poster = newPoster;
    _episodes = newEpisodes;
    notifyListeners();
    print(_episodes);
  }
}
