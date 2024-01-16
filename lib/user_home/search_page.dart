import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
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

final CollectionReference recipesCollection =
    FirebaseFirestore.instance.collection('Recipies');

class _SearchpageState extends State<Searchpage> {
  late List<Recipes> filteredRecipesList;
  String selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    widget.recipesList.isNotEmpty ? print('true') : print('false');
    filteredRecipesList = widget.recipesList.toList();
    filterRecipes('');
  }

  void filterRecipes(String query) {
    setState(() {
      // Assuming recipesList is the full list of recipes
      List<Recipes> filteredRecipesList = widget.recipesList
          .where((recipe) =>
              recipe.title.toLowerCase().contains(query.toLowerCase()))
          .toList();

      if (selectedFilter != 'All') {
        // Apply additional filtering based on the selected filter
        filteredRecipesList = filteredRecipesList
            .where((recipe) =>
                recipe.time >= getMinTime(selectedFilter) &&
               recipe.time <= getMaxTime(selectedFilter))
            .toList();
      }

      // Sort the recipes based on cooking time
      filteredRecipesList
          .sort((a, b) => a.time.compareTo(b.time));
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
            padding: const EdgeInsets.only(left: 20, right: 20),
            width: size.width - 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color.fromARGB(255, 252, 249, 249),
              border: Border.all(color: Colors.black, width: 1),
            ),
            child: DropdownButton<String>(
              borderRadius: BorderRadius.circular(20),
              dropdownColor: const Color.fromARGB(255, 241, 239, 239),
              value: selectedFilter,
              onChanged: (String? newValue) {
                setState(() {
                  selectedFilter = newValue!;
                  filterRecipes('');
                });
              },
              isExpanded: true,
              items: <String>[
                'All',
                '0-15',
                '16-30',
                '31-45',
                '46-60',
                '60+'
              ].map<DropdownMenuItem<String>>((String value) {
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
            child: FutureBuilder<List<Recipes>>(
              future: getRecipes(selectedFilter),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.data!.isNotEmpty) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final recipe = snapshot.data![index];
                      final imageFile = File(recipe.photo[0]);
                      if (!imageFile.existsSync()) {
                        return InkWell(
                          child: Container(),
                        );
                      }

                      Image image = Image.file(imageFile,
                          width: 50, height: 50, fit: BoxFit.cover);

                      return GestureDetector(
                        onTap: () {
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
                        ),
                      );
                    },
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(right: 70),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset(
                            'assets/images/not found.json',
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 54),
                            child: Text(
                              "Your Item is Not Cooked Yet",
                              style: GoogleFonts.poppins(
                                color: const Color.fromARGB(255, 109, 108, 108),
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }

  // Modify getRecipes to include the filter
  Future<List<Recipes>> getRecipes(String filter) async {
    QuerySnapshot querySnapshot;
    if (filter == 'All') {
      querySnapshot = await recipesCollection.get();
    } else {
      querySnapshot = await recipesCollection
          .where('time', isGreaterThanOrEqualTo: getMinTime(filter))
          .where('time', isLessThanOrEqualTo: getMaxTime(filter))
          .get();
    }

    List<Recipes> recipes = [];
    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      recipes.add(
        Recipes.fromMap(documentSnapshot.data() as Map<String, dynamic>),
      );
    }
    return recipes;
  }

  int getMinTime(String filter) {
    switch (filter) {
      case '0-15':
        return 0;
      case '16-30':
        return 16;
      case '31-45':
        return 31;
      case '46-60':
        return 46;
      case '60+':
        return 60;
      default:
        return 0;
    }
  }

  int getMaxTime(String filter) {
    switch (filter) {
      case '0-15':
        return 15;
      case '16-30':
        return 30;
      case '31-45':
        return 45;
      case '46-60':
        return 60;
      case '60+':
        return 100000;
      default:
        return 1000000;
    }
  }
}
