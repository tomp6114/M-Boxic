import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player_go/db/songmodel.dart';
import 'package:music_player_go/widgets/now_playing.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../db/box.dart';
import '../openassetaudio/openassetaudio.dart';

class Favourites extends StatefulWidget {
  const Favourites({Key? key}) : super(key: key);

  @override
  _FavouritesState createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  List<Songsdb>? dbSongs = [];
  List<Audio> playLiked = [];
  // ignore: non_constant_identifier_names
  List<Songsdb>? likedSongs = [];
  final box = Boxes.getInstance();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 24, 3, 18),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Favorites",
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 24, 3, 18),
              Color.fromRGBO(21, 154, 211, 1)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: box.listenable(),
                builder: (context, boxes, _) {
                  final likedSongs = box.get("favorites");
                  return ListView.builder(
                    itemCount: likedSongs!.length,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        likedSongs.forEach(
                          (element) {
                            playLiked.add(Audio(element.image.toString(),
                                metas: Metas(
                                    title: element.title,
                                    id: element.id.toString(),
                                    artist: element.artist)));
                          },
                        );

                        OpenAssetAudio(allsong: playLiked, index: index)
                            .openAsset(index: index, audios: playLiked);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NowPlaying(
                              allsong: playLiked,
                              index: index,
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        leading: SizedBox(
                          height: 50,
                          width: 50,
                          child: QueryArtworkWidget(
                            id: int.parse(likedSongs[index].id.toString()),
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
                                  image:
                                      AssetImage("assets/images/default.jpeg"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            setState(() {
                              likedSongs.removeAt(index);
                              box.put("favorites", likedSongs);
                            });
                          },
                          icon: const Icon(Icons.delete, color: Colors.white),
                        ),
                        title: Text(
                          likedSongs[index],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, color: Colors.white),
                        ),
                        subtitle: Text(
                          likedSongs[index].artist,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
