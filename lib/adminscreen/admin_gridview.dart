import 'dart:io';

import 'package:flutter/material.dart';
import 'package:recipely/adminscreen/admin_add.dart';
import 'package:recipely/adminscreen/admin_update.dart';
import 'package:recipely/datas/hive_db.dart';
import 'package:recipely/models/model_recipe.dart';

class Admingridview extends StatefulWidget {
  const Admingridview({
    super.key,
  });

  @override
  State<Admingridview> createState() => _AdmingridviewState();
}

class _AdmingridviewState extends State<Admingridview> {
  List<Recipes> datalist = [];
  Recipes? reciepeOfIndex;

  Future<void> fetchdata() async {
    List<Recipes> datalists = await getrecipe();
    setState(() {
      datalist = datalists;
    });
  }

  @override
  void initState() {
    fetchdata();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color(0xFF1EDEC7),
          title: const Text("Added List"),
        ),
        body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 1 / 1.5,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 3, // Set a fixed number for crossAxisCount
          ),
          itemCount: datalist.length,
          itemBuilder: (context, index) {
            // Check if the file exists before loading the image
            File imageFile = File(datalist[index].photo);
            String timeKey = datalist[index].timeKey ?? '';
            return GestureDetector(
              onTap: () {
                // Add your logic for handling tap on the container
              },
              child: Stack(
                children: [
                  InkWell(
                    onTap: () {
                      // reciepeOfIndex = datalist[index];
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Updatescrren(
                            reciepeOfIndexForEditng: datalist[index]),
                      ));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          10.0), // Adjust the radius as needed
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.black.withOpacity(0.2), // Shadow color
                              spreadRadius: 2, // Spread radius
                              blurRadius: 5, // Blur radius
                              offset: const Offset(
                                  0, 3), // Offset in the direction of shadow
                            ),
                          ],
                        ),
                        child: AspectRatio(
                          aspectRatio: 1 / 1.5, // Set the desired aspect ratio
                          child: Image.file(
                            imageFile,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.white),
                      onPressed: () async {
                        await deleteRecipe(timeKey);
                        print('Deleting recipe with key: $timeKey');
                        fetchdata();
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const Addingscreen(),
            ));
          },
          backgroundColor: const Color(0xFF1EDEC7),
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.centerDocked);
  }
}
