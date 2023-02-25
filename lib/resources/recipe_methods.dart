import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookpedia/models/recipe.dart';
import 'package:cookpedia/resources/storage_methods.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class RecipeMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //! CREATE POST
  Future<String> createRecipe(
    String recipeTitle,
    String recipeCategory,
    Uint8List imageFile,
    String recipeDescription,
    String recipeCookTime,
    int recipeServes,
    String recipeAuthorId,
    List<String> ingredients,
    List<String> instructions,
  ) async {
    String res = 'some error occured';
    try {
      String imageUrl = await StorageMethods().uploadImageToStorage(
        'recipes',
        imageFile,
        true,
      );

      String recipeId = const Uuid().v1();

      Recipe recipe = Recipe(
        recipeId: recipeId,
        recipeTitle: recipeTitle,
        recipeCategory: recipeCategory,
        recipeImage: imageUrl,
        recipeDescription: recipeDescription,
        recipeCookTime: recipeCookTime,
        recipeServes: recipeServes,
        recipeAuthorId: recipeAuthorId,
        recipePublished: DateTime.now(),
        ingredients: ingredients,
        instructions: instructions,
      );

      _firestore.collection('recipes').doc(recipeId).set(recipe.toJson());
      res = 'Success';
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

  //! UPDATE POST
  Future<String> updateRecipe(
    String recipeId,
    String recipeTitle,
    String recipeCategory,
    Uint8List imageFile,
    String recipeDescription,
    String recipeCookTime,
    int recipeServes,
    String recipeAuthorId,
    List<String> ingredients,
    List<String> instructions,
  ) async {
    String res = 'some error occured';
    try {
      String imageUrl = await StorageMethods().uploadImageToStorage(
        'recipes',
        imageFile,
        true,
      );

      Recipe recipe = Recipe(
        recipeId: recipeId,
        recipeTitle: recipeTitle,
        recipeCategory: recipeCategory,
        recipeImage: imageUrl,
        recipeDescription: recipeDescription,
        recipeCookTime: recipeCookTime,
        recipeServes: recipeServes,
        recipeAuthorId: recipeAuthorId,
        recipePublished: DateTime.now(),
        ingredients: ingredients,
        instructions: instructions,
      );

      _firestore.collection('recipes').doc(recipeId).update(recipe.toJson());
      res = 'Success';
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

  //! DELETE POST
  Future<void> deleteRecipe(String recipeId) async {
    try {
      await _firestore.collection('recipes').doc(recipeId).delete();
    } catch (error) {
      print(error.toString());
    }
  }
}
