import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:recipely/datas/shared_preference.dart';
import 'package:recipely/models/model_recipe.dart';
import 'package:recipely/models/user_model.dart';

ValueNotifier<List<Recipes>> favoriteNotifier = ValueNotifier([]);
String? currentuser;
Future<void> addRecipe(Recipes values) async {
  final recipeBox = await Hive.openBox<Recipes>('recipes');
  final timeKey = DateTime.now().millisecondsSinceEpoch.toString();
  values.timeKey = timeKey;
  print('adding key: $timeKey');
  await recipeBox.put(timeKey, values);
  print('adding recipe with key: $timeKey');
}

Future<List<Recipes>> getrecipe() async {
  final recipeBox = await Hive.openBox<Recipes>('recipes');
  return recipeBox.values.toList();
}

// Future<int> getKey(Recipes recipiesToGetKey) async {
//   var recipeBox = await Hive.openBox<Recipes>('recipes');
//   var key =
//       recipeBox.keyAt(recipeBox.values.toList().indexOf(recipiesToGetKey));
//   return key;
// }

Future<void> updateRecipe(Recipes recipe, String key) async {
  var recipeBox = await Hive.openBox<Recipes>('recipes');
  print('key for updation: $key');
  await recipeBox.put(key, recipe);
  print('updating recipe with key: $key');
}

Future<void> deleteRecipe(String key) async {
  print('Deleting recipe with key: $key');
  final recipeBox = await Hive.openBox<Recipes>('recipes');
  await recipeBox.delete(key);
  print('Recipe deleted successfully');
}

Future<void> getFavorites() async {
  try {
    final box = await Hive.openBox<Recipes>('recipes');
    final name = await shared_preferences.getName();
    print(name);
    final favoriteList = box.values
        .where((food) => food.favoritesUserIds.contains(name))
        .toList();
    favoriteNotifier.value = favoriteList;
  } catch (e) {
    // Handle errors, log, or throw as appropriate
    print('Error in getFavorites: $e');
  }
}

Future<void> addAndRemoveFavorite(Recipes recipe) async {
  try {
    final currentUserId = await shared_preferences.getName();
    if (recipe.favoritesUserIds.contains(currentUserId)) {
      recipe.favoritesUserIds.remove(currentUserId);
    } else {
      recipe.favoritesUserIds.add(currentUserId ?? '');
    }

    final box = await Hive.openBox<Recipes>('recipes');
    await box.put(recipe.time.toString() + recipe.title,
        recipe); // Assuming recipe.id is a unique String identifier
    print('addddddddddddddd');
    getFavorites();
  } catch (e) {
    print('Error in addAndRemoveFavorite: $e');
  }
}

void updateUserInDb(User newUserDetails, int userIndex) {
  final userBox = Hive.box<User>('users');

  if (userIndex >= 0 && userIndex < userBox.length) {
    final updatedUser = User(
      username: newUserDetails.username,
      email: newUserDetails.email,
      password: newUserDetails.password,
      image: newUserDetails.image ?? '',
    );

    userBox.putAt(userIndex, updatedUser);
  }
}
