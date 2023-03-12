import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookpedia/screens/view_recipe_screen.dart';
import 'package:cookpedia/widgets/home/main_recipe_list.dart';
import 'package:cookpedia/widgets/home/recipe_listtile.dart';
import 'package:cookpedia/widgets/home/search_bar.dart';
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
              const SizedBox(height: 12),

              //! Search bar
              const SearchBar(),
              const SizedBox(height: 8),

              //! Horizontal Recipe List
              SizedBox(
                height: 260,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('recipes')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final recipes = snapshot.data!.docs;

                    final categories = <dynamic>{};
                    for (var recipe in recipes) {
                      categories.add(recipe.data()['recipeCategory']);
                    }

                    //! Categorie List
                    return MainRecipeList(
                      categories: categories,
                      recipes: recipes,
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
