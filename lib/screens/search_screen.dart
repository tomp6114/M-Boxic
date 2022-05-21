import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player_go/controller/libraryscreencontroller.dart';
import 'package:music_player_go/openassetaudio/openassetaudio.dart';

import 'package:on_audio_query/on_audio_query.dart';

import '../controller/controller.dart';
import '../widgets/now_playing.dart';

// ignore: must_be_immutable
class SearchScreen extends StatelessWidget {
  List<Audio> fullSongs;
  SearchScreen({Key? key, required this.fullSongs}) : super(key: key);

  String searchText = "";
  List<Audio> dummy = [];
  final Controller controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                child: Text(
                  "Search",
                  style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 25.0, right: 25, top: 20, bottom: 20),
                child: TextField(
                  style: GoogleFonts.montserrat(color: Colors.black),
                  onChanged: (value) {
                    Future.delayed(
                        const Duration(
                          seconds: 0,
                        ), () {
                      searchText = value;
                      controller.update(["result"]);
                    });
                  },
                  decoration: InputDecoration(
                    //hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(color: Colors.black)),
                    hintText: "Search",
                    hintStyle: GoogleFonts.montserrat(
                        color: Colors.grey, fontSize: 18),
                  ),
                ),
              ),
              Expanded(
                child: GetBuilder<Controller>(
                    id: "result",
                    builder: (controller) {
                      List<Audio> result = searchText == ""
                          ? dummy.toList()
                          : fullSongs
                              .where((element) => element.metas.title!
                                  .toLowerCase()
                                  .contains(searchText.toLowerCase()))
                              .toList();
                      return ListView.separated(
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: QueryArtworkWidget(
                                nullArtworkWidget: Image.asset(
                                  "assets/images/logo1.png",
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.cover,
                                ),
                                type: ArtworkType.AUDIO,
                                id: int.parse(
                                    result[index].metas.id.toString()),
                              ),
                              title: Text(
                                result[index].metas.title.toString(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    GoogleFonts.montserrat(color: Colors.white),
                              ),
                              subtitle: Text(
                                result[index].metas.artist.toString(),
                                style:
                                    GoogleFonts.montserrat(color: Colors.white),
                              ),
                              onTap: () {
                                OpenAssetAudio(allsong: result, index: index)
                                    .openAsset(index: index, audios: result);
                                Get.to(
                                  () =>
                                      NowPlaying(allsong: result, index: index),
                                );
                              },
                            );
                          },
                          separatorBuilder: (context, index) => const SizedBox(
                                height: 0.1,
                              ),
                          itemCount: result.length);
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
