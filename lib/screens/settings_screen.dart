import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_player_go/openassetaudio/openassetaudio.dart';
import 'package:share_plus/share_plus.dart';

class SettingsScreen extends StatefulWidget {
  
   SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}
bool _notificaton= false;


class _SettingsScreenState extends State<SettingsScreen> {
 
  @override
  Widget build(BuildContext context) {
     
   
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        backgroundColor: const Color.fromARGB(255, 24, 3, 18),
        centerTitle: true,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
            Color.fromARGB(255, 24, 3, 18),
            Color.fromRGBO(21, 154, 211, 1)
          
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: Padding(
            padding: const EdgeInsets.only(left:30.0,right: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: TextButton.icon(
                    onPressed: () {
                      _shareApp();
                    },
                    icon: const Icon(
                      Icons.share,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Share',
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.privacy_tip,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Privacy Policy',
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.announcement,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Terms and Conditions',
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: TextButton.icon(
                    onPressed: () {
                      _aboutUs();
                    },
                    icon: const Icon(
                      Icons.info,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'About',
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                const Divider(
                  color: Colors.green,
                  thickness: 1,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Notification',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    _buildSwitch(),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );

  }
  Widget _buildSwitch() {
    
    return CupertinoSwitch(
      value: _notificaton,
      onChanged: _updateSwitch,
      activeColor: Color.fromARGB(255, 86, 209, 14),
      trackColor: Color.fromARGB(255, 113, 116, 113),
    );
  }

  void _updateSwitch(bool newValue) {
    setState(() {
      _notificaton = newValue;
      
    });
  }
  void _aboutUs() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Color.fromARGB(90, 0, 0, 0),
          title: Center(
              child: Text(
            'About me'
          )),
          content: Padding(
            padding: EdgeInsets.only(bottom:10,top:10.0),
            child: Text(
             'Hi I am Tom P Varghese a Flutter developer from Brototype.'
            ),
          ),
        );
      },
    );
  }
  void _shareApp() async {
    final box = context.findRenderObject() as RenderBox?;
    const String uri =
        'https://play.google.com/store/apps/details?id=in.brototype.music_player_go';
    await Share.share(
        '''Hey, I'm sharing this music application which helps you to play wonderful musics. please download it!!!
$uri''',
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
        subject: "Sharing the #1 music application");
  }
}
