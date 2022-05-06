import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player_go/controller/libraryscreencontroller.dart';
import 'package:music_player_go/db/songmodel.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../db/box.dart';

// ignore: must_be_immutable, camel_case_types
class buildSheet extends StatelessWidget {
  String playlistName = "";
  buildSheet({Key? key, required this.playlistName}) : super(key: key);

  final box = Boxes.getInstance();

  List<Songsdb> dbSong = [];
  List<Songsdb> playlistSong = [];

  @override
  Widget build(BuildContext context) {
    Get.put(LibraryController());
    return Container(
        padding: const EdgeInsets.only(top: 20, left: 5, right: 5),
        child: GetBuilder<LibraryController>(builder: (controller) {
          dbSong = controller.dbSongs;
          playlistSong = box.get(playlistName)!.cast<Songsdb>();
          return ListView.builder(
            itemCount: dbSong.length,
            itemBuilder: (context, index) {
              return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: SizedBox(
                      height: 50,
                      width: 50,
                      child: QueryArtworkWidget(
                        id: int.parse(dbSong[index].id.toString()),
                        type: ArtworkType.AUDIO,
                        artworkBorder: BorderRadius.circular(15),
                        artworkFit: BoxFit.cover,
                        nullArtworkWidget: Container(
                          height: 50,
                          width: 50,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            image: DecorationImage(
                              image: AssetImage("assets/images/logo1.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      dbSong[index].title!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    trailing: playlistSong
                            .where((element) =>
                                element.id.toString() ==
                                dbSong[index].id.toString())
                            .isEmpty
                        ? IconButton(
                            onPressed: () async {
                              playlistSong.add(dbSong[index]);
                              await box.put(playlistName, playlistSong);
                              controller.update();
                            },
                            icon: const Icon(
                              Icons.add,
                            ),
                          )
                        : IconButton(
                            onPressed: () async {
                              playlistSong.removeWhere(
                                (elemet) =>
                                    elemet.id.toString() ==
                                    dbSong[index].id.toString(),
                              );
                              await box.put(playlistName, playlistSong);
                              controller.update();
                            },
                            icon: const Icon(
                              Icons.remove,
                            ),
                          ),
                  ));
            },
          );
        }));
  }
}
