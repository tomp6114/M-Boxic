import 'dart:ui';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:music_player_go/db/songmodel.dart';
import 'package:music_player_go/openassetaudio/openassetaudio.dart';
import 'package:music_player_go/screens/settings_screen.dart';
import 'package:music_player_go/widgets/now_playing.dart';
import 'package:music_player_go/widgets/songs.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../db/box.dart';

import '../widgets/buildsheet.dart';
import '../widgets/snakbars.dart';

class HomeScreen extends StatefulWidget {
  List<Audio> allsong = [];
  // Playlist playlist = Playlist();

  // void createPlayList(){
  //   playlist.audios.addAll(allsong);
  // }

  HomeScreen({Key? key, required this.allsong}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List? dbSongs = [];
  List playlists = [];
  List<dynamic>? favorites = [];
  String? playlistName = '';
  List<dynamic>? likedSongs = [];
  Color background = Colors.transparent;

  final box = Boxes.getInstance();
  final AssetsAudioPlayer assetAudioPlayer = AssetsAudioPlayer.withId("0");
  final audioQuery = OnAudioQuery();

  Audio find(List<Audio> source, String fromPath) {
    return source.firstWhere((element) => element.path == fromPath);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbSongs = box.get("musics");
    likedSongs = box.get("favorites");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        elevation: 0,
        title: const Padding(
          padding: EdgeInsets.only(
            left: 10.0,
          ),
          child: Text(
            'Home',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 24, 3, 18),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 30.0,
            ),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) {
                      return SettingsScreen();
                    },
                  ),
                );
              },
              icon: const Icon(
                Icons.settings_outlined,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    //   appBar: AppBar(
    //     elevation: 0,
    //   title:
    //       Padding(padding: const EdgeInsets.only(
    //           left: 30.0,
    //         ),child: const Text("Home", style: TextStyle(color: Colors.white))),
    //   backgroundColor: Color.fromARGB(255, 36, 33, 75),
    //   flexibleSpace: Container(
    //     decoration: const BoxDecoration(
    //       gradient: LinearGradient(
    //         colors: [Color.fromARGB(255, 11, 4, 88), Color(0xff6D28D9)],
    //         stops: [0.5, 1.0],
    //       ),
    //     ),
    //   ),
    //   actions: [
    //     Padding(
    //         padding: const EdgeInsets.only(
    //           right: 30.0,
    //         ),
    //         child: IconButton(
    //           onPressed: () {
    //             Navigator.of(context).push(
    //               MaterialPageRoute(
    //                 builder: (ctx) {
    //                   return SettingsScreen();
    //                 },
    //               ),
    //             );
    //           },
    //           icon: const Icon(
    //             Icons.settings_outlined,
    //             color: Colors.white,
    //           ),
    //         ),
    //       ),
    //   ],
    // ),
      body: Container(
        height: 900,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            Color.fromARGB(255, 24, 3, 18),
            Color.fromRGBO(21, 154, 211, 1)
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: Container(
        child: Padding(
          padding: const EdgeInsets.only(left:15.0,right: 15.0),
          child: Stack(
            children: [
              ListView.builder(
                itemCount: widget.allsong.length,
                itemBuilder: (BuildContext context, int index) {
                  String artist;
                  if (widget.allsong[index].metas.artist.toString() == "<unknown>") {
                    artist = 'No artist';
                  } else {
                    artist = widget.allsong[index].metas.artist.toString();
                  }
                  return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: QueryArtworkWidget(
                        artworkHeight: 50,
                        artworkWidth: 50,
                        artworkFit: BoxFit.contain,
                        nullArtworkWidget: Image.asset(
                          "assets/images/logo1.png",
                          height: 55,
                          width: 55,
                          fit: BoxFit.cover,
                        ),
                        id: int.parse(
                            widget.allsong[index].metas.id.toString()),
                        type: ArtworkType.AUDIO),
                  ),
                  title: Text(
                    widget.allsong[index].metas.title.toString(),
                    style: TextStyle(
                        color: Color.fromARGB(255, 251, 252, 251),
                        fontSize: 15),
                  ),
                  subtitle: Text(
                    artist ,
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                  onTap: () async {
                    OpenAssetAudio(allsong: widget.allsong, index: index)
                        .openAsset(index: index, audios: widget.allsong);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return NowPlaying(
                            index: index,
                            allsong: widget.allsong,
                          );
                        },
                      ),
                    );
                  },
                  onLongPress: () => showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      likedSongs = box.get("favorites");
                      return Dialog(
                          backgroundColor:
                              Color.fromARGB(131, 5, 0, 0).withOpacity(1.0),
                          // shape: RoundedRectangleBorder(
                          //   borderRadius: BorderRadius.circular(50),
                          // ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.allsong[index].metas.title
                                        .toString(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 106, 211, 106),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  ListTile(
                                    title: const Text(
                                      "Add to Playlist",
                                      style: TextStyle(
                                          color: Color.fromARGB(255, 250, 249, 249), fontSize: 18),
                                    ),
                                    // trailing: const Icon(Icons.add),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      showModalBottomSheet(
                                          backgroundColor: Color.fromARGB(97, 0, 0, 0),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top:
                                                          Radius.circular(30))),
                                          context: context,
                                          builder: (context) => BuildSheet(
                                              song: widget.allsong[index])
                                          // buildSheet(song: dbSongs[index]),
                                          );
                                      // Navigator.push(context, MaterialPageRoute(builder: (context){
                                      //   return BuildSheet(song: widget.allsong[index],);
                                      // }));
                                    },
                                  ),
                                  likedSongs!
                                          .where((element) =>
                                              element.id.toString() ==
                                              dbSongs![index].id.toString())
                                          .isEmpty
                                      ? ListTile(
                                          title: const Text(
                                            "Add to Favorites",
                                            style: TextStyle(
                                                color: Color.fromARGB(255, 252, 250, 250),
                                                fontSize: 18),
                                          ),
                                          onTap: () async {
                                            final songs = box.get("musics")
                                                as List<Songsdb>;
                                            final temp = songs.firstWhere(
                                                (element) =>
                                                    element.id.toString() ==
                                                    widget
                                                        .allsong[index].metas.id
                                                        .toString());
                                            favorites = likedSongs;
                                            favorites?.add(temp);
                                            box.put("favorites", favorites!);

                                            Navigator.of(context).pop();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                                    SnackBars().likedAdd);
                                          },
                                        )
                                      : ListTile(
                                          title: const Text(
                                              "Remove from Favorites"),
                                          trailing: const Icon(
                                            Icons.favorite_rounded,
                                            color: Colors.redAccent,
                                          ),
                                          onTap: () async {
                                            likedSongs?.removeWhere((elemet) =>
                                                elemet.id.toString() ==
                                                dbSongs![index].id.toString());
                                            await box.put(
                                                "favorites", likedSongs!);
                                            setState(() {});

                                            Navigator.of(context).pop();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                                    SnackBars().likedRemove);
                                          },
                                        ),
                                ]),
                          ));
                    },
                  ),
                );
                },
              ),
            ],
          ),
        ),
      )
      ),
      // body: Container(
      // // Place as the child widget of a scaffold
      // width: double.infinity,
      // height: double.infinity,
      // decoration: const BoxDecoration(
      //   image: DecorationImage(
      //     image: NetworkImage(
      //         "https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/backgrounds%2Fluke-chesser-3rWagdKBF7U-unsplash.jpg?alt=media&token=9c5fd84c-2d31-4772-91c5-6e2be82797ba"),
      //     fit: BoxFit.cover,
      //   ),
      // ),
      // child:  // Place child here
      // )
    );
  }
}

// Padding libraryList({required child}) {
//   return Padding(
//       padding: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
//       child: child);
// }

Widget dialogContainer(Widget child) {
  return ClipRRect(
    borderRadius: const BorderRadius.all(Radius.circular(15)),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
      child: Container(
        color: Colors.grey.withOpacity(0.1),
        child: child,
      ),
    ),
  );
}
