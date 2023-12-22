import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroPage2 extends StatelessWidget {
  const IntroPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/images/intro4r.jpg"),fit:BoxFit.cover,),
            
            ),
            child: Column(
              children: [Expanded(child: Container()),
                Center(
                  child: Text('More Easy',style:GoogleFonts.poppins(color: Colors.white,fontSize: 28,fontWeight: FontWeight.w700),),
                ),const SizedBox(height: 160,)
              ],
            )
      ),
    );
  }
}