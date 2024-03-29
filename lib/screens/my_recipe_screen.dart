import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookpedia/providers/user_provider.dart';
import 'package:cookpedia/resources/recipe_methods.dart';
import 'package:cookpedia/screens/edit_recipe_screen.dart';
import 'package:cookpedia/screens/view_recipe_screen.dart';
import 'package:cookpedia/utils/utils.dart';
import 'package:cookpedia/widgets/home/recipe_listtile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MyRecipeScreen extends StatefulWidget {
  const MyRecipeScreen({super.key});

  @override
  State<MyRecipeScreen> createState() => _MyRecipeScreenState();
}

class _MyRecipeScreenState extends State<MyRecipeScreen> {
  final TextEditingController _searchController = TextEditingController();

  void deleteRecipe(BuildContext context, String recipeId) async {
    showAlertDialog(
      context: context,
      title: 'Delete Recipe',
      description: 'Are you sure you want to delete this recipe?',
      continueText: 'Delete',
      continueFunc: () {
        RecipeMethods().deleteRecipe(recipeId);
        Navigator.of(context).pop();
      },
    );
  }

  void editRecipe(BuildContext context, Map<String, dynamic> recipe) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditRecipeScreen(
          recipe: recipe,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
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
                ListTile(
                  minVerticalPadding: 0,
                  minLeadingWidth: 0,
                  horizontalTitleGap: 8,
                  visualDensity: const VisualDensity(vertical: -2),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  tileColor: Colors.grey.shade200,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  leading: Icon(
                    Icons.search,
                    color: Colors.grey.shade600,
                  ),
                  title: TextField(
                    controller: _searchController,
                    onSubmitted: (value) {
                      setState(() {});
                    },
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
                const SizedBox(height: 12),

                //! My Recipe List
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.74,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('recipes')
                        .where('recipeAuthorId', isEqualTo: user.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (snapshot.data!.docs.isEmpty) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            'No recipes found',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.urbanist(
                              color: Colors.black54,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }

                      final filterRecipes = snapshot.data!.docs
                          .where((recipe) => recipe['recipeTitle']
                              .toLowerCase()
                              .contains(_searchController.text.toLowerCase()))
                          .toList();

                      return filterRecipes.isEmpty
                          ? Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                'No matching recipes',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.urbanist(
                                  color: Colors.black54,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: filterRecipes.length,
                              itemBuilder: (context, index) {
                                final recipe = filterRecipes[index].data();

                                return Slidable(
                                  key: ValueKey(index),
                                  startActionPane: ActionPane(
                                    motion: const DrawerMotion(),
                                    children: [
                                      SlidableAction(
                                        borderRadius: BorderRadius.circular(10),
                                        onPressed: (context) => deleteRecipe(
                                          scaffoldKey.currentContext!,
                                          recipe['recipeId'],
                                        ),
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
                                        onPressed: (context) =>
                                            editRecipe(context, recipe),
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
                                  ),
                                );
                              },
                            );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
