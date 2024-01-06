import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:recipely/datas/hive_db.dart';
import 'package:recipely/datas/shared_preference.dart';
import 'package:recipely/models/model_recipe.dart';
import 'package:recipely/models/user_model.dart';
import 'package:recipely/user_home/detail_page.dart';
import 'package:recipely/user_home/search_page.dart';
import 'package:recipely/widget/widget.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({
    super.key,
    this.userEmailId,
  });
  final String? userEmailId;
  @override
  State<Homescreen> createState() => _HomescreenState();
}

bool allselectbool = false;
bool indiaselectbool = false;
bool chineseselectbool = false;
bool italianselectbool = false;
bool mexicanselectbool = false;
bool burgersselectbool = false;
bool saladsselectbool = false;
bool friesselectbool = false;
bool arabianselectbool = false;
String userName = '';

class _HomescreenState extends State<Homescreen> {
  List<Recipes> recipeslist = [];
  Future<void> fetchUserName() async {
    try {
      String? name = await shared_preferences.getName();
      final userBox = await Hive.openBox<User>('users');
      User? user = userBox.values.firstWhere((user) => user.email == name);
      setState(() {
        userName = user.username; // Provide a default username if user is null
      });
      print(name);
    } catch (e) {
      print('Error fetching username: $e');
      print(userName);
    }
  }

  String categories = '';
  @override
  void initState() {
    getFavorites();
    fetchUserName();
    getrecipesFn();
    super.initState();
  }

