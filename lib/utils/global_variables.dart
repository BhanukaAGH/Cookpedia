import 'package:cookpedia/screens/add_recipe_screen.dart';
import 'package:cookpedia/screens/favorite_recipe_screen.dart';
import 'package:cookpedia/screens/my_recipe_screen.dart';
import 'package:cookpedia/screens/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cookpedia/screens/home_screen.dart';

List<Widget> mainScreens = [
  const AddRecipeScreen(),
  const HomeScreen(),
  const MyRecipeScreen(),
  const FavoriteScreen(),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
];
