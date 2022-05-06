
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player_go/screens/splash_screen.dart';
import 'db/box.dart';
import 'db/songmodel.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
   Hive.registerAdapter(SongsdbAdapter());
   await Hive.openBox<List>(boxname);
   
  final box = Boxes.getInstance();

 //add for playlist working
  List<dynamic> libraryKeys = box.keys.toList();
  if (!libraryKeys.contains("favorites")) {
    List<dynamic> likedSongs = [];
    await box.put("favorites", likedSongs);
  }

  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(backgroundColor: const Color.fromARGB(255, 253, 251, 251)),
      home: SplashScreen(),
      darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
    );
  }
}

