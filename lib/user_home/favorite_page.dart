import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipely/datas/hive_db.dart';
import 'package:recipely/user_home/detail_page.dart';

class Favoritescreen extends StatefulWidget {
  const Favoritescreen({super.key});

  @override
  State<Favoritescreen> createState() => _FavoritescreenState();
}

class _FavoritescreenState extends State<Favoritescreen> {
  @override
  void initState() {
    setState(() {
      getFavorites();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 153, 241,
                    238), // Replace with your desired gradient colors
                Color.fromARGB(255, 0, 163, 158),
              ],
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          'Your Favorites',
          style: GoogleFonts.poppins(
              color: const Color.fromARGB(255, 255, 255, 255), fontSize: 22),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: favoriteNotifier,
        builder: (context, value, child) {
          return value.isEmpty
              ? const Center(
                  child: Text(
                    'No favoriyes yet!',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Container(
                        decoration: const BoxDecoration(),
                        child: SizedBox(
                          height: size.height,
                          child: GridView.builder(
                              physics: const BouncingScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 1,
                                      crossAxisSpacing: 4.0,
                                      mainAxisSpacing: 4.0),
                              itemCount: value.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Container(
                                    width: 120,
                                    height: 100,
                                    decoration: BoxDecoration(
                                        color: Colors.teal,
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) => RecipeDetails(
                                            recipeModel: value[index],
                                          ),
                                        ));
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            Image(
                                              image: NetworkImage(
                                                  value[index].photo[0]),
                                              fit: BoxFit.cover,
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                      colors: [
                                                    const Color.fromARGB(
                                                        0, 0, 0, 0),
                                                    const Color.fromARGB(
                                                            255, 0, 0, 0)
                                                        .withOpacity(0.5),
                                                  ],
                                                      begin: Alignment
                                                          .bottomCenter,
                                                      end: Alignment
                                                          .bottomCenter)),
                                            ),
                                            Align(
                                              alignment: Alignment.bottomCenter,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  value[index].title,
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ));
                  });
        },
      ),
    );
  }
}
