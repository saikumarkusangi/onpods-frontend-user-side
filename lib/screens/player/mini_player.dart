import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:just_audio/just_audio.dart';
import 'package:marquee/marquee.dart';
import 'package:onpods/providers/mini_player_provider.dart';
import 'package:onpods/utils/exports.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({super.key});

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MiniPlayerProvider>(builder: (context, provider, _) {
      return provider.title.isNotEmpty
          ? Material(
              color: Colors.black,
              child: GestureDetector(
                onTap: () {
                  Get.to(
                      PlayerScreen(
                          poster: provider.poster,
                          title: 'title',
                          episode: 'episode',
                          playlist: provider.episodes,
                          audioUrl: 'audioUrl',
                          startingIndex: 0,
                          albumImage: provider.poster,
                          podcastId: 'podcastId',
                          episodeId: provider.podcastId),
                      transition: Transition.downToUp);
                },
                child: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: blueColor,
                    ),
                    width: 1.sw,
                    height: 70,
                    child: ListTile(
                      leading: Image.network(
                        provider.poster,
                        fit: BoxFit.cover,
                        width: 50,
                        height: 70,
                      ),
                      title: SizedBox(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Marquee(
                            text: provider.title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                            ),
                            scrollAxis: Axis.horizontal,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            blankSpace: 100.0,
                            velocity: 50.0,
                            pauseAfterRound: const Duration(seconds: 1),
                            startPadding: 10.0,
                            accelerationDuration: const Duration(seconds: 1),
                            accelerationCurve: Curves.linear,
                            decelerationDuration:
                                const Duration(milliseconds: 500),
                            decelerationCurve: Curves.easeOut,
                          ),
                        ),
                      ),
                      trailing: StreamBuilder<PlayerState>(
                        stream: provider.player.playerStateStream,
                        builder: (context, snapshot) {
                          final playerState = snapshot.data;
                          final processingState = playerState?.processingState;
                          final playing = playerState?.playing;

                          if (!(playing ?? false)) {
                            return IconButton(
                                onPressed: () {
                                  provider.player.play();
                                },
                                icon: const Icon(
                                  Icons.play_arrow_rounded,
                                  color: Colors.white,
                                  size: 42,
                                ));
                          } else if (processingState !=
                              ProcessingState.completed) {
                            return IconButton(
                                onPressed: () {
                                  provider.player.pause();
                                },
                                icon: const Icon(
                                  Icons.pause,
                                  color: Colors.white,
                                  size: 42,
                                ));
                          }
                          return const Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 42,
                          );
                        },
                      ),
                    )),
              ),
            )
          : const SizedBox();
    });
  }
}
