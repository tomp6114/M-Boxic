
// import 'package:assets_audio_player/assets_audio_player.dart';
// import 'package:flutter/material.dart';
// import 'package:on_audio_query/on_audio_query.dart';

// import '../db/box.dart';

// class Songstab extends StatefulWidget {
//   Songstab({Key? key, required this.audiosongs}) : super(key: key);
//   List<Audio> audiosongs = [];
//   @override
//   State<Songstab> createState() => _SongstabState();
// }

// class _SongstabState extends State<Songstab> {
//   final List<dynamic> file_urlh = [Icon(Icons.abc), Icon(Icons.ad_units)];

//   List? dbSongs = [];

//   final box = Boxes.getInstance();

//   final AssetsAudioPlayer assetAudioPlayer = AssetsAudioPlayer.withId("0");

//   final audioQuery = OnAudioQuery();

//   Audio find(List<Audio> source, String fromPath) {
//     return source.firstWhere((element) => element.path == fromPath);
//   }

//   @override
//   void initState() {
//     dbSongs = box.get("musics");
//   }

//   @override
//   Widget build(BuildContext context) {
//     var audiosongss;
//     return Expanded(
      
//     );
//   }
// }
