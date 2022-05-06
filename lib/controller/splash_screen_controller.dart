import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../db/box.dart';
import '../db/songmodel.dart';
import '../screens/bottom_navigation.dart';

class SplashScreenController extends GetxController {
  final box = Boxes.getInstance();
  List<Audio> audiosongs = [];
  final _audioQuery = OnAudioQuery();
  List<Songsdb> mappedSongs = [];
  List<Songsdb> dbSongs = [];
  List<SongModel> fetchedSongs = [];
  List<SongModel> allsong = [];
  @override
  void onInit() {
    fetchSongs();
    toHomeScreen();

    super.onInit();
  }
  //To fetch songs from external storage and adding it to hive

  fetchSongs() async {
    bool permissionStatus = await _audioQuery.permissionsStatus();
    if (!permissionStatus) {
      await _audioQuery.permissionsRequest();
    }
    allsong = await _audioQuery.querySongs();

    mappedSongs = allsong.map(
      (e) {
        
        return Songsdb(
          title: e.title,
          id: e.id.toString(),
          image: e.uri!,
          duration: e.duration.toString(),
          artist: e.artist,
        );
      },
    ).toList();
    await box.put("musics", mappedSongs);
    dbSongs = box.get("musics") as List<Songsdb>;

    dbSongs.forEach(
      (element) {
        audiosongs.add(
          Audio.file(
            element.image.toString(),
            metas: Metas(
              title: element.title,
              id: element.id.toString(),
              artist: element.artist,
            ),
          ),
        );
      },
    );
    
    update();
  }

  //To Navigate to Bottom Navigation Page
  Future<void> toHomeScreen() async {
    await Future.delayed(
      const Duration(seconds: 4),
      () {
        Get.off(() => BottomNavigation(allsong: audiosongs));
      },
    );
  }
}
