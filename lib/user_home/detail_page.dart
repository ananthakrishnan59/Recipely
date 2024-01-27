import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:random_string/random_string.dart';
import 'package:recipely/datas/hive_db.dart';
import 'package:recipely/datas/shared_preference.dart';
import 'package:recipely/models/model_recipe.dart';
import 'package:recipely/models/user_model.dart';
import 'package:recipely/screens/adminscreen/admin_add.dart';
import 'package:recipely/service/fire_collection.dart';
import 'package:recipely/service/fire_database.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';

class RecipeDetails extends StatefulWidget {
  final Recipes recipeModel;
  final String? userName;
  final String? userProfile;

  const RecipeDetails({
    Key? key,
    required this.recipeModel,
    this.userName,
    this.userProfile,
  }) : super(key: key);

  @override
  State<RecipeDetails> createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetails> {
  ValueNotifier<bool> isFavorite = ValueNotifier(false);
  final formKey = GlobalKey<FormState>();
  final reviewController = TextEditingController();
  bool change = false;

  Future<void> getUser() async {
    final username = await shared_preferences.getName();
    isFavorite.value = widget.recipeModel.favoritesUserIds.contains(username);
    print(isFavorite.value);
    print(username);
  }

  @override
  void initState() {
    getUser();
    super.initState();
    print(isFavorite);

    print(widget.userName);
    print(widget.userProfile);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: SlidingUpPanel(
        parallaxEnabled: true,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
        ),
        minHeight: (size.height / 2),
        maxHeight: size.height / 1.2,
        panel: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 5,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                widget.recipeModel.title,
                style: textTheme.headline6,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                widget.recipeModel.description,
                style: textTheme.caption,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isFavorite.value = !isFavorite.value;
                        addAndRemoveFavorite(widget.recipeModel);
                      });
                    },
                    child: ValueListenableBuilder(
                        valueListenable: isFavorite,
                        builder: (context, value, _) {
                          return Icon(
                            Icons.favorite,
                            color: isFavorite.value ? Colors.red : Colors.grey,
                          );
                        }),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const Icon(
                    Icons.timer,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    widget.recipeModel.time.toString(),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: 2,
                    height: 30,
                    color: Colors.black,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Divider(
                color: Colors.black.withOpacity(0.3),
              ),
              DefaultTabController(
                length: 3,
                child: Expanded(
                  child: Column(
                    children: [
                      TabBar(
                        isScrollable: true,
                        indicatorColor: Colors.red,
                        tabs: [
                          Tab(
                            text: "Ingredients".toUpperCase(),
                          ),
                          Tab(
                            text: "Preparation".toUpperCase(),
                          ),
                          Tab(
                            text: "Reviews".toUpperCase(),
                          ),
                        ],
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.black.withOpacity(0.3),
                        labelStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        labelPadding: const EdgeInsets.symmetric(
                          horizontal: 32,
                        ),
                      ),
                      Divider(
                        color: Colors.black.withOpacity(0.3),
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            Ingredients(recipeModel: widget.recipeModel),
                            SingleChildScrollView(
                              child: Text(widget.recipeModel.procedure),
                            ),
                            // Second Tab with review data
                            // Third Tab with comment input
                            Stack(
                              children: [
                                StreamBuilder<QuerySnapshot>(
                                  stream: reviewCollection
                                      .doc(widget.recipeModel.id!)
                                      .collection('reviews')
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    }

                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    }

                                    if (!snapshot.hasData ||
                                        snapshot.data!.docs.isEmpty) {
                                      // Display a message when there is no data
                                      return Text('No reviews available.');
                                    }

                                    // Process data from the snapshot
                                    final List<DocumentSnapshot> documents =
                                        snapshot.data!.docs;
                                    print(documents[0]);
                                    // Use the data to build your UI
                                    return ListView.builder(
                                      itemCount: documents.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          title: Container(
                                            decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 241, 233, 233),
                                              border: Border.all(),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(documents[index]
                                                          .get('username')),
                                                      CircleAvatar(
                                                        backgroundImage:
                                                            NetworkImage(documents[
                                                                    index]
                                                                .get(
                                                                    'profile')),
                                                      )
                                                    ],
                                                  ),
                                                  Text(documents[index]
                                                          .get('addreview') ??
                                                      'No review'),
                                                ],
                                              ),
                                            ),
                                          ),
                                          // Customize as needed
                                        );
                                      },
                                    );
                                  },
                                ),
                                const Positioned(
                                  left: 0,
                                  right: 0,
                                  bottom: 45,
                                  child: Divider(
                                    thickness: 1.6,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: InkWell(
                                    onTap: () {
                                      showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          content: Container(
                                            height: 200,
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10),
                                                  child: Text(
                                                    'Comment Your Genuine Review',
                                                    style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 50),
                                                  child: Form(
                                                    key: formKey,
                                                    child: TextFormField(
                                                      controller:
                                                          reviewController,
                                                      maxLines: null,
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText:
                                                            "Enter Your Comments",
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            ElevatedButton(
                                              onPressed: () async {
                                                if (formKey.currentState!
                                                    .validate()) {
                                                  final userBox =
                                                      await Hive.box<User>(
                                                          'users');
                                                  final profileUrl =
                                                      await uploadImageToFirebase(
                                                          imagePath: userBox
                                                              .values
                                                              .first
                                                              .image!,
                                                          recipeName:
                                                              'review profiles');
                                                  Map<String, dynamic>
                                                      recipeInfoMap = {
                                                    'addreview':
                                                        reviewController.text,
                                                    'profile': profileUrl,
                                                    'username': userBox
                                                        .values.first.username,
                                                  };
                                                  Navigator.pop(context);
                                                  DatabaseMethods()
                                                      .addRecipereview(
                                                    recipeInfoMap,
                                                    widget.recipeModel.id!,
                                                  );
                                                  reviewController.clear();
                                                }
                                              },
                                              child: Text('Post'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(width: 1),
                                        color:
                                            Color.fromARGB(255, 228, 225, 225),
                                      ),
                                      height: 50,
                                      width: 380,
                                      child: Center(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 120),
                                          child: Text('Enter Your Comment'),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              RecipeImagesCarousel(photoList: widget.recipeModel.photo),
              Positioned(
                top: 40,
                left: 20,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    CupertinoIcons.back,
                    color: Colors.white,
                    size: 38,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class addreview {
  final String reviewText;
  final String userIdd;
  final String userProfile;

  addreview(
      {required this.reviewText,
      required this.userIdd,
      required this.userProfile});
}

class RecipeImagesCarousel extends StatelessWidget {
  final List<String> photoList;

  const RecipeImagesCarousel({
    Key? key,
    required this.photoList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: CarouselSlider(
        options: CarouselOptions(
          height: MediaQuery.of(context).size.height * 0.5,
          enlargeCenterPage: true,
          autoPlay: true,
          aspectRatio: 2.0,
        ),
        items: photoList.map((photo) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: MediaQuery.of(context).size.width,
                // margin: const EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(photo),
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}

class Ingredients extends StatelessWidget {
  final Recipes recipeModel;

  const Ingredients({
    Key? key,
    required this.recipeModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 2.0,
              ),
              child: Text(
                recipeModel.incredients,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> getData() async {
  QuerySnapshot querySnapshot = await reviewCollection.get();
  // Process data from the querySnapshot
  final List<QueryDocumentSnapshot> documents = querySnapshot.docs;
  // Use the data to build your UI
  for (QueryDocumentSnapshot document in documents) {
    print(document.get('username'));
    // Customize as needed
  }
}
