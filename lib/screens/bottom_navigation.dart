import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:music_player_go/screens/home_screen.dart';
import 'package:music_player_go/screens/library_screen.dart';
import 'package:music_player_go/screens/search_screen.dart';
import 'package:music_player_go/widgets/music_function.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../widgets/now_playing.dart';

class BottomNavigation extends StatefulWidget {
  List<Audio> allsong;
  BottomNavigation({Key? key, required this.allsong}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  final AssetsAudioPlayer assetAudioPlayer = AssetsAudioPlayer.withId("0");
  int _selectedIndex = 0;

  Audio find(List<Audio> source, String fromPath) {
    return source.firstWhere((element) => element.path == fromPath);
  }

  void onitemtapped(int value) {
    setState(() {
      _selectedIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(
        allsong: widget.allsong,
      ),
      SearchScreen(fullSongs: const [],),
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
    return Scaffold(
      
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: pages[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        color: Color.fromARGB(244, 7, 0, 0),
        //animationCurve: Curves.easeOut,
        //backgroundColor: Colors.transparent,
        backgroundColor: Color.fromARGB(255, 30, 151, 211),
        items: items,
        index: _selectedIndex,
        onTap: onitemtapped,
        height: 65.0,
        animationDuration: const Duration(milliseconds: 400),
      ),

      // bottomSheet: assetsAudioPlayer.builderCurrent(
      //   builder: (context, playing) {
      //     // if (infos == null) {
      //     //   return SizedBox();
      //     // }

      //     final metas = playing.playlist.current.metas;
      //     return (playing == null)
      //         ? SizedBox()
      //         : ListTile(
      //             // onTap: () {
      //             //   Navigator.of(context).push(
      //             //       MaterialPageRoute(builder: (ctx) => PlayerScreen()));
      //             // },
      //             leading: QueryArtworkWidget(
      //               artworkBorder: BorderRadius.circular(12),
      //               artworkFit: BoxFit.cover,
      //               id: int.parse(playing.playlist.current.metas.id!),
      //               type: ArtworkType.AUDIO,
      //             ),
      //             title: Text(
      //               metas.title!,
      //               style: TextStyle(fontWeight: FontWeight.bold),
      //             ),
      //             subtitle: Text(metas.artist!),
      //             trailing: Row(
      //               mainAxisSize: MainAxisSize.min,
      //               children: [
      //                 IconButton(
      //                     onPressed: () {
      //                       assetsAudioPlayer.previous();
      //                     },
      //                     icon: Icon(Icons.skip_previous)),
      //                 IconButton(onPressed: () {
      //                   assetsAudioPlayer.playOrPause();
      //                 }, icon: assetsAudioPlayer.builderIsPlaying(
      //                     builder: (ctx, isPlaying) {
      //                   return isPlaying
      //                       ? Icon(
      //                           Icons.pause,
      //                           color: Colors.blue,
      //                         )
      //                       : Icon(
      //                           Icons.play_arrow,
      //                           color: Colors.blue,
      //                         );
      //                 })),
      //                 IconButton(
      //                     onPressed: () {
      //                       assetsAudioPlayer.next();
      //                     },
      //                     icon: Icon(Icons.skip_next)),
      //               ],
      //             ),
      //           );
      //   },
      // ),
      bottomSheet: Container(
        
        //color: Color.fromARGB(103, 0, 0, 0),
        height: 75,
        //width: MediaQuery.of(context).size.width,
        child: assetAudioPlayer.builderCurrent(
            builder: (BuildContext context, Playing? playing) {
          final myAudio = find(widget.allsong, playing!.audio.assetAudioPath);
          return Column(children: [
            GestureDetector(
               onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NowPlaying(
                        index: 0,
                        allsong: widget.allsong,
                      ),
                    ),
                  );
                },
              child: Container(
                height: 75,
                decoration: BoxDecoration(
                    color: Color.fromARGB(122, 79, 173, 250),),
                    //borderRadius: BorderRadius.all(Radius.circular(5))),
                //margin: const EdgeInsets.only(left: 5, right: 5),
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
                                image: AssetImage("assets/images/logo.png"),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                myAudio.metas.title!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
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
                                    fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Row(
                        children: [
                          // GestureDetector(
                          //   onTap: () {
                          //     assetAudioPlayer.previous();
                          //   },
                          //   child: const Icon(
                          //     Icons.skip_previous_rounded,
                          //     size: 35,
                          //     color: Colors.white,
                          //   ),
                          // ),
                          const SizedBox(width: 10),
                          PlayerBuilder.isPlaying(
                              player: assetAudioPlayer,
                              builder: (context, isPlaying) {
                                return GestureDetector(
                                  onTap: () async {
                                    await assetAudioPlayer.playOrPause();
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
          ]);
        }),
      )
      );
      
    
  }
}





// class BottomNavigationBarCustom extends StatefulWidget {
//   List<Audio> allsong;
//  BottomNavigationBarCustom({ Key? key ,required this.allsong}) : super(key: key);

//   @override
//   State<BottomNavigationBarCustom> createState() => _BottomNavigationBarCustomState();
// }

//  Audio find(List<Audio> source, String fromPath) {
//     return source.firstWhere((element) => element.path == fromPath);
//   }
// class _BottomNavigationBarCustomState extends State<BottomNavigationBarCustom> {
// final AssetsAudioPlayer assetAudioPlayer = AssetsAudioPlayer.withId("0");
//   int _selectedIndex =0;
//   @override
//   Widget build(BuildContext context) {
//     final pages = [
//       HomeScreen(
//         allsong: widget.allsong,
//       ),
//       SearchScreen(fullSongs: const [],),
//       LibraryScreen()
//     ];
//     return Scaffold(
//       body:  pages[_selectedIndex],
//       bottomSheet: Container(
//         height: 75,
//         child: assetAudioPlayer.builderCurrent(
//             builder: (BuildContext context, Playing? playing) {
//           final myAudio = find(widget.allsong, playing!.audio.assetAudioPath);
//           return Column(children: [
//             GestureDetector(
//                onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => NowPlaying(
//                         index: 0,
//                         allsong: widget.allsong,
//                       ),
//                     ),
//                   );
//                 },
//               child: Container(
//                 height: 75,
//                 decoration: BoxDecoration(
//                     color: Color.fromARGB(202, 24, 3, 18),
//                     borderRadius: BorderRadius.all(Radius.circular(5))),
//                 //margin: const EdgeInsets.only(left: 5, right: 5),
//                 child: Row(
//                   children: [
//                     SizedBox(
//                       height: 60,
//                       width: 60,
//                       child: QueryArtworkWidget(
//                         id: int.parse(myAudio.metas.id!),
//                         type: ArtworkType.AUDIO,
//                         artworkBorder: const BorderRadius.only(
//                             bottomLeft: Radius.circular(10),
//                             topLeft: Radius.circular(10)),
//                         artworkFit: BoxFit.cover,
//                         nullArtworkWidget: Container(
//                           height: 50,
//                           width: 50,
//                           decoration: const BoxDecoration(
//                             borderRadius: BorderRadius.only(
//                                 bottomLeft: Radius.circular(20),
//                                 topLeft: Radius.circular(20),
//                                 bottomRight: Radius.circular(20),
//                                 topRight: Radius.circular(20)),
//                             image: DecorationImage(
//                               image: AssetImage("assets/images/logo.png"),
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: Padding(
//                         padding: const EdgeInsets.only(
//                           left: 12,
//                           top: 12,
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               myAudio.metas.title!,
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                               style: TextStyle(
//                                 fontWeight: FontWeight.w500,
//                                 color: Colors.white,
//                               ),
//                             ),
//                             const SizedBox(height: 7),
//                             Text(
//                               myAudio.metas.artist!,
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                               style: const TextStyle(
//                                   color: Colors.grey,
//                                   fontWeight: FontWeight.w400,
//                                   fontSize: 12),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 20),
//                     Row(
//                       children: [
//                         GestureDetector(
//                           onTap: () {
//                             assetAudioPlayer.previous();
//                           },
//                           child: const Icon(
//                             Icons.skip_previous_rounded,
//                             size: 35,
//                             color: Colors.white,
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         PlayerBuilder.isPlaying(
//                             player: assetAudioPlayer,
//                             builder: (context, isPlaying) {
//                               return GestureDetector(
//                                 onTap: () async {
//                                   await assetAudioPlayer.playOrPause();
//                                 },
//                                 child: Icon(
//                                   isPlaying
//                                       ? Icons.pause_rounded
//                                       : Icons.play_arrow_rounded,
//                                   size: 35,
//                                   color: Colors.white,
//                                 ),
//                               );
//                             }),
//                         const SizedBox(width: 10),
//                         GestureDetector(
//                           onTap: () {
//                             assetAudioPlayer.next();
//                           },
//                           child: const Icon(
//                             Icons.skip_next_rounded,
//                             size: 35,
//                             color: Colors.white,
//                           ),
//                         ),
//                         const SizedBox(width: 15),
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//             )
//           ]);
//         }),
//       ),
//       bottomNavigationBar: Container(
//         decoration: BoxDecoration(
//           gradient: const LinearGradient(colors: [Color.fromARGB(255, 2, 1, 12), Color.fromARGB(255, 2, 1, 12)])
    
//         ),
//         child: BottomAppBar(
//           elevation: 0,
//           color: Colors.transparent,
//           child: SizedBox(
//             height: 60,
//             width: MediaQuery.of(context).size.width,
//             child: Padding(
//               padding: const EdgeInsets.only(left:25.0,right: 25.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   IconBottomBar(
//                     text:"Home",
//                     icon:Icons.home_filled,
//                     selected: _selectedIndex ==0,
//                     onPressed:(){
//                       setState(() {
//                         _selectedIndex =0;
//                       });
//                     }
//                   ),
//                   IconBottomBar(
//                     text:"Search",
//                     icon:Icons.home_filled,
//                     selected: _selectedIndex ==1,
//                     onPressed:(){
//                       setState(() {
//                         _selectedIndex =1;
//                       });
//                     }
//                   ),
//                   IconBottomBar(
//                     text:"Library",
//                     icon:Icons.home_filled,
//                     selected: _selectedIndex ==2,
//                     onPressed:(){
//                       setState(() {
//                         _selectedIndex =2;
//                       });
//                     }
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }




// class IconBottomBar extends StatelessWidget {
//   final String text;
//   final IconData icon;
//   final bool selected;
//   final Function() onPressed;
//    IconBottomBar({ Key? key,required this.text,required this.icon,required this.selected,required this.onPressed }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         IconButton(onPressed: onPressed, icon: Icon(icon,size:25,color: selected ?Colors.white :Colors.black ,))
//         ,Text(text,style: TextStyle(
//           fontSize: 12,
//           height: .1,
//           color: selected ? Colors.white : Colors.black
//         ),)
//       ],
//     );
//   }
// }