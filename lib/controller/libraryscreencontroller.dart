import 'package:get/get.dart';

import '../db/box.dart';
import '../db/songmodel.dart';

class LibraryController extends GetxController{
   final box = Boxes.getInstance();
  String playlistName="";
   List<Songsdb> dbSongs = [];
  List<Songsdb> playlistSongs = [];
  @override
  void onInit() {
    dbSongs = box.get("musics") as List<Songsdb>;
    //playlistSongs = box.get(playlistName)!.cast<Songsdb>();
    // TODO: implement onInit
    super.onInit();
  }
 


    
  
}