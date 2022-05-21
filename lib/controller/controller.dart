import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:music_player_go/screens/home_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../db/box.dart';
import '../db/songmodel.dart';
import '../screens/bottom_navigation.dart';

class Controller extends GetxController {
  final _audioQuery = OnAudioQuery();
  final box = Boxes.getInstance();
  List<SongModel> allsong = [];
  List<Songsdb> mappedSongs = [];
  List<Songsdb> dbSongs = [];
  List<Audio> audiosongs = [];

  bool _notificaton = false;

  bool isPlaying = false;
  bool isLooping = false;
  bool isShuffle = false;

  List<dynamic>? likedSongs = [];
  List playlists = [];
  String? playlistName = '';
  List<dynamic>? playlistSongs = [];
  final AssetsAudioPlayer assetAudioPlayer = AssetsAudioPlayer.withId("0");
  
  
  

  @override
  Future<void> onInit() async {
    fetchSongs();
    toHomeScreen();
    

    super.onInit();
    
  }

  // Bottom Navigation Page Changing function
  int selectedIndex = 0;
  void onitemtapped(int value) {
    selectedIndex = value;
    update();
    
  }

  // Ascertion Function
  Audio find(List<Audio> source, String fromPath) {
    return source.firstWhere((element) => element.path == fromPath);
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

  //Build Switch In Settings Screen
  Widget buildSwitch() {
    return CupertinoSwitch(
      value: _notificaton,
      onChanged: _updateSwitch,
      activeColor: const Color.fromARGB(255, 86, 209, 14),
      trackColor: const Color.fromARGB(255, 113, 116, 113),
    );
  }

  // Switch OnChanged Function Seetings Screen
  Future<void> _updateSwitch(bool newValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    newValue!=prefs.getBool('counter');
    _notificaton = newValue;
    update();
    assetAudioPlayer.showNotification=newValue;
    prefs.setBool('counter', newValue);
  }

  // Now playing screen
  // add to favorties
  addToFavorites(Songsdb song) {
    likedSongs!.add(song);
    print(song);
    box.put("favorites", likedSongs!);
    likedSongs = box.get("favorites");
  }

  addToFav() {
    box.put("favorites", likedSongs!);
  }

  getFromFav() {
    likedSongs = box.get("favorites");
    //update();
  }

  putToFav(int index) {
    final songs = box.get("musics") as List<Songsdb>;
    final temp = songs.firstWhere((element) =>
        element.id.toString() == audiosongs[index].metas.id.toString());
    var favorites = likedSongs;
    favorites?.add(temp);
    box.put("favorites", favorites!);

    update();
    Get.back();
  }

  removeFav(int index) {
    likedSongs = box.get("favorites");
    //getFromFav();
    likedSongs?.removeWhere(
        (element) => element.id.toString() == dbSongs[index].id.toString());
    box.put("favorites", likedSongs!);

    //Get.to(BottomNavigation(allsong:audiosongs));
    update();
    //Get.back();
    Get.back();
  }

  createPlaylist() {
    List<Songsdb> librayry = [];
    List? excistingName = [];
    if (playlists.isNotEmpty) {
      excistingName =
          playlists.where((element) => element == playlistName).toList();
    }

    if (playlistName != '' && excistingName.isEmpty) {
      box.put(playlistName, librayry);
      Get.back();
      playlists = box.keys.toList();
    } else {
      Get.snackbar(
        "Message",
        "Excisting playlist name",
        colorText: Colors.red,
      );
    }
  }

  deletePlaylists(int index) {
    box.delete(
      playlists[index],
    );

    playlists = box.keys.toList();
  }

  List<Songsdb> getplaylistSongs(
      String playlistName, List<Songsdb> playlistSong) {
    return playlistSong = box.get(playlistName)!.cast<Songsdb>();
  }

  Future<void> addToPlaylist(
      int index, List<Songsdb> playlistSong, String playlistName) async {
    //dbSongs = box.get("musics") ;
    playlistSong.add(dbSongs[index]);
    await box.put(playlistName, playlistSong);
    update();
  }

  Future<void> deleteFromPlaylist(
      int index, List<Songsdb> playlistSong, String playlistname) async {
    playlistSong.removeWhere(
      (elemet) => elemet.id.toString() == dbSongs[index].id.toString(),
    );
    await box.put(playlistName, playlistSong);
    update();
  }


  void addNewPlaylist(List<dynamic> excistingName, List<Songsdb> librayry) {
    if (playlists.isNotEmpty) {
      excistingName = playlists
          .where((element) => element == playlistName)
          .toList();
    }
    
    if (playlistName != '' && excistingName.isEmpty) {
      box.put(playlistName, librayry);
      Get.back();
      playlists = box.keys.toList();
    } else {
      Get.snackbar("Message", "Excisting playlist name");
    }
  }


   Future<void> listPlaylist( Audio song,e) async {
    playlistSongs = box.get(e);
    List existingSongs = [];
    existingSongs = playlistSongs!
        .where((element) =>
            element.id.toString() ==
            song.metas.id.toString())
        .toList();
    
    if (existingSongs.isEmpty) {
      final songs = box.get("musics") as List<Songsdb>;
      final temp = songs.firstWhere((element) =>
          element.id.toString() ==
          song.metas.id.toString());
      playlistSongs?.add(temp);
    
      await box.put(e, playlistSongs!);
    
      // setState(() {});
      Get.back();
      Get.snackbar("Message", "Song added to Playlist");
    } else {
      Get.back();
      Get.snackbar("Message", "Song already exists");
    }
  }


  //Edit PlaylistName
  String? editPlaylistName(String? value) {
    List keys = box.keys.toList();
    if (value == "") {
      return "Name Required";
    }
    if (keys.where((element) => element == value).isNotEmpty) {
      return "This name already exits";
    }
    return null;
  }

  void deletePlaylist(GlobalKey<FormState> formkey,String _title,String playlistName) {
    if (formkey.currentState!.validate()) {
      List? playlists = box.get(playlistName);
      box.put(_title, playlists!);
      box.delete(playlistName);
      Get.back();
    }
  }
}
