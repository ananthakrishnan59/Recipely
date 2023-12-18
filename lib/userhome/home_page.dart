import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:recipely/datas/hive_db.dart';
import 'package:recipely/loginpage/login_page.dart';
import 'package:recipely/models/model_recipe.dart';
import 'package:recipely/models/user_model.dart';
import 'package:recipely/widget/widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
List<String> categories = [
  "Indian",
  "Chinese",
  "Italian",
  "Mexican",
  "Burgers",
  "Salads",
  "Fries",
  "Arabian"
];
String userName = '';

class _HomescreenState extends State<Homescreen> {
  Future<void> fetchUserName() async {
    try {
      final userBox = await Hive.openBox<User>('users');
      User? user =
          userBox.values.firstWhere((user) => user.email == widget.userEmailId);
      setState(() {
        userName = user.username;
      });
    } catch (e) {
      // Handle exceptions, e.g., user not found
      print('Error fetching username: $e');
    }
  }

  @override
  void initState() {
    fetchUserName();
    super.initState();
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
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Logout"),
                              content: const Text(
                                  "Are you sure you want to logout?"),
                              actions: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0Xff188F79),
                                  ),
                                  onPressed: () async {
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.clear().then((value) {
                                      // Navigate to the login page
                                      Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                const Loginpage()),
                                        (Route route) => false,
                                      );
                                    });
                                  },
                                  child: const Text("YES"),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0Xff188F79),
                                  ),
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("CANCEL"),
                                )
                              ],
                            );
                          },
                        );
                      },
                      child: const CircleAvatar(),
                    )
                  ],
                ),
                const SizedBox(height: 15),
                TextFormField(
                    decoration: const InputDecoration(
                        focusedBorder: OutlineInputBorder(),
                        label: Text('Search'),
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        prefixIcon: Icon(Icons.search))),
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
                              allselectbool = !allselectbool;
                            });
                          },
                          selected: allselectbool),
                      const SizedBox(width: 15),
                      TransactionChoiceChipWidget(
                          choiceName: 'India',
                          onselected: (value) {
                            setState(() {
                              indiaselectbool = !indiaselectbool;
                            });
                          },
                          selected: indiaselectbool),
                      const SizedBox(width: 15),
                      TransactionChoiceChipWidget(
                          choiceName: 'Chinese',
                          onselected: (value) {
                            setState(() {
                              chineseselectbool = !chineseselectbool;
                            });
                          },
                          selected: chineseselectbool),
                      const SizedBox(width: 15),
                      TransactionChoiceChipWidget(
                          choiceName: 'Italian',
                          onselected: (value) {
                            setState(() {
                              italianselectbool = !italianselectbool;
                            });
                          },
                          selected: italianselectbool),
                      const SizedBox(width: 15),
                      TransactionChoiceChipWidget(
                          choiceName: 'Mexican',
                          onselected: (value) {
                            setState(() {
                              mexicanselectbool = !mexicanselectbool;
                            });
                          },
                          selected: mexicanselectbool),
                      const SizedBox(width: 15),
                      TransactionChoiceChipWidget(
                          choiceName: 'Burgers',
                          onselected: (value) {
                            setState(() {
                              burgersselectbool = !burgersselectbool;
                            });
                          },
                          selected: burgersselectbool),
                      const SizedBox(width: 15),
                      TransactionChoiceChipWidget(
                          choiceName: 'Salads',
                          onselected: (value) {
                            setState(() {
                              saladsselectbool = !saladsselectbool;
                            });
                          },
                          selected: saladsselectbool),
                      const SizedBox(width: 15),
                      TransactionChoiceChipWidget(
                          choiceName: 'Fries',
                          onselected: (value) {
                            setState(() {
                              friesselectbool = !friesselectbool;
                            });
                          },
                          selected: friesselectbool),
                      const SizedBox(width: 15),
                      TransactionChoiceChipWidget(
                          choiceName: 'Arabian',
                          onselected: (value) {
                            setState(() {
                              arabianselectbool = !arabianselectbool;
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
                        return SizedBox(
                          height: size.height / 3.4,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: recipeslist.length,
                            itemBuilder: (context, index) {
                              final recipe = recipeslist[index];
                              return SizedBox(
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
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            const SizedBox(height: 5),
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Icon(Icons.alarm),
                                                  Text(
                                                    '${recipe.time} min',
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topCenter,
                                      child: Positioned(
                                        top: 0,
                                        child: CircleAvatar(
                                          backgroundImage:
                                              FileImage(File(recipe.photo)),
                                          radius: 65,
                                          backgroundColor: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ],
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
                    'New Recipes',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),const SizedBox(height: 20,),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: const Color(0xFF484848),
                      borderRadius: BorderRadius.circular(18)),
                  child: const Column(children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                'data',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(height: 20),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.alarm,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      'time',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w100),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        CircleAvatar(
                          radius: 60,
                        )
                      ],
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
