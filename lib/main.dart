import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:recipely/screens/loginpage/splash_screen.dart';
import 'package:recipely/models/model_recipe.dart';
// import 'package:recipely/models/recipes_model.dart';
import 'package:recipely/models/user_model.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter<User>(UserAdapter());
  Hive.registerAdapter<Recipes>(RecipesAdapter());
  await Hive.openBox<User>('users');
  await Hive.openBox<Recipes>('recipes');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme()),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
