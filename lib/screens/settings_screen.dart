import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controller/controller.dart';
import '../controller/settings_controller.dart';

class SettingsScreen extends StatelessWidget {
   SettingsScreen({Key? key}) : super(key: key);

  final Uri _url = Uri.parse('https://www.privacypolicies.com/live/69128004-fa3a-4711-833f-c73cdf880e5b');
  final Uri _privacyPolicy = Uri.parse('https://www.privacypolicies.com/live/9cb3fca6-2e8f-4119-bc86-e23b6bb2375b');

  
  @override
  Widget build(BuildContext context) {
    Get.put(Controller());
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
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
            padding: const EdgeInsets.only(left: 30.0, right: 30.0),
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
                      _shareApp(context);
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
                    onPressed: () {
                      _launchPrivacyPolicy();
                    },
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
                    onPressed: () {
                      _launchTermsAndConditions();
                    },
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
                      _aboutUs(context);
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
                    GetBuilder<Controller>(builder: (controller){
                      return controller.buildSwitch();
                    })
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

  

  

  void _aboutUs(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return  AlertDialog(
          backgroundColor: const Color.fromARGB(90, 0, 0, 0),
          title: const Center(
            child: Text('About'),
          ),
          content: Padding(
            padding: const EdgeInsets.only(bottom: 10, top: 10.0),
            child: Text(
                'Hi This is my music app M Boxic \n Version 2.0.0',style: GoogleFonts.montserrat(),),
          ),
        );
      },
    );
  }

  void _shareApp(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;
    const String uri =
        'https://play.google.com/store/apps/details?id=in.brototype.music_player_go';
    await Share.share(
        '''Hey, I'm sharing this music application which helps you to play wonderful musics. please download it!!!
$uri''',
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
        subject: "Sharing the #1 music application");
  }

  void _launchTermsAndConditions() async {
  if (!await launchUrl(_url)) throw 'Could not launch $_url';
}
void _launchPrivacyPolicy() async {
  if (!await launchUrl(_privacyPolicy)) throw 'Could not launch $_privacyPolicy';
}
}