  void getrecipesFn() async {
    List<Recipes> recipe = await getrecipe();
    setState(() {
      recipeslist = recipe;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'welcome $userName', // Remove 'const' here
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Text(
                            'What are you cooking today?',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // showDialog(
                        //   barrierDismissible: false,
                        //   context: context,
                        //   builder: (context) {
                        //     return AlertDialog(
                        //       title: const Text("Logout"),
                        //       content: const Text(
                        //           "Are you sure you want to logout?"),
                        //       actions: [
                        //         ElevatedButton(
                        //           style: ElevatedButton.styleFrom(
                        //             backgroundColor: const Color(0Xff188F79),
                        //           ),
                        //           onPressed: () async {
                        //             final prefs =
                        //                 await SharedPreferences.getInstance();
                        //             prefs.clear().then((value) {
                        //               // Navigate to the login page
                        //               Navigator.of(context).pushAndRemoveUntil(
                        //                 MaterialPageRoute(
                        //                     builder: (BuildContext context) =>
                        //                         const Loginpage()),
                        //                 (Route route) => false,
                        //               );
                        //             });
                        //           },
                        //           child: const Text("YES"),
                        //         ),
                        //         ElevatedButton(
                        //           style: ElevatedButton.styleFrom(
                        //             backgroundColor: const Color(0Xff188F79),
                        //           ),
                        //           onPressed: () async {
                        //             Navigator.of(context).pop();
                        //           },
                        //           child: const Text("CANCEL"),
                        //         )
                        //       ],
                        //     );
                        //   },
                        // );
                      },
                      child: const CircleAvatar(),
                    )
                  ],
                ),
                const SizedBox(height: 15),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Searchpage(
                            recipesList: recipeslist, initialCategory: '')));
                  },
                  child: TextFormField(
                    enabled: false,
                    decoration: const InputDecoration(
                      label: Text('Search'),
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 55,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      TransactionChoiceChipWidget(
                          choiceName: 'All',
                          onselected: (value) {
                            setState(() {
                              categories = '';
                              allselectbool = !allselectbool;
                              indiaselectbool = false;
                              chineseselectbool = false;
                              italianselectbool = false;
                              mexicanselectbool = false;
                              burgersselectbool = false;
                              saladsselectbool = false;
                              friesselectbool = false;
                              arabianselectbool = false;
                            });
                          },
                          selected: allselectbool),
                      const SizedBox(width: 15),
                      TransactionChoiceChipWidget(
                          choiceName: 'India',
                          onselected: (value) {
                            setState(() {
                              categories = 'India';
                              indiaselectbool = !indiaselectbool;
                              allselectbool = false;
                              chineseselectbool = false;
                              italianselectbool = false;
                              mexicanselectbool = false;
                              burgersselectbool = false;
                              saladsselectbool = false;
                              friesselectbool = false;
                              arabianselectbool = false;
                            });
                          },
                          selected: indiaselectbool),
                      const SizedBox(width: 15),
                      TransactionChoiceChipWidget(
                          choiceName: 'Chinese',
                          onselected: (value) {
                            setState(() {
                              categories = 'Chinese';
                              chineseselectbool = !chineseselectbool;
                              indiaselectbool = false;
                              allselectbool = false;
                              italianselectbool = false;
                              mexicanselectbool = false;
                              burgersselectbool = false;
                              saladsselectbool = false;
                              friesselectbool = false;
                              arabianselectbool = false;
                            });
                          },
                          selected: chineseselectbool),
                      const SizedBox(width: 15),
                      TransactionChoiceChipWidget(
                          choiceName: 'Italian',
                          onselected: (value) {
                            setState(() {
                              categories = 'Italian';
                              italianselectbool = !italianselectbool;
                              indiaselectbool = false;
                              chineseselectbool = false;
                              allselectbool = false;
                              mexicanselectbool = false;
                              burgersselectbool = false;
                              saladsselectbool = false;
                              friesselectbool = false;
                              arabianselectbool = false;
                            });
                          },
                          selected: italianselectbool),
                      const SizedBox(width: 15),
                      TransactionChoiceChipWidget(
                          choiceName: 'Mexican',
                          onselected: (value) {
                            setState(() {
                              categories = 'Mexican';
                              mexicanselectbool = !mexicanselectbool;
                              indiaselectbool = false;
                              chineseselectbool = false;
                              italianselectbool = false;
                              allselectbool = false;
                              burgersselectbool = false;
                              saladsselectbool = false;
                              friesselectbool = false;
                              arabianselectbool = false;
                            });
                          },
                          selected: mexicanselectbool),
                      const SizedBox(width: 15),
                      TransactionChoiceChipWidget(
                          choiceName: 'Burgers',
                          onselected: (value) {
                            setState(() {
                              categories = 'Burgers';
                              burgersselectbool = !burgersselectbool;
                              indiaselectbool = false;
                              chineseselectbool = false;
                              italianselectbool = false;
                              mexicanselectbool = false;
                              allselectbool = false;
                              saladsselectbool = false;
                              friesselectbool = false;
                              arabianselectbool = false;
                            });
                          },
                          selected: burgersselectbool),
                      const SizedBox(width: 15),
                      TransactionChoiceChipWidget(
                          choiceName: 'Salads',
                          onselected: (value) {
                            setState(() {
                              categories = 'Salads';
                              saladsselectbool = !saladsselectbool;
                              indiaselectbool = false;
                              chineseselectbool = false;
                              italianselectbool = false;
                              mexicanselectbool = false;
                              burgersselectbool = false;
                              allselectbool = false;
                              friesselectbool = false;
                              arabianselectbool = false;
                            });
                          },
                          selected: saladsselectbool),
                      const SizedBox(width: 15),
                      TransactionChoiceChipWidget(
                          choiceName: 'Fries',
                          onselected: (value) {
                            setState(() {
                              categories = 'Fries';
                              friesselectbool = !friesselectbool;
                              indiaselectbool = false;
                              chineseselectbool = false;
                              italianselectbool = false;
                              mexicanselectbool = false;
                              burgersselectbool = false;
                              saladsselectbool = false;
                              allselectbool = false;
                              arabianselectbool = false;
                            });
                          },
                          selected: friesselectbool),
                      const SizedBox(width: 15),
                      TransactionChoiceChipWidget(
                          choiceName: 'Arabian',
                          onselected: (value) {
                            setState(() {
                              categories = 'Arabian';
                              arabianselectbool = !arabianselectbool;
                              indiaselectbool = false;
                              chineseselectbool = false;
                              italianselectbool = false;
                              mexicanselectbool = false;
                              burgersselectbool = false;
                              saladsselectbool = false;
                              friesselectbool = false;
                              allselectbool = false;
                            });
                          },
                          selected: arabianselectbool),
                      const SizedBox(width: 15),
                    ],
                  ),
                ),
                FutureBuilder(
                    future: getrecipe(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else {
                        List<Recipes> recipeslist = snapshot.data!;
                        for (var element in recipeslist) {
                          print(element.category);
                        }

                        recipeslist = recipeslist
                            .where((element) => element.category
                                .toLowerCase()
                                .contains(categories.toLowerCase()))
                            .toList();

                        return SizedBox(
                          height: size.height / 3.4,
                          child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: recipeslist.length,
                            itemBuilder: (context, index) {
                              final recipe = recipeslist[index];
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        RecipeDetails(recipeModel: recipe),
                                  ));
                                },
                                child: SizedBox(
                                  width: size.width / 2,
                                  height: size.height / 3.4,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        top: 40,
                                        child: Container(
                                          height: 200,
                                          width: size.width / 2,
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 220, 218, 218),
                                              borderRadius:
                                                  BorderRadius.circular(18)),
                                          child: Column(
                                            children: [
                                              const SizedBox(
                                                height: 90,
                                              ),
                                              Text(
                                                recipe.title,
                                                style: const TextStyle(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              const SizedBox(height: 5),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Icon(Icons.update),
                                                  Text(
                                                    '${recipe.time} min',
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topCenter,
                                        child: CircleAvatar(
                                          backgroundImage:
                                              FileImage(File(recipe.photo[0])),
                                          radius: 65,
                                          backgroundColor: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 10),
                          ),
                        );
                      }
                    }),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Recipes For YOu',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                CarouselSlider(
                  options: CarouselOptions(
                    autoPlay: true,
                    height: 180,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 2000),
                    autoPlayInterval: const Duration(seconds: 3),
                    enlargeCenterPage: true,
                    enlargeFactor: 1,
                    animateToClosest: true,
                    viewportFraction: 0.9,
                    onPageChanged: (index, reason) {},
                  ),
                  items: recipeslist.map((recipe) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              RecipeDetails(recipeModel: recipe),
                        ));
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Stack(
                          children: [
                            Image.file(
                              File(recipe.photo[0]),
                              fit: BoxFit.fitWidth,
                              width: 370,
                            ),
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.6),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              left: 10,
                              child: Text(
                                recipe.title,
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  color: Colors.white.withOpacity(0.6),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
