import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipely/datas/hive_db.dart';
import 'package:recipely/datas/shared_preference.dart';
import 'package:recipely/models/model_recipe.dart';
import 'package:recipely/util/review.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class RecipeDetails extends StatefulWidget {
  final Recipes recipeModel;

  const RecipeDetails({
    Key? key,
    required this.recipeModel,
  }) : super(key: key);

  @override
  State<RecipeDetails> createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetails> {
  ValueNotifier<bool> isFavorite = ValueNotifier(false);
  
  get reviewController => null;

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
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
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
                    widget.recipeModel.time,
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
              Expanded(
                child: DefaultTabController(
                  length: 3,
                  initialIndex: 0,
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
                           Stack(
                            children: [
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
                                  child: ReviewTextField(
                                    controller: reviewController,
                                    onTap: () {
                                      String trimmedText =
                                          reviewController.text.trim();
                                      if (trimmedText.isNotEmpty) {
                                        // addreview (
                                        //   reviewText: reviewController.text.trim(),
                                        //   userIdd: userId,
                                        //   userProfile: userProfile,
                                        // );
                                        reviewController.clear();
                                      }
                                    },
                                  ),
                                ), 
                            ],
                           )
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
                    image: FileImage(File(photo)),
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
