import 'dart:ui';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player_go/db/songmodel.dart';
import 'package:music_player_go/openassetaudio/openassetaudio.dart';
import 'package:music_player_go/screens/settings_screen.dart';
import 'package:music_player_go/widgets/now_playing.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../db/box.dart';
import '../widgets/buildsheet.dart';


// ignore: must_be_immutable
class HomeScreen extends StatelessWidget {
  List<Audio> allsong = [];

  HomeScreen({Key? key, required this.allsong}) : super(key: key);

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
  Widget build(BuildContext context) {
    dbSongs = box.get("musics");
    likedSongs = box.get("favorites");
    //Get.put(HomeScreenController());
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
        backgroundColor: const Color.fromARGB(255, 24, 3, 18),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 30.0,
            ),
            child: IconButton(
              onPressed: () {
                Get.to(() =>  SettingsScreen());
              },
              icon: const Icon(
                Icons.settings_outlined,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 1),
        height: 900,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            Color.fromARGB(255, 24, 3, 18),
            Color.fromRGBO(21, 154, 211, 1)
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: Stack(
            children: [
              ListView.builder(
                itemCount: allsong.length,
                itemBuilder: (BuildContext context, int index) {
                  String artist;
                  if (allsong[index].metas.artist.toString() == "<unknown>") {
                    artist = 'No artist';
                  } else {
                    artist = allsong[index].metas.artist.toString();
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
                          id: int.parse(allsong[index].metas.id.toString()),
                          type: ArtworkType.AUDIO),
                    ),
                    title: Text(
                      allsong[index].metas.title.toString(),
                      style: GoogleFonts.montserrat(
                          color: const Color.fromARGB(255, 251, 252, 251),
                          fontSize: 15),
                    ),
                    subtitle: Text(
                      artist,
                      style: GoogleFonts.montserrat(color: Colors.white, fontSize: 10),
                    ),
                    onTap: () async {
                      OpenAssetAudio(allsong: allsong, index: index)
                          .openAsset(index: index, audios: allsong);
                      Get.to(() => NowPlaying(allsong: allsong, index: index));
                    },
                    onLongPress: () => showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        likedSongs = box.get("favorites");
                        return Dialog(
                          backgroundColor: const Color.fromARGB(131, 5, 0, 0)
                              .withOpacity(1.0),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  allsong[index].metas.title.toString(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 106, 211, 106),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                ListTile(
                                  title: const Text(
                                    "Add to Playlist",
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 250, 249, 249),
                                        fontSize: 18),
                                  ),
                                  onTap: () {
                                    Get.back();
                                    showModalBottomSheet(
                                      backgroundColor:
                                          const Color.fromARGB(162, 0, 0, 0),
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(30),
                                        ),
                                      ),
                                      context: context,
                                      builder: (context) => BuildSheet(
                                        song: allsong[index],
                                      ),
                                    );
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
                                              color: Color.fromARGB(
                                                  255, 252, 250, 250),
                                              fontSize: 18),
                                        ),
                                        onTap: () async {
                                          final songs = box.get("musics")
                                              as List<Songsdb>;
                                          final temp = songs.firstWhere(
                                              (element) =>
                                                  element.id.toString() ==
                                                  allsong[index]
                                                      .metas
                                                      .id
                                                      .toString());
                                          favorites = likedSongs;
                                          favorites?.add(temp);
                                          box.put("favorites", favorites!);
                                          Get.back();
                                          // ScaffoldMessenger.of(context)
                                          //     .showSnackBar(
                                          //         SnackBars().likedAdd);
                                          Get.snackbar(
                                            "Message",
                                            "Song added to Favorites",
                                            snackPosition: SnackPosition.BOTTOM,
                                            colorText: const Color.fromARGB(
                                                255, 86, 211, 69),
                                          );
                                        },
                                      )
                                    : ListTile(
                                        title:
                                            const Text("Remove from Favorites"),
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
                                          Get.back();
                                          Get.snackbar("Message", "Song removed from Favorites");
                                        },
                                      ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
