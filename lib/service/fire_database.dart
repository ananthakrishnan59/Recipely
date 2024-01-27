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
  Future addRecipereview(Map<String, dynamic> recipeReview, String ids) async {
    return await FirebaseFirestore.instance
        .collection("addreview")
        .doc(ids)
        .set(recipeReview);
  }
}
