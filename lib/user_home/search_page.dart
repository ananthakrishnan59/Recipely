import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:recipely/models/model_recipe.dart';
import 'package:recipely/user_home/detail_page.dart';

class Searchpage extends StatefulWidget {
  const Searchpage(
      {Key? key, required this.recipesList, required this.initialCategory})
      : super(key: key);

  final List<Recipes> recipesList;
  final String initialCategory;

  @override
  State<Searchpage> createState() => _SearchpageState();
}

class _SearchpageState extends State<Searchpage> {
  late List<Recipes> filteredRecipesList;

  @override
  void initState() {
    super.initState();
    widget.recipesList.isNotEmpty ? print('true') : print('false');
    filteredRecipesList = widget.recipesList.toList();
    // filteredRecipesList.sort((a, b) => a.title.compareTo(b.title));
    filterRecipes('');
  }

  filterRecipes(String query) {
    setState(() {
      filteredRecipesList = widget.recipesList
          .where((recipe) =>
              recipe.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
      filteredRecipesList.sort((a, b) => a.time.compareTo(b.time));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1EDEC7),
        title: const Text('Search Recipes'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: filterRecipes,
              decoration: const InputDecoration(
                hintText: 'Search by recipe name',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: filteredRecipesList.isNotEmpty
                ? ListView.builder(
                    itemCount: filteredRecipesList.length,
                    itemBuilder: (context, index) {
                      final recipe = filteredRecipesList[index];

                      // Check if the image file exists
                      final imageFile = File(recipe.photo as String);
                      if (!imageFile.existsSync()) {
                        return InkWell(
                          child: Container(),
                        ); // or a placeholder image
                      }

                      Image image = Image.file(imageFile,
                          width: 50, height: 50, fit: BoxFit.cover);

                      return GestureDetector(
                        onTap: () {
                          // Navigate to RecipeDetails page when an item is tapped
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  RecipeDetails(recipeModel: recipe),
                            ),
                          );
                        },
                        child: ListTile(
                          title: Text(recipe.title),
                          subtitle: Text(recipe.category),
                          leading: image,
                          // Add any other details you want to display
                        ),
                      );
                    },
                  )
                : Padding(
                    padding: const EdgeInsets.only(right: 70),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset(
                            'assets/images/not found.json',
                            width: 200, // Adjust the width as needed
                            height: 200, // Adjust the height as needed
                            fit: BoxFit.cover,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 54),
                            child: Text(
                              "Your Item is NOt Cooked Yet",
                              style: GoogleFonts.poppins(
                                  color:
                                      const Color.fromARGB(255, 109, 108, 108),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
