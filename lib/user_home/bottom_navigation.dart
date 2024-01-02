import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:recipely/user_home/favorite_page.dart';
import 'package:recipely/user_home/home_page.dart';
import 'package:recipely/user_home/profile_page.dart';

class Bottomnavigationscreen extends StatefulWidget {
  const Bottomnavigationscreen({Key? key, this.userEmailId}) : super(key: key);
  final String ?userEmailId;
  @override
  State<Bottomnavigationscreen> createState() => _BottomnavigationscreenState();
}

class _BottomnavigationscreenState extends State<Bottomnavigationscreen> {
  int _currentIndex = 0;
  List<Widget> page = [];
  @override
  void initState() {
    super.initState();
    page = [ Homescreen(userEmailId: widget.userEmailId), const Favoritescreen(), const Profilescreen()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: page[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: const Color(0xFF1EDEC7),
        animationDuration: const Duration(milliseconds: 300),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          Icon(
            Icons.home,
            color: Colors.white,
          ),
          Icon(
            Icons.favorite,
            color: Colors.white,
          ),
          Icon(
            Icons.person,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
