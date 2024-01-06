// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:recipely/datas/shared_preference.dart';
import 'package:recipely/models/user_model.dart';
import 'package:recipely/screens/loginpage/login_page.dart';
import 'package:recipely/user_home/bottom_navigation.dart';
import 'package:recipely/user_home/home_page.dart';
import 'package:recipely/user_home/profile_edit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../util/user_profile_ref.dart';

class UserProfileScreen extends StatefulWidget {
  final User? user;

  const UserProfileScreen({super.key, this.user});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late Box userBox;
  User? loggedInUser;
  late int index;

  @override
  void initState() {
    super.initState();
    getuser();
    userBox = Hive.box<User>('users');
  }

  getuser() async {
    final sharedprefs = await SharedPreferences.getInstance();
    final loggedInUserIndex = sharedprefs.getInt('loggedInUserIndexKey');

    final user = userBox.getAt(loggedInUserIndex!) as User;
    print(user);
    setState(() {
      loggedInUser = user;
      index = loggedInUserIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          backgroundColor: Color(0xFF1EDEC7),
          title: Padding(
            padding: const EdgeInsets.only(left: 70),
            child: Text(
              'Profile',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
            ),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (context) {
                  return  Bottomnavigationscreen(userEmailId: shared_preferences.nameKey,);
                }));
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              )),
        ),
      ),
      body: SingleChildScrollView(
        child: ValueListenableBuilder(
          valueListenable: userBox.listenable(),
          builder: (context, box, child) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: loggedInUser?.image != null
                        ? FileImage(File(loggedInUser?.image??''))
                        : const AssetImage('assets/images/profile.jpg')
                            as ImageProvider,
                    maxRadius: 60,
                  ),
                ),
                listTile(loggedInUser?.username ?? 'value'),
                const Divider(
                  color: Color.fromARGB(255, 64, 63, 63),
                  thickness: .5,
                ),
                listTile(loggedInUser?.email ?? 'value'),
                const Divider(
                  color: Color.fromARGB(255, 64, 63, 63),
                  thickness: .5,
                ),
                listTile('Edit Profile',
                    iconbutton: IconButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) {
                            return UserProfileEdit(
                              userdetails: loggedInUser,
                              index: index,
                            );
                          }));
                        },
                        icon: const Icon(
                          Icons.edit_document,
                          color: Colors.teal,
                        ))),
                const Divider(
                  color: Color.fromARGB(255, 94, 93, 93),
                  thickness: .5,
                ),
                listTile('Logout',
                    textcolor: Colors.red,
                    iconbutton: IconButton(
                        onPressed: () {
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
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
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
                        icon: const Icon(
                          Icons.logout,
                          color: Colors.red,
                        )))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
