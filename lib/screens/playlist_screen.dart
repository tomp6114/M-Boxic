import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:music_player_go/db/songmodel.dart';

import 'package:music_player_go/widgets/bottomsheet.dart';

import 'package:music_player_go/widgets/now_playing.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../db/box.dart';
import '../openassetaudio/openassetaudio.dart';

class PlaylistScreen extends StatefulWidget {
  String? playlistName;

  PlaylistScreen({Key? key, this.playlistName}) : super(key: key);

  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  List<Songsdb>? dbSongs = [];

  List<Songsdb>? playlistSongs = [];
  List<Audio> playPlaylist = [];

  final box = Boxes.getInstance();
 
  @override
  void initState() {
    super.initState();
    // getSongs();
  }

  // getSongs() {
  //   dbSongs = box.get("musics") as List<Songs>;
  //   playlistSongs = box.get(widget.playlistName);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 27, 27, 27),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 24, 3, 18),
        title: Text(
          widget.playlistName!,
          style: const TextStyle(fontSize: 25),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                backgroundColor: Color.fromARGB(97, 0, 0, 0),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(40),
                    ),
                  ),
                  context: context,
                  builder: (context) {
                    return buildSheet(
                      playlistName: widget.playlistName!,
                    );
                  });
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Container(
        height: double.maxFinite,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            Color.fromARGB(255, 24, 3, 18),
            Color.fromARGB(255, 52, 176, 230),
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: box.listenable(),
                builder: (context, boxes, _) {
                  final playlistSongs = box.get(widget.playlistName)!;

                  // print(widget.playlistName);
                  return playlistSongs.isEmpty
                      ? const SizedBox(
                          child: Center(
                            child: Text(
                              "No songs here!",
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: playlistSongs.length,
                          itemBuilder: (context, index) {
                            
                            return GestureDetector(
                              onTap: () {
                                playlistSongs.forEach((element) {
                                  playPlaylist.add(Audio.file(
                                      element.image.toString(),
                                      metas: Metas(
                                          title: element.title,
                                          id: element.id.toString(),
                                          artist: element.artist)));
                                });
                                //addToList(playlistSongs,index);
                                OpenAssetAudio(
                                        allsong: playPlaylist, index: index)
                                    .openAsset(
                                        index: index, audios: playPlaylist);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NowPlaying(
                                      allsong: playPlaylist,
                                      index: index,
                                    ),
                                  ),
                                );
                              },
                              //onLongPress: () async {},
                              child: ListTile(
                                leading: SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: QueryArtworkWidget(
                                    id: int.parse(playlistSongs[index].id!),
                                    type: ArtworkType.AUDIO,
                                    artworkBorder: BorderRadius.circular(15),
                                    artworkFit: BoxFit.cover,
                                    nullArtworkWidget: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: const BoxDecoration(
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(15)),
                                        image: DecorationImage(
                                          image: AssetImage(
                                              "assets/images/logo.png"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  playlistSongs[index].title!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),
                                subtitle: Text(
                                  playlistSongs[index].artist!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),
                                trailing: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            playlistSongs.removeAt(index);
                                            box.put(widget.playlistName, playlistSongs);
                                          });
                                        },
                                        icon:
                                            Icon(Icons.delete, color: Colors.white),
                                      ),
                              ),
                            );
                          },
                        );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  // Future addToList(List playlistSongs,index) async{
  //   for (dynamic  element in playlistSongs) {
  //     playPlaylist.add(
  //       Audio.file(
  //         element.uri!,
  //         metas: Metas(
  //           title: element.title,
  //           id: element.id.toString(),
  //           artist: element.artist,
  //         ),
  //       ),
  //     );
  //   }
  //   print('.............................................................$playPlaylist');
  // }
}
