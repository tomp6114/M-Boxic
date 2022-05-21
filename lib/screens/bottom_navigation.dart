import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player_go/controller/bottom_navigation_controller.dart';
import 'package:music_player_go/screens/home_screen.dart';
import 'package:music_player_go/screens/library_screen.dart';
import 'package:music_player_go/screens/search_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../controller/controller.dart';
import '../widgets/now_playing.dart';

// ignore: must_be_immutable
class BottomNavigation extends StatelessWidget {
  List<Audio> allsong;
  BottomNavigation({Key? key, required this.allsong}) : super(key: key);

  final AssetsAudioPlayer assetAudioPlayer = AssetsAudioPlayer.withId("0");

  

  @override
  Widget build(BuildContext context) {
    Get.put(Controller());
    final pages = [
      HomeScreen(
        allsong: allsong,
      ),
      SearchScreen(
        fullSongs: allsong,
      ),
      LibraryScreen()
    ];
    final items = <Widget>[
      const Icon(
        Icons.home_filled,
        size: 30.0,
        color: Color.fromARGB(235, 217, 221, 223),
      ),
      const Icon(
        Icons.search,
        size: 30.0,
        color: Color.fromARGB(235, 217, 221, 223),
      ),
      const Icon(
        Icons.amp_stories,
        size: 30.0,
        color: Color.fromARGB(235, 217, 221, 223),
      ),
    ];
    return GetBuilder<Controller>(
      builder: ((controller) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          extendBody: true,
          body: pages[controller.selectedIndex],
          bottomNavigationBar: CurvedNavigationBar( 
            color: const Color.fromARGB(244, 7, 0, 0),
            backgroundColor: const Color.fromARGB(255, 30, 151, 211),
            items: items,
            index: controller.selectedIndex,
            onTap: controller.onitemtapped,
            height: 65.0,
            animationDuration: const Duration(milliseconds: 400),
          ),
          bottomSheet: SizedBox(
            height: 75,
            child: assetAudioPlayer.builderCurrent(
              builder: (BuildContext context, Playing? playing) {
                final myAudio = controller.find(allsong, playing!.audio.assetAudioPath);
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.to(() => NowPlaying(allsong: allsong, index: 0));
                      },
                      child: Container(
                        height: 75,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(122, 79, 173, 250),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              SizedBox(
                                height: 60,
                                width: 60,
                                child: QueryArtworkWidget(
                                  id: int.parse(myAudio.metas.id!),
                                  type: ArtworkType.AUDIO,
                                  artworkBorder: const BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      topLeft: Radius.circular(10)),
                                  artworkFit: BoxFit.cover,
                                  nullArtworkWidget: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(20),
                                          topLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20),
                                          topRight: Radius.circular(20)),
                                      image: DecorationImage(
                                        image: AssetImage(
                                            "assets/images/logo.png"),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 12,
                                    top: 12,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        myAudio.metas.title!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 7),
                                      Text(
                                        myAudio.metas.artist!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Row(
                                children: [
                                  const SizedBox(width: 10),
                                  PlayerBuilder.isPlaying(
                                      player: assetAudioPlayer,
                                      builder: (context, isPlaying) {
                                        return GestureDetector(
                                          onTap: () async {
                                            await assetAudioPlayer
                                                .playOrPause();
                                          },
                                          child: Icon(
                                            isPlaying
                                                ? Icons.pause_rounded
                                                : Icons.play_arrow_rounded,
                                            size: 45,
                                            color: Colors.white,
                                          ),
                                        );
                                      }),
                                  const SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () {
                                      assetAudioPlayer.next();
                                    },
                                    child: const Icon(
                                      Icons.skip_next_rounded,
                                      size: 35,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        );
      }),
    );
  }
}
