import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroPage3 extends StatelessWidget {
  const IntroPage3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/images/intro3r.jpg"),fit:BoxFit.cover,),
            
            ),
            child: Column(
              children: [Expanded(child: Container()),
                Center(
                  child: Text('Better Finishing',style:GoogleFonts.poppins(color: Colors.white,fontSize: 28,fontWeight: FontWeight.w700),),
                ),const SizedBox(height: 160,)
              ],
            ),
      ),
    );
  }
}
