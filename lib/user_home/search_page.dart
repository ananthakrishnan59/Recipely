import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:recipely/models/model_recipe.dart';
import 'package:recipely/user_home/detail_page.dart';
import 'package:recipely/widget/widget.dart';

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
  String selectedFilter = 'All';
  @override
  void initState() {
    super.initState();
    widget.recipesList.isNotEmpty ? print('true') : print('false');
    filteredRecipesList = widget.recipesList.toList();
    // filteredRecipesList.sort((a, b) => a.title.compareTo(b.title));
    filteredRecipesList = widget.recipesList.toList();
    filterRecipes('');
  }

  filterRecipes(String query) {
    setState(() {
      filteredRecipesList = widget.recipesList
          .where((recipe) =>
              recipe.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
      if (selectedFilter != 'All') {
        // Apply additional filtering based on the selected filter
        if (selectedFilter == '0-15') {
          filteredRecipesList = filteredRecipesList
              .where((recipe) =>
                  int.parse(recipe.time) >= 0 && int.parse(recipe.time) <= 15)
              .toList();
        } else if (selectedFilter == '16-30') {
          filteredRecipesList = filteredRecipesList
              .where((recipe) =>
                  int.parse(recipe.time) >= 16 && int.parse(recipe.time) <= 30)
              .toList();
        } else if (selectedFilter == '31-45') {
          filteredRecipesList = filteredRecipesList
              .where((recipe) =>
                  int.parse(recipe.time) >= 31 && int.parse(recipe.time) <= 45)
              .toList();
        } else if (selectedFilter == '46-60') {
          filteredRecipesList = filteredRecipesList
              .where((recipe) =>
                  int.parse(recipe.time) >= 46 && int.parse(recipe.time) <= 60)
              .toList();
        } else if (selectedFilter == '60+') {
          filteredRecipesList = filteredRecipesList
              .where((recipe) => int.parse(recipe.time) >= 60)
              .toList();
        }
      }

      filteredRecipesList.sort((a, b) => a.time.compareTo(b.time));
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
          const SizedBox(width: 10),
          Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            width: size.width - 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color.fromARGB(255, 252, 249, 249),
              border: Border.all(color: Colors.black, width: 1),
            ),
            child: DropdownButton<String>(
              borderRadius: BorderRadius.circular(20),
              dropdownColor: Color.fromARGB(255, 241, 239, 239),
              value: selectedFilter,
              onChanged: (String? newValue) {
                setState(() {
                  selectedFilter = newValue!;
                  filterRecipes('');
                });
              },
              isExpanded: true,
              items: <String>['All', '0-15', '16-30', '31-45', '46-60', '60+']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1EDEC7),
                        fontSize: 18),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: filteredRecipesList.isNotEmpty
                ? ListView.builder(
                    itemCount: filteredRecipesList.length,
                    itemBuilder: (context, index) {
                      final recipe = filteredRecipesList[index];

                      // Check if the image file exists
                      final imageFile = File(recipe.photo[0]);
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
