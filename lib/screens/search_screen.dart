import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:music_player_go/cls/cls.dart';
import 'package:music_player_go/db/box.dart';
import 'package:music_player_go/widgets/now_playing.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../db/songmodel.dart';

class SearchScreen extends StatefulWidget {
  List<Audio> fullSongs = [];

  SearchScreen({Key? key, required this.fullSongs}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final box = Boxes.getInstance();

  String search = "";

  List<Songsdb> dbSongs = [];

  List<Audio> allSongs = [];

  searchSongs() {
    dbSongs = box.get("musics") as List<Songsdb>;
    dbSongs.forEach(
      (element) {
        allSongs.add(
          Audio.file(
            element.image.toString(),
            metas: Metas(
                title: element.title,
                id: element.id.toString(),
                artist: element.artist),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchSongs();
  }

  @override
  Widget build(BuildContext context) {
    List<Audio> searchArtist = allSongs.where((element) {
      return element.metas.artist!.toLowerCase().startsWith(
            search.toLowerCase(),
          );
    }).toList();
    List<Audio> searchTitle = allSongs.where((element) {
      return element.metas.title!.toLowerCase().startsWith(
            search.toLowerCase(),
          );
    }).toList();
    List<Audio> searchResult = searchTitle + searchArtist;
    return Scaffold(
      extendBodyBehindAppBar: true,
      // extendBody: true,
      extendBody: true,
      body: SafeArea(
        child: Container(
          height: 950,
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
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10.0,
                  ),
                  child: Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text(
                          'Search',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.85,
                  /*MediaQuery.of(context).size.height * 0.07,*/
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0)),
                  child: TextField(
                    cursorColor: Colors.grey,
                    enableSuggestions: true,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      hintText: ' Search a song',
                      filled: true,
                    ),
                    onChanged: (value) {
                      setState(
                        () {
                          search = value;
                        },
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                search.isNotEmpty
                    ? searchResult.isNotEmpty
                        ? Expanded(
                            child: Stack(
                              children: [
                                ListView.builder(
                                  itemCount: searchResult.length,
                                  itemBuilder: ((context, index) {
                                    return FutureBuilder(
                                      future: Future.delayed(
                                        const Duration(microseconds: 0),
                                      ),
                                      builder: ((context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          return GestureDetector(
                                            onTap: () {
                                              OpenPlayer(
                                                      fullSongs: searchResult,
                                                      index: index)
                                                  .openAssetPlayer(
                                                      index: index,
                                                      songs: searchResult);
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return NowPlaying(
                                                    allsong: allSongs,
                                                    index: index);
                                              }));
                                            },
                                            child: ListTile(
                                              leading: SizedBox(
                                                height: 50,
                                                width: 50,
                                                child: QueryArtworkWidget(
                                                  id: int.parse(
                                                      searchResult[index]
                                                          .metas
                                                          .id!),
                                                  type: ArtworkType.AUDIO,
                                                  artworkBorder:
                                                      BorderRadius.circular(15),
                                                  artworkFit: BoxFit.cover,
                                                  nullArtworkWidget: Container(
                                                    height: 50,
                                                    width: 50,
                                                    decoration:
                                                        const BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(15),
                                                      ),
                                                      image: DecorationImage(
                                                        image: AssetImage(
                                                            'assets/images/logo.png'),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              title: Text(
                                                searchResult[index]
                                                    .metas
                                                    .title!,
                                                maxLines: 1,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                              subtitle: Text(
                                                searchResult[index]
                                                    .metas
                                                    .artist!,
                                                maxLines: 1,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          );
                                        }
                                        return Container();
                                      }),
                                    );
                                  }),
                                ),
                              ],
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.all(30),
                            child: Text(
                              "No Result Found",
                            ),
                          )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
