import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  final String recipeId;
  final String recipeTitle;
  final String recipeCategory;
  final String recipeImage;
  final String recipeDescription;
  final String recipeCookTime;
  final int recipeServes;
  final String recipeAuthorId;
  final DateTime recipePublished;
  final List<String> ingredients;
  final List<String> instructions;
  final List<String> likes;
  
  Recipe({
    required this.recipeId,
    required this.recipeTitle,
    required this.recipeCategory,
    required this.recipeImage,
    required this.recipeDescription,
    required this.recipeCookTime,
    required this.recipeServes,
    required this.recipeAuthorId,
    required this.recipePublished,
    required this.ingredients,
    required this.instructions,
    required this.likes,
  });
  
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'recipeId': recipeId,
      'recipeTitle': recipeTitle,
      'recipeCategory': recipeCategory,
      'recipeImage': recipeImage,
      'recipeDescription': recipeDescription,
      'recipeCookTime': recipeCookTime,
      'recipeServes': recipeServes,
      'recipeAuthorId': recipeAuthorId,
      'recipePublished': recipePublished,
      'ingredients': ingredients,
      'instructions': instructions,
      'likes': likes,
    };
  }

  static Recipe fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Recipe(
      recipeId: snapshot['recipeId'],
      recipeTitle: snapshot['recipeTitle'],
      recipeCategory: snapshot['recipeCategory'],
      recipeImage: snapshot['recipeImage'],
      recipeDescription: snapshot['recipeDescription'],
      recipeCookTime: snapshot['recipeCookTime'],
      recipeServes: snapshot['recipeServes'],
      recipeAuthorId: snapshot['recipeAuthorId'],
      recipePublished: snapshot['recipePublished'],
      ingredients: snapshot['ingredients'],
      instructions: snapshot['instructions'],
      likes: snapshot['likes'],
    );
  }
}
