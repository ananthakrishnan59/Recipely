import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipely/introscreens/intro_screen_1.dart';
import 'package:recipely/introscreens/intro_screen_2.dart';
import 'package:recipely/introscreens/intro_screen_3.dart';
import 'package:recipely/loginpage/login_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBordingScreen extends StatefulWidget {
  const OnBordingScreen({super.key});

  @override
  State<OnBordingScreen> createState() => _OnBordingScreenState();
}

class _OnBordingScreenState extends State<OnBordingScreen> {
 
 final PageController _controller = PageController();
 
bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Stack(
        children: [
           PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index==2);
              });
            },
        children: const [
          IntroPage1(), 
          IntroPage2(),
          IntroPage3()
        ],
      ),

      Container(
        alignment: const Alignment(0, 0.80),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
          
          GestureDetector(
           onTap: () {
             
             _controller.jumpToPage(2);
           },
            child: Text('Skip',style: GoogleFonts.poppins( color: Colors.white, fontSize: 20,fontWeight: FontWeight.w500),)),

            SmoothPageIndicator(controller: _controller, count: 3),
         
          onLastPage?
         GestureDetector(
           onTap: () {
              Navigator.push(context, 
              MaterialPageRoute(
                builder: (context){
                  return const Loginpage();
                }
                )
                );
            },
          child: Text('Done',style: GoogleFonts.poppins(color: Colors.white, fontSize: 20,fontWeight: FontWeight.w500),),
           )
           :  GestureDetector(
           onTap: () {
              _controller.nextPage(duration:  const Duration(milliseconds: 500),
               curve: Curves.easeIn);
            },
          child: Text('Next',style: GoogleFonts.poppins(color: Colors.white, fontSize: 20,fontWeight: FontWeight.w500),),
           )
          ],
        )),
        ],
      )
    );
  }
}