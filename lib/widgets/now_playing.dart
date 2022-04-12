import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:music_player_go/db/box.dart';
import 'package:music_player_go/widgets/music_function.dart';

import 'package:on_audio_query/on_audio_query.dart';

import '../db/songmodel.dart';

class NowPlaying extends StatefulWidget {
  List<Audio> allsong = [];

  // List<Audio> allsong;
  // String imageurl;
  // String? header;
  // String? subhead;
  // IconButton? icon1;
  // IconButton? icon2;
  int index;
  NowPlaying({
    Key? key,
    required this.allsong,
    required this.index,
    // required this.imageurl,
    // required this.header,
    // required this.subhead,
    // this.icon1,
    // this.icon2,
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

  // final audios = <Audio>[
  //   Audio(
  //     'assets/music/Michael Jackson - Beat It.mp3',
  //     metas: Metas(
  //       id: 'Pop',
  //       title: 'Beat it',
  //       artist: 'Michael Jackson',
  //       album: 'King of Pop',
  //       image: MetasImage.asset('assets/images/mjsong.jpg'),
  //     ),
  //   ),
  //   Audio(
  //     'assets/music/Michael Jackson - Billie Jean.mp3',
  //     metas: Metas(
  //       id: 'Pop',
  //       title: 'Bille jean',
  //       artist: 'Michael Jackson',
  //       album: 'King of Pop',
  //       image: MetasImage.asset('assets/images/mj.jpg'),
  //     ),
  //   ),
  //   Audio(
  //     'assets/music/Believer Mp3 Imagine Dragons.mp3',
  //     metas: Metas(
  //       id: 'Rock',
  //       title: 'Beliver',
  //       artist: 'Imagine Dragons',
  //       album: 'Imagine Dragons',
  //       image: MetasImage.asset('assets/images/imaginedragons.webp'),
  //     ),
  //   ),
  //   Audio(
  //     'assets/music/128-Pal (Female) - Jalebi 128 Kbps.mp3',
  //     metas: Metas(
  //       id: 'Melody',
  //       title: 'Pal',
  //       artist: 'Javed-Mohsin, Shreya Ghoshal',
  //       album: 'Jalebi',
  //       image: MetasImage.asset('assets/images/pal.jpg'),
  //     ),
  //   ),
  //   Audio(
  //     'assets/music/Adele_Hello.mp3',
  //     metas: Metas(
  //       id: 'Pop',
  //       title: 'Hello',
  //       artist: 'Adele',
  //       album: 'Album 25',
  //       image: MetasImage.asset('assets/images/adelle.jpeg'),
  //     ),
  //   ),

  // ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbSongs = box.get("musics") as List<Songsdb>;
    // assetsAudioPlayer = AssetsAudioPlayer.newPlayer();
    // subscription.add(assetsAudioPlayer.playlistAudioFinished.listen((data) {
    //   print('playlistAudioFinished :$data');
    // }));
    // subscription.add(assetsAudioPlayer.audioSessionId.listen((sessionId) {
    //   print('audioSessionId : $sessionId');
    // }));
    //openPlayer();
  }

  // void openPlayer() async {
  //   await assetsAudioPlayer.open(
  //     Playlist(audios: widget.allsong, startIndex: widget.index),

  //     showNotification: true,
  //     autoStart: true,
  //     //loopMode: LoopMode.playlist,
  //     playInBackground: PlayInBackground.enabled,
  //   );
  // }

  Audio find(List<Audio> source, String fromPath) {
    return source.firstWhere((element) => element.path == fromPath);
  }

  bool isPlaying = false;
  bool _fav = false;
  bool isLooping = false;
  bool isShuffle = false;
  //IconData playbtn = Icons.pause_circle_sharp;

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
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
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        Text(
                          "$artist",
                          style: TextStyle(color: Colors.white),
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
                                  assetsAudioPlayer.setLoopMode(LoopMode.playlist);
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
                            ?IconButton(
                              onPressed: () {
                                setState(() {
                                  isLooping = true;
                                  assetsAudioPlayer.setLoopMode(LoopMode.single);
                                });
                              },
                              icon: const Icon(Icons.repeat),
                            )
                            :IconButton(
                              onPressed: () {
                                setState(() {
                                  isLooping = false;
                                  assetsAudioPlayer.setLoopMode(LoopMode.playlist);
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
                        // SizedBox(
                        //   height: MediaQuery.of(context).size.height * 0.01,
                        // ),
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
                                  padding: const EdgeInsets.only(top:18.0,left:13),
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
                              padding: const EdgeInsets.only(right:10.0),
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
                        SizedBox(
                          height: 30,
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(
                        //        left: 128.0, right: 120.0,top: 20),
                        //   child: Container(
                        //     height: 50,
                        //     width: 50,
                        //     decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(50),
                        //         color: Color.fromARGB(43, 0, 0, 0)),
                        //     child: Row(
                        //       crossAxisAlignment: CrossAxisAlignment.end,
                        //       mainAxisAlignment: MainAxisAlignment.center,
                        //       children: [
                        //         IconButton(
                        //           onPressed: () {},
                        //           icon: const Icon(
                        //             Icons.playlist_add,
                        //             color: Colors.white,
                        //             size: 30.0,
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                );
              },
            ),
            //     player.builderCurrent(
            //   builder: (context, Playing? playing) {
            //     final myAudio =
            //         find(widget.allsong, playing!.audio.assetAudioPath);

            //     // final currentSong = dbSongs.firstWhere((element) =>
            //     //     element.id.toString() == myAudio.metas.id.toString());
            //     return Container(
            //       width: MediaQuery.of(context).size.width,
            //       height: MediaQuery.of(context).size.height,
            //       child: Column(
            //         children: [
            //           Container(
            //             margin: const EdgeInsets.symmetric(
            //                 horizontal: 20, vertical: 50),
            //             decoration: BoxDecoration(
            //               borderRadius: BorderRadius.circular(20),
            //               boxShadow: const [
            //                 BoxShadow(
            //                   color: Color(0x46000000),
            //                   offset: Offset(20, 20),
            //                   spreadRadius: 0,
            //                   blurRadius: 30,
            //                 ),
            //                 BoxShadow(
            //                   color: Color(0x11000000),
            //                   offset: Offset(0, 10),
            //                   spreadRadius: 0,
            //                   blurRadius: 30,
            //                 ),
            //               ],
            //             ),
            //             child: SizedBox(
            //               width: MediaQuery.of(context).size.width * 0.7,
            //               height: MediaQuery.of(context).size.width * 0.7,
            //               child: ClipRRect(
            //                 borderRadius: BorderRadius.circular(50),
            //                 child: QueryArtworkWidget(
            //                   artworkClipBehavior: Clip.antiAliasWithSaveLayer,
            //                   artworkFit: BoxFit.fill,
            //                   nullArtworkWidget:
            //                       Image.asset('assets/images/default.jpeg'),
            //                   id: int.parse(myAudio.metas.id!),
            //                   type: ArtworkType.AUDIO,
            //                 ),

            //                 // Image(
            //                 //   image: const AssetImage('assets/images/parudeesa.jpg'),
            //                 //   width: MediaQuery.of(context).size.width * 0.7,
            //                 //   height: MediaQuery.of(context).size.width * 0.7,
            //                 //   fit: BoxFit.cover,
            //                 // ),
            //               ),
            //             ),
            //           ),

            //           // buildAnimatedText(myAudio.metas.title!),

            //           Text(
            //             myAudio.metas.title!,
            //             overflow: TextOverflow.ellipsis,

            //           ),

            //           Text(
            //             myAudio.metas.artist!,
            //             overflow: TextOverflow.ellipsis,

            //           ),

            //           const SizedBox(
            //             height: 20,
            //           ),
            //           Container(
            //             alignment: Alignment.topLeft,
            //             margin: const EdgeInsets.only(left: 10, right: 10),
            //             child: seekBarWidget(context),
            //             // Row(
            //             //   children: [
            //             //     // Expanded(
            //             //     //   child: player.builderRealtimePlayingInfos(
            //             //     //     builder: (context, RealtimePlayingInfos? infos) {
            //             //     //       if (infos == null) {
            //             //     //         return const SizedBox();
            //             //     //       }
            //             //     //       return ProgressBar(
            //             //     //         timeLabelPadding: 8,
            //             //     //         progressBarColor: Colors.white,
            //             //     //         thumbColor: Colors.white,
            //             //     //         baseBarColor: Colors.grey,
            //             //     //         progress: infos.currentPosition,
            //             //     //         total: Duration(
            //             //     //             milliseconds: currentsong!.duration!),
            //             //     //         timeLabelTextStyle:
            //             //     //             const TextStyle(color: Colors.white),
            //             //     //         onSeek: (duration) {
            //             //     //           player.seek(duration);
            //             //     //         },
            //             //     //       );
            //             //     //     },
            //             //     //   ),
            //             //     //   //   child: StreamBuilder<Duration>(
            //             //     //   //     stream: player.currentPosition,
            //             //     //   //     builder: (context, snapshot) {
            //             //     //   //       return Slider(
            //             //     //   //         max: playing.audio.duration.inMilliseconds
            //             //     //   //             .toDouble(),
            //             //     //   //         value: snapshot.data == null
            //             //     //   //             ? 0
            //             //     //   //             : snapshot.data!.inMilliseconds.toDouble(),
            //             //     //   //         onChanged: (value) {
            //             //     //   //           player.seek(
            //             //     //   //             Duration(
            //             //     //   //               milliseconds: value.round(),
            //             //     //   //             ),
            //             //     //   //           );
            //             //     //   //         },
            //             //     //   //       );
            //             //     //   //     },
            //             //     //   //   ),
            //             //     // ),

            //             //     // Text(
            //             //     //   endTime,
            //             //     //   style: GoogleFonts.poppins(fontSize: 18),
            //             //     // ),
            //             //   ],
            //             // ),
            //           ),
            //           const SizedBox(
            //             height: 40,
            //           ),
            //           Row(
            //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //             children: [
            //               IconButton(
            //                 onPressed: () {},
            //                 icon: const Icon(Icons.shuffle),
            //               ),
            //               IconButton(
            //                 onPressed: () {
            //                   setState(
            //                     () {
            //                       _fav = !_fav;
            //                     },
            //                   );
            //                 },
            //                 icon:
            //                     Icon(_fav ? Icons.favorite : Icons.favorite_border),
            //               ),
            //               IconButton(
            //                 onPressed: () {},
            //                 icon: const Icon(Icons.repeat),
            //               ),
            //             ],
            //           ),
            //           const SizedBox(
            //             height: 20,
            //           ),
            //           Row(
            //             mainAxisAlignment: MainAxisAlignment.spaceAround,
            //             children: [
            //               IconButton(
            //                 iconSize: 30,
            //                 onPressed: () {
            //                   player.previous();
            //                 },
            //                 icon: const Icon(Icons.skip_previous_rounded),
            //               ),
            //               PlayerBuilder.isPlaying(
            //                 player: player,
            //                 builder: (context, isPlaying) {
            //                   return IconButton(
            //                     iconSize: 50,
            //                     onPressed: () async {
            //                       await player.playOrPause();
            //                     },
            //                     icon: Icon(
            //                       isPlaying
            //                           ? Icons.pause
            //                           : Icons.play_arrow_rounded,
            //                     ),
            //                   );
            //                 },
            //               ),
            //               IconButton(
            //                 iconSize: 30,
            //                 onPressed: () {
            //                   player.next();
            //                 },
            //                 icon: const Icon(Icons.skip_next_rounded),
            //               ),
            //             ],
            //           ),
            //         ],
            //       ),
            //     );
            //   },
            // ),
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
          baseBarColor: Color.fromARGB(255, 190, 190, 190),
          progressBarColor: Color(0xFF32C437),
          bufferedBarColor: Color(0xFF32C437),
          thumbColor: Color(0xFF32C437),
        ),
      );
    });
  }
}
