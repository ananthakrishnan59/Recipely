import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:recipely/datas/shared_preference.dart';
import 'package:recipely/screens/introscreens/onbording_screens.dart';
import 'package:recipely/user_home/bottom_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isUserLoggedIn = false;
  String? usernameKey;
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool userKey = prefs.getBool('isLoggedIn') ?? false;
    setState(() {
      isUserLoggedIn = userKey;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        backgroundColor: const Color(0xFF1EDEC7),
        splash: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/images/Splash.json'),
            Text(
              'Recipely',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 35,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Whisking up joy, one recipe at a time – because \n the best stories are shared over a delicious meal',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w200,
                ),
              ),
            ),
          ],
        ),
        duration: 1500,
        splashTransition: SplashTransition.fadeTransition,
        splashIconSize: 500,
        nextScreen: isUserLoggedIn == true
            ? Bottomnavigationscreen(
                userEmailId: shared_preferences.nameKey,
              )
            : const OnBordingScreen());
  }
}
