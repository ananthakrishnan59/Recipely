import 'dart:io';

import 'package:flutter/material.dart';
import 'package:recipely/screens/adminscreen/admin_add.dart';
import 'package:recipely/screens/adminscreen/admin_update.dart';
import 'package:recipely/datas/hive_db.dart';
import 'package:recipely/models/model_recipe.dart';

class Admingridview extends StatefulWidget {
  const Admingridview({
    Key? key,
  }) : super(key: key);

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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 1 / 1.5,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 3, // Set a fixed number for crossAxisCount
          ),
          itemCount: datalist.length,
          itemBuilder: (context, index) {
            // ignore: unnecessary_cast
            File imageFile = File(datalist[index].photo[0] as String);

            String timeKey = datalist[index].timeKey ?? '';
            return GestureDetector(
              onTap: () {
                // Add your logic for handling tap on the container
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Updatescrren(
                                reciepeOfIndexForEditng: datalist[index]),
                          ));
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: AspectRatio(
                              aspectRatio: 1 / 1.5,
                              child: Image.file(
                                imageFile,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          color: Colors.black.withOpacity(0.7),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              datalist[index].title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
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
                            bool confirmDelete = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Confirm Delete'),
                                  content: const Text(
                                      'Are you sure you want to delete this recipe?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                      child: const Text('No'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(true);
                                      },
                                      child: const Text('Yes'),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (confirmDelete == true) {
                              await deleteRecipe(timeKey);
                              print('Deleting recipe with key: $timeKey');
                              fetchdata();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
