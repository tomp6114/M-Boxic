import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:music_player_go/db/box.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../db/songmodel.dart';

// ignore: must_be_immutable
class NowPlaying extends StatefulWidget {
  List<Audio> allsong = [];

  int index;
  NowPlaying({
    Key? key,
    required this.allsong,
    required this.index,
  }) : super(key: key);

  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  final AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer.withId("0");
  Songsdb? music;
  final List<StreamSubscription> subscription = [];
  final box = Boxes.getInstance();
  List<Songsdb> dbSongs = [];
  List<dynamic>? likedSongs = [];
  List<dynamic>? favorites = [];

  @override
  void initState() {
    super.initState();
    dbSongs = box.get("musics") as List<Songsdb>;
  }

  Audio find(List<Audio> source, String fromPath) {
    return source.firstWhere((element) => element.path == fromPath);
  }

  bool isPlaying = false;
  bool isLooping = false;
  bool isShuffle = false;

  @override
  Widget build(BuildContext context) {
    //double myHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_drop_down),
        ),
        backgroundColor: const Color.fromARGB(255, 24, 3, 18),
        centerTitle: true,
        title: const Text(
          'Now Playing',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            Color.fromARGB(255, 24, 3, 18),
            Color.fromRGBO(21, 154, 211, 1)
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: Column(
          children: [
            assetsAudioPlayer.builderCurrent(
              builder: (context, Playing? playing) {
                final myaudio =
                    find(widget.allsong, playing!.audio.assetAudioPath);
                final currentSong = dbSongs.firstWhere((element) =>
                    element.id.toString() == myaudio.metas.id.toString());
                likedSongs = box.get("favorites");
                String artist;
                if (myaudio.metas.artist.toString() == "<unknown>") {
                  artist = 'No artist';
                } else {
                  artist = myaudio.metas.artist.toString();
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 34.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: QueryArtworkWidget(
                            artworkBorder: BorderRadius.circular(5),
                            artworkHeight: 280,
                            artworkWidth: 280,
                            artworkFit: BoxFit.fill,
                            artworkClipBehavior: Clip.antiAliasWithSaveLayer,
                            nullArtworkWidget: Image.asset(
                              "assets/images/logo.png",
                              height: 250,
                              width: 280,
                              fit: BoxFit.cover,
                            ),
                            id: int.parse(myaudio.metas.id.toString()),
                            type: ArtworkType.AUDIO),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),
                        Text(
                          "${myaudio.metas.title}",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        Text(
                          artist,
                          style: const TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            !isShuffle
                                ? IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isShuffle = true;
                                        assetsAudioPlayer.toggleShuffle();
                                      });
                                    },
                                    icon: const Icon(Icons.shuffle),
                                  )
                                : IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isShuffle = false;
                                        assetsAudioPlayer
                                            .setLoopMode(LoopMode.playlist);
                                      });
                                    },
                                    icon: const Icon(Icons.loop_sharp),
                                  ),
                            likedSongs!
                                    .where((element) =>
                                        element.id.toString() ==
                                        currentSong.id.toString())
                                    .isEmpty
                                ? IconButton(
                                    onPressed: () async {
                                      likedSongs?.add(currentSong);
                                      box.put("favorites", likedSongs!);
                                      likedSongs = box.get("favorites");
                                      setState(() {});
                                    },
                                    icon: const Icon(Icons.favorite_border),
                                  )
                                : IconButton(
                                    onPressed: () async {
                                      setState(() {
                                        likedSongs?.removeWhere((elemet) =>
                                            elemet.id.toString() ==
                                            currentSong.id.toString());
                                        box.put("favorites", likedSongs!);
                                      });
                                    },
                                    icon: const Icon(Icons.favorite),
                                  ),
                            !isLooping
                                ? IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isLooping = true;
                                        assetsAudioPlayer
                                            .setLoopMode(LoopMode.single);
                                      });
                                    },
                                    icon: const Icon(Icons.repeat),
                                  )
                                : IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isLooping = false;
                                        assetsAudioPlayer
                                            .setLoopMode(LoopMode.playlist);
                                      });
                                    },
                                    icon: const Icon(Icons.repeat_one),
                                  ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 15.0, right: 15.0),
                          child: seekBarWidget(context),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              onPressed: () {
                                assetsAudioPlayer.previous();
                              },
                              icon: const Icon(
                                Icons.skip_previous_rounded,
                                size: 45,
                                color: Colors.white,
                              ),
                            ),
                            PlayerBuilder.isPlaying(
                              player: assetsAudioPlayer,
                              builder: (context, isPlaying) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      top: 18.0, left: 13),
                                  child: IconButton(
                                    iconSize: 70,
                                    onPressed: () async {
                                      await assetsAudioPlayer.playOrPause();
                                    },
                                    icon: Icon(
                                      isPlaying
                                          ? Icons.pause_circle_sharp
                                          : Icons.play_circle_rounded,
                                    ),
                                  ),
                                );
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: IconButton(
                                onPressed: () {
                                  assetsAudioPlayer.next();
                                },
                                icon: const Icon(
                                  Icons.skip_next_rounded,
                                  size: 45,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget seekBarWidget(BuildContext ctx) {
    return assetsAudioPlayer.builderRealtimePlayingInfos(builder: (ctx, infos) {
      Duration currentPosition = infos.currentPosition;
      Duration total = infos.duration;
      return Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: ProgressBar(
          progress: currentPosition,
          total: total,
          onSeek: (to) {
            assetsAudioPlayer.seek(to);
          },
          baseBarColor: const Color.fromARGB(255, 190, 190, 190),
          progressBarColor: const Color(0xFF32C437),
          bufferedBarColor: const Color(0xFF32C437),
          thumbColor: const Color(0xFF32C437),
        ),
      );
    });
  }
}
