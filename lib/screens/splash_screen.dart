import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:music_player_go/screens/bottom_navigation.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../db/box.dart';
import '../db/songmodel.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    fetchSongs();
    toHomeScreen();
    super.initState();
  }

  final box = Boxes.getInstance();
  final assetAudioPlayer = AssetsAudioPlayer.withId("0");
  List<Audio> audiosongs = [];
  final _audioQuery = OnAudioQuery();
  List<Songsdb> mappedSongs = [];
  List<Songsdb> dbSongs = [];
  List<SongModel> fetchedSongs = [];
  List<SongModel> allsong = [];

  fetchSongs() async {
    bool permissionStatus = await _audioQuery.permissionsStatus();
    if (!permissionStatus) {
      await _audioQuery.permissionsRequest();
    }
    allsong = await _audioQuery.querySongs();

    mappedSongs = allsong
        .map((e) => Songsdb(
            title: e.title,
            id: e.id.toString(),
            image: e.uri!,
            duration: e.duration.toString(),
            artist: e.artist))
        .toList();
    await box.put("musics", mappedSongs);
    dbSongs = box.get("musics") as List<Songsdb>;

    dbSongs.forEach((element) {
      audiosongs.add(Audio.file(element.image.toString(),
          metas: Metas(
              title: element.title,
              id: element.id.toString(),
              artist: element.artist)));
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.black,
          ),
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(37.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(37.0),
                    child: Image.asset(
                      'assets/images/logo2.png',
                      height: 143,
                      width: 139,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'M  B o x i c',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> toHomeScreen() async {
    await Future.delayed(
      const Duration(seconds: 4),
      () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) {
              return BottomNavigation(allsong: audiosongs);
            },
          ),
        );
      },
    );
  }
}
