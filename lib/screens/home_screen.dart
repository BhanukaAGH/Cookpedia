import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookpedia/screens/view_recipe_screen.dart';
import 'package:cookpedia/utils/colors.dart';
import 'package:cookpedia/utils/global_variables.dart';
import 'package:cookpedia/widgets/home/recipe_card.dart';
import 'package:cookpedia/widgets/home/recipe_listtile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'What would you like to \ncook today?',
                style: GoogleFonts.urbanist(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),

              //! Search bar
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search',
                          hintStyle: GoogleFonts.urbanist(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //! Categorie List
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ...['All', ...recipeCategories].map(
                      (category) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: secondaryColor,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            category,
                            style: GoogleFonts.urbanist(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //! Horizontal Recipe List
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return RecipeCard(
                      title: "Recipe Title",
                      imageUrl:
                          'https://images.unsplash.com/photo-1604908177453-7462950a6a3b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1057&q=80',
                      postedBy: 'Kamal Gunawardhana',
                      isFavorite: true,
                      clickFavorite: () {},
                    );
                  },
                ),
              ),

              //! Recent Recipes Title
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  'Recent Recipes',
                  style: GoogleFonts.urbanist(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 6),

              //! Vertical Recent Recipes List
              Expanded(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('recipes')
                        .orderBy('recipePublished', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final recipe = snapshot.data!.docs[index].data();

                          return RecipeListTile(
                            title: recipe['recipeTitle'],
                            imageUrl: recipe['recipeImage'],
                            postedBy: recipe['recipeAuthorId'],
                            cookTime: recipe['recipeCookTime'],
                            viewRecipe: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ViewRecipe(
                                    recipeId: recipe['recipeId'],
                                    recipeTitle: recipe['recipeTitle'],
                                    recipeAuthorId: recipe['recipeAuthorId'],
                                    recipeImage: recipe['recipeImage'],
                                    recipeDescription:
                                        recipe['recipeDescription'],
                                    recipeCookTime: recipe['recipeCookTime'],
                                    recipeServes:
                                        recipe['recipeServes'].toString(),
                                    recipeCategory: recipe['recipeCategory'],
                                    ingredients: recipe['ingredients'],
                                    instructions: recipe['instructions'],
                                    recipePublished:
                                        recipe['recipePublished'].toDate(),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
