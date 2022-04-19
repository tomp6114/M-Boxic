import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:music_player_go/screens/playlist_screen.dart';
import '../db/box.dart';
import '../db/songmodel.dart';
import '../widgets/editplaylistname.dart';
import '../widgets/snakbars.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  Widget favourite = Container();
  final box = Boxes.getInstance();
  List playlists = [];
  String? playlistName = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: SafeArea(
        child: Container(
          height: 850,
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
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Row(
                        children: const [
                          Text(
                            'Your Library',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor:
                                  const Color.fromARGB(146, 0, 0, 0),
                              title: const Text(
                                "Add new Playlist",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16),
                              ),
                              content: TextField(
                                onChanged: (value) {
                                  playlistName = value;
                                },
                                autofocus: true,
                                cursorRadius: const Radius.circular(50),
                                cursorColor: Colors.grey,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    List<Songsdb> librayry = [];
                                    List? excistingName = [];
                                    if (playlists.isNotEmpty) {
                                      excistingName = playlists
                                          .where((element) =>
                                              element == playlistName)
                                          .toList();
                                    }

                                    if (playlistName != '' &&
                                        excistingName.isEmpty) {
                                      box.put(playlistName, librayry);
                                      Navigator.of(context).pop();
                                      setState(() {
                                        playlists = box.keys.toList();
                                      });
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                              SnackBars().excistingPlaylist);
                                    }
                                  },
                                  child: const Text(
                                    "ADD",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 233, 225, 225),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                        icon: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.green),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 30.0,
                          ),
                        ),
                        label: const Text(
                          'Playlist',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextButton.icon(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return PlaylistScreen(
                              playlistName: 'favorites',
                            );
                          }));
                        },
                        icon: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color:
                                    const Color.fromARGB(255, 252, 252, 252)),
                            child: Image.asset(
                              'assets/images/love.png',
                              width: 30.0,
                            )),
                        label: const Text(
                          'Liked Songs',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, left: 8.0),
                      child: Row(
                        children: const [
                          Text(
                            'Playlists',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: box.listenable(),
                  builder: (context, boxes, _) {
                    playlists = box.keys.toList();
                    return Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: ListView.builder(
                        itemCount: playlists.length,
                        itemBuilder: (context, index) {
                          return Container(
                            child: playlists[index] != "musics" &&
                                    playlists[index] != "favorites"
                                ? ListTile(
                                    title: Text(
                                      playlists[index].toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    leading: const Icon(
                                      Icons.queue_sharp,
                                      color: Color.fromARGB(255, 20, 192, 14),
                                    ),
                                    trailing: popupMenuBar(index),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PlaylistScreen(
                                            playlistName: playlists[index],
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : Container(),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  popupMenuBar(int index) {
    return PopupMenuButton(
      color: const Color.fromARGB(255, 27, 21, 21),
      itemBuilder: (context) => [
        const PopupMenuItem(
          child: Text(
            'Remove Playlist',
          ),
          value: "0",
        ),
        const PopupMenuItem(
          value: "1",
          child: Text(
            "Rename Playlist",
          ),
        ),
      ],
      onSelected: (value) {
        if (value == "0") {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    backgroundColor: const Color.fromARGB(110, 0, 0, 0),
                    title: Text(
                      playlistName.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    content: const Text('Delete ?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          box.delete(
                            playlists[index],
                          );
                          Navigator.pop(context);
                        },
                        child: const Text('Yes'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('No'),
                      ),
                    ],
                  ));

          setState(() {
            playlists = box.keys.toList();
          });
        }
        if (value == "1") {
          showDialog(
            context: context,
            builder: (context) => EditPlaylist(
              playlistName: playlists[index],
            ),
          );
        }
      },
    );
  }
}
