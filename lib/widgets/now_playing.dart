import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marquee/marquee.dart';
import 'package:music_player_go/db/box.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../controller/controller.dart';
import '../db/songmodel.dart';

// ignore: must_be_immutable
class NowPlaying extends StatelessWidget {
  List<Audio> allsong = [];

  int index;
  NowPlaying({
    Key? key,
    required this.allsong,
    required this.index,
  }) : super(key: key);

  final AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer.withId("0");
  Songsdb? music;
  final List<StreamSubscription> subscription = [];
  final Controller _controller = Get.find();
  //final box = Boxes.getInstance();
  List<Songsdb> dbSongs = [];

  List<dynamic>? favorites = [];

  Audio find(List<Audio> source, String fromPath) {
    return source.firstWhere((element) => element.path == fromPath);
  }

  @override
  Widget build(BuildContext context) {
    //Get.put(Controller());
    dbSongs =_controller.dbSongs;
    //double myHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
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
        height: MediaQuery.of(context).size.height, //-//100,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            Color.fromARGB(255, 24, 3, 18),
            Color.fromRGBO(21, 154, 211, 1)
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: ListView(
          children: [
            assetsAudioPlayer.builderCurrent(
              builder: (context, Playing? playing) {
                final myaudio = find(allsong, playing!.audio.assetAudioPath);
                final currentSong = dbSongs.firstWhere((element) =>
                    element.id.toString() == myaudio.metas.id.toString());
                // likedSongs = box.get("favorites");
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
                        SizedBox(
                          height: 30,
                          width: 400,
                          child: Marquee(
                            text: "${myaudio.metas.title}",
                            style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold),
                            scrollAxis: Axis.horizontal,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            blankSpace: 20.0,
                            velocity: 100.0,
                            pauseAfterRound: const Duration(seconds: 80),
                            startPadding: 10.0,
                            accelerationDuration: const Duration(seconds: 1),
                            accelerationCurve: Curves.linear,
                            // ignore: prefer_const_constructors
                            decelerationDuration: Duration(milliseconds: 500),
                            decelerationCurve: Curves.easeOut,
                          ),
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
                        GetBuilder<Controller>(
                          builder: (controller) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                !controller.isShuffle
                                    ? IconButton(
                                        onPressed: () {
                                          controller.isShuffle = true;
                                          assetsAudioPlayer.toggleShuffle();
                                          controller.update();
                                        },
                                        icon: const Icon(Icons.shuffle),
                                      )
                                    : IconButton(
                                        onPressed: () {
                                          controller.isShuffle = false;
                                          assetsAudioPlayer
                                              .setLoopMode(LoopMode.playlist);
                                          controller.update();
                                        },
                                        icon: const Icon(Icons.loop_sharp),
                                      ),
                                controller.likedSongs!
                                        .where((element) =>
                                            element.id.toString() ==
                                            currentSong.id.toString())
                                        .isEmpty
                                    ? IconButton(
                                        onPressed: () async {
                                          controller
                                              .addToFavorites(currentSong);
                                          controller.update();
                                        },
                                        icon: const Icon(Icons.favorite_border),
                                      )
                                    : IconButton(
                                        onPressed: () async {
                                          removeFromFav(
                                              controller, currentSong);
                                          controller.addToFav();
                                          controller.update();
                                        },
                                        icon: const Icon(Icons.favorite),
                                      ),
                                !controller.isLooping
                                    ? IconButton(
                                        onPressed: () {
                                          controller.isLooping = true;
                                          assetsAudioPlayer
                                              .setLoopMode(LoopMode.single);
                                          controller.update();
                                        },
                                        icon: const Icon(Icons.repeat),
                                      )
                                    : IconButton(
                                        onPressed: () {
                                          controller.isLooping = false;
                                          assetsAudioPlayer
                                              .setLoopMode(LoopMode.playlist);
                                          controller.update();
                                        },
                                        icon: const Icon(Icons.repeat_one),
                                      ),
                              ],
                            );
                          },
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

  void removeFromFav(Controller controller, Songsdb currentSong) {
    return controller.likedSongs?.removeWhere(
        (element) => element.id.toString() == currentSong.id.toString());
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
