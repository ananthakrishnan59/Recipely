import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipely/datas/hive_db.dart';
import 'package:recipely/datas/shared_preference.dart';
import 'package:recipely/models/model_recipe.dart';
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
                  length: 2,
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
                              child: Container(
                                child: Text(widget.recipeModel.procedure),
                              ),
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
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  // SizedBox(
                  //   width: double.infinity,
                  //   height: 200,
                  //   child: ListView.separated(
                  //     shrinkWrap: true,
                  //     itemCount: widget.recipeModel.photo.length,
                  //     scrollDirection: Axis.horizontal,
                  //     separatorBuilder: (context, index) =>
                  //         const SizedBox(width: 10),
                  //     itemBuilder: (context, index) => ClipRRect(
                  //       child: Image(
                  //         width: double.infinity,
                  //         height: (size.height / 2) + 50,
                  //         fit: BoxFit.cover,
                  //         image: FileImage(File(widget.recipeModel.photo[0])),
                  //       ),
                  //     ),
                  //   ),
                  // )
                 Container(
  height: MediaQuery.of(context).size.height * 0.5, // Adjust the multiplier as needed
  width: MediaQuery.of(context).size.width,
  color: Colors.amber,
  child: ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: widget.recipeModel.photo.length,
    itemBuilder: (context, index) => Container(
      height: MediaQuery.of(context).size.height * 0.5, // Adjust the multiplier as needed
      width: MediaQuery.of(context).size.width * 1.2,// Adjust the multiplier as needed
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: FileImage(
            File(widget.recipeModel.photo[index]),
          ),
        ),
      ),
    ),
  ),
)

                ],
              ),
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
