import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/controller.dart';


// ignore: must_be_immutable
class SplashScreen extends StatelessWidget {
 const SplashScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    Get.put(Controller());
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
                  Text(
                    'M  B o x i c',
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
