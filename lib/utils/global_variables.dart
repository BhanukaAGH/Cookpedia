import 'package:cookpedia/screens/add_recipe_screen.dart';
import 'package:cookpedia/screens/favorite_recipe_screen.dart';
import 'package:cookpedia/screens/my_recipe_screen.dart';
import 'package:cookpedia/screens/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cookpedia/screens/home_screen.dart';

List<Widget> mainScreens = [
  const HomeScreen(),
  const MyRecipeScreen(),
  const AddRecipeScreen(),
  const FavoriteScreen(),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
];

final List<String> recipeCategories = [
  'Appetizers',
  'Beverages',
  'Breads',
  'Breakfast',
  'Desserts',
  'Main Dishes',
  'Pasta',
  'Salads',
  'Sandwiches/Wraps',
  'Sauces/Dressings',
  'Seafood',
  'Side Dishes',
  'Snacks',
  'Soups/Stews',
  'Vegetarian/Vegan',
];

final List<Map<String, dynamic>> recipes = [
  {
    "recipeId": "1",
    "recipeTitle": "Chicken Adobo",
    "recipeCategory": "Main Dishes",
    "recipeImage":
        "https://images.unsplash.com/photo-1518779578993-ec3579fee39f?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=735&q=80",
    "recipeDescription":
        "Chicken Adobo is a Filipino dish of chicken pieces cooked in vinegar, soy sauce, garlic, and black peppercorns.",
    "ingredients": [
      "1/2 cup soy sauce",
      "1/2 cup vinegar",
      "1/2 cup water",
      "1/2 cup brown sugar",
      "1/2 cup cooking oil",
      "1/2 cup garlic, minced",
      "1/2 cup onion, minced",
      "1/2 cup bay leaves",
      "1/2 cup black peppercorns",
      "1/2 cup chicken, cut into serving pieces"
    ],
    "instructions": [
      "In a large bowl, mix together the soy sauce, vinegar, water, brown sugar, cooking oil, garlic, onion, bay leaves, and black peppercorns. Stir until the sugar and salt are dissolved.",
      "Place the chicken pieces in a large resealable plastic bag with the marinade, seal, and turn to coat; refrigerate for at least 2 hours.",
      "Preheat oven to 350 degrees F (175 degrees C).",
      "Place the chicken pieces in a single layer in a 9x13-inch baking dish. Pour the remaining marinade over the chicken.",
      "Bake in the preheated oven for 1 hour, or until chicken is no longer pink and juices run clear. An instant-read thermometer inserted into the center should read at least 165 degrees F (74 degrees C)."
    ],
    "recipeCookTime": "1 hour",
    "recipeServes": "4",
    "recipeAuthor": "Johns Smilga",
    "recipeAuthorImage":
        "https://images.unsplash.com/photo-1676189223716-2ca6e6ffef24?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80"
  },
  {
    "recipeId": "2",
    "recipeTitle": "Chicken Adobo",
    "recipeCategory": "Main Dishes",
    "recipeImage":
        "https://images.unsplash.com/photo-1547496502-affa22d38842?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=977&q=80",
    "recipeDescription":
        "Chicken Adobo is a Filipino dish of chicken pieces cooked in vinegar, soy sauce, garlic, and black peppercorns.",
    "ingredients": [
      "1/2 cup soy sauce",
      "1/2 cup vinegar",
      "1/2 cup water",
      "1/2 cup brown sugar",
      "1/2 cup cooking oil",
      "1/2 cup garlic, minced",
      "1/2 cup onion, minced",
      "1/2 cup bay leaves",
      "1/2 cup black peppercorns",
      "1/2 cup chicken, cut into serving pieces"
    ],
    "instructions": [
      "In a large bowl, mix together the soy sauce, vinegar, water, brown sugar, cooking oil, garlic, onion, bay leaves, and black peppercorns. Stir until the sugar and salt are dissolved.",
      "Place the chicken pieces in a large resealable plastic bag with the marinade, seal, and turn to coat; refrigerate for at least 2 hours.",
      "Preheat oven to 350 degrees F (175 degrees C).",
      "Place the chicken pieces in a single layer in a 9x13-inch baking dish. Pour the remaining marinade over the chicken.",
      "Bake in the preheated oven for 1 hour, or until chicken is no longer pink and juices run clear. An instant-read thermometer inserted into the center should read at least 165 degrees F (74 degrees C)."
    ],
    "recipeCookTime": "1 hour",
    "recipeServes": "4",
    "recipeAuthor": "Johns Smilga",
    "recipeAuthorImage":
        "https://images.unsplash.com/photo-1676189223716-2ca6e6ffef24?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80"
  },
  {
    "recipeId": "3",
    "recipeTitle": "Chicken Adobo",
    "recipeCategory": "Main Dishes",
    "recipeImage":
        "https://images.unsplash.com/photo-1510629954389-c1e0da47d414?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80",
    "recipeDescription":
        "Chicken Adobo is a Filipino dish of chicken pieces cooked in vinegar, soy sauce, garlic, and black peppercorns.",
    "ingredients": [
      "1/2 cup soy sauce",
      "1/2 cup vinegar",
      "1/2 cup water",
      "1/2 cup brown sugar",
      "1/2 cup cooking oil",
      "1/2 cup garlic, minced",
      "1/2 cup onion, minced",
      "1/2 cup bay leaves",
      "1/2 cup black peppercorns",
      "1/2 cup chicken, cut into serving pieces"
    ],
    "instructions": [
      "In a large bowl, mix together the soy sauce, vinegar, water, brown sugar, cooking oil, garlic, onion, bay leaves, and black peppercorns. Stir until the sugar and salt are dissolved.",
      "Place the chicken pieces in a large resealable plastic bag with the marinade, seal, and turn to coat; refrigerate for at least 2 hours.",
      "Preheat oven to 350 degrees F (175 degrees C).",
      "Place the chicken pieces in a single layer in a 9x13-inch baking dish. Pour the remaining marinade over the chicken.",
      "Bake in the preheated oven for 1 hour, or until chicken is no longer pink and juices run clear. An instant-read thermometer inserted into the center should read at least 165 degrees F (74 degrees C)."
    ],
    "recipeCookTime": "1 hour",
    "recipeServes": "4",
    "recipeAuthor": "Johns Smilga",
    "recipeAuthorImage":
        "https://images.unsplash.com/photo-1676017030149-4386669c189d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80"
  },
  {
    "recipeId": "4",
    "recipeTitle": "Chicken Adobo",
    "recipeCategory": "Main Dishes",
    "recipeImage":
        "https://images.unsplash.com/photo-1518779578993-ec3579fee39f?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=735&q=80",
    "recipeDescription":
        "Chicken Adobo is a Filipino dish of chicken pieces cooked in vinegar, soy sauce, garlic, and black peppercorns.",
    "ingredients": [
      "1/2 cup soy sauce",
      "1/2 cup vinegar",
      "1/2 cup water",
      "1/2 cup brown sugar",
      "1/2 cup cooking oil",
      "1/2 cup garlic, minced",
      "1/2 cup onion, minced",
      "1/2 cup bay leaves",
      "1/2 cup black peppercorns",
      "1/2 cup chicken, cut into serving pieces"
    ],
    "instructions": [
      "In a large bowl, mix together the soy sauce, vinegar, water, brown sugar, cooking oil, garlic, onion, bay leaves, and black peppercorns. Stir until the sugar and salt are dissolved.",
      "Place the chicken pieces in a large resealable plastic bag with the marinade, seal, and turn to coat; refrigerate for at least 2 hours.",
      "Preheat oven to 350 degrees F (175 degrees C).",
      "Place the chicken pieces in a single layer in a 9x13-inch baking dish. Pour the remaining marinade over the chicken.",
      "Bake in the preheated oven for 1 hour, or until chicken is no longer pink and juices run clear. An instant-read thermometer inserted into the center should read at least 165 degrees F (74 degrees C)."
    ],
    "recipeCookTime": "1 hour",
    "recipeServes": "4",
    "recipeAuthor": "Johns Smilga",
    "recipeAuthorImage":
        "https://images.unsplash.com/photo-1676107265470-a9990d72a89c?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=744&q=80"
  }
];
