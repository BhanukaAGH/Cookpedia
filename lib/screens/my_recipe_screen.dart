import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookpedia/providers/user_provider.dart';
import 'package:cookpedia/screens/view_recipe_screen.dart';
import 'package:cookpedia/utils/global_variables.dart';
import 'package:cookpedia/utils/utils.dart';
import 'package:cookpedia/widgets/home/recipe_listtile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MyRecipeScreen extends StatelessWidget {
  const MyRecipeScreen({super.key});

  void deleteRecipe(BuildContext context) async {
    showAlertDialog(
      context: context,
      title: 'Delete Recipe',
      description: 'Are you sure you want to delete this recipe?',
      continueText: 'Delete',
      continueFunc: () {},
    );
  }

  void editRecipe() {}

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Recipes',
                style: GoogleFonts.urbanist(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),

              //! Search Bar
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: const [
                      Icon(Icons.search),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              //! My Recipe List
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.74,
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('recipes')
                        .where('recipeAuthorId', isEqualTo: user.uid)
                        .snapshots(),
                    builder: (context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final recipe = snapshot.data!.docs[index].data();

                          return Slidable(
                            key: ValueKey(index),
                            startActionPane: ActionPane(
                              motion: const DrawerMotion(),
                              children: [
                                SlidableAction(
                                  borderRadius: BorderRadius.circular(10),
                                  onPressed: (context) => deleteRecipe(context),
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                ),
                              ],
                            ),
                            endActionPane: ActionPane(
                              motion: const StretchMotion(),
                              children: [
                                SlidableAction(
                                  borderRadius: BorderRadius.circular(10),
                                  onPressed: (context) => editRecipe(),
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  icon: Icons.edit,
                                  label: 'Edit',
                                ),
                              ],
                            ),
                            child: RecipeListTile(
                              title: recipe['recipeTitle'],
                              imageUrl: recipe['recipeImage'],
                              postedBy: "John Doe",
                              cookTime: recipe['recipeCookTime'],
                              viewRecipe: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ViewRecipe(
                                      recipeId: recipe['recipeId'],
                                      recipeTitle: recipe['recipeTitle'],
                                      recipeAuthor: "John Doe",
                                      recipeAuthorImage:
                                          "https://images.unsplash.com/photo-1676189223716-2ca6e6ffef24?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80",
                                      recipeImage: recipe['recipeImage'],
                                      recipeDescription:
                                          recipe['recipeDescription'],
                                      recipeCookTime: recipe['recipeCookTime'],
                                      recipeServes:
                                          recipe['recipeServes'].toString(),
                                      recipeCategory: recipe['recipeCategory'],
                                      ingredients: recipe['ingredients'],
                                      instructions: recipe['instructions'],
                                    ),
                                  ),
                                );
                              },
                            ),
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
