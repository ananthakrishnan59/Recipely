import 'package:hive_flutter/adapters.dart';
import 'package:recipely/models/model_recipe.dart';

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