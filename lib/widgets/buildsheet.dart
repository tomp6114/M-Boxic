import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player_go/controller/controller.dart';
import '../db/box.dart';
import '../db/songmodel.dart';
import 'package:hive/hive.dart';

// ignore: must_be_immutable
class BuildSheet extends StatelessWidget {
  BuildSheet({Key? key, this.song}) : super(key: key);
  Audio? song;

 
  List playlists = [];

  String? playlistName = '';

  

  @override
  Widget build(BuildContext context) {
    final box = Boxes.getInstance();
    playlists = box.keys.toList();
    return Container(
      padding: const EdgeInsets.only(top: 30, bottom: 20),
      child: GetBuilder<Controller>(
        builder: (controller) {
          return ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
                child: ListTile(
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: const Color.fromARGB(136, 8, 8, 8),
                      title: const Text(
                        "Add new Playlist",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 102, 197, 105)),
                      ),
                      content: TextField(
                        //decoration: const InputDecoration(enabled:true,border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5)))),
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
                              controller.addNewPlaylist(excistingName, librayry);
                            },
                            child: const Text(
                              "ADD",
                              style: TextStyle(
                                color: Color.fromARGB(255, 240, 237, 237),
                              ),
                            ))
                      ],
                    ),
                  ),
                  leading: Container(
                    height: 50,
                    width: 50,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(248, 7, 7, 7),
                      borderRadius: BorderRadius.all(Radius.circular(17)),
                    ),
                    child: const Center(
                        child: Icon(
                      Icons.add,
                      color: Color.fromARGB(183, 252, 250, 250),
                      size: 28,
                    )),
                  ),
                  title: const Text(
                    "Create Playlist",
                    style: TextStyle(
                      color: Color.fromARGB(183, 252, 250, 250),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              ...playlists
                  .map((e) => e != "musics" && e != "favorites"
                      ? libraryList(
                          child: ListTile(
                          onTap: () async {
                            await controller.listPlaylist(song!, e);
                          },
                          leading: Container(
                            height: 50,
                            width: 50,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/images/logo.png"),
                                  fit: BoxFit.cover),
                              borderRadius: BorderRadius.all(Radius.circular(17)),
                            ),
                          ),
                          title: Text(
                            e.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ))
                      : Container())
                  .toList()
            ],
          );
        }
      ),
    );
  }

 

  

  Padding libraryList({required child}) {
    return Padding(
        padding: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
        child: child);
  }
}
