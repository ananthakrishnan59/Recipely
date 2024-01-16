import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethod {
  Future addRecipeDetails(Map<String, dynamic> recipeInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("Recipies")
        .doc(id)
        .set(recipeInfoMap);
  }
}
