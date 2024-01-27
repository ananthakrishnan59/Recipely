import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethod {
  Future addRecipeDetails(Map<String, dynamic> recipeInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("Recipies")
        .doc(id)
        .set(recipeInfoMap);
  }
}

class DatabaseMethods {
  Future addRecipereview(Map<String, dynamic> recipeReview, String id) async {
    return await FirebaseFirestore.instance
        .collection("Recipies")
        .doc(id)
        .collection('reviews')
        .doc()
        .set(recipeReview);
  }
}
