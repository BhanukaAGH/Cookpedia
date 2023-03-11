import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookpedia/utils/colors.dart';
import 'package:cookpedia/widgets/home/recipe_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';

class MainRecipeList extends StatefulWidget {
  final Set categories;
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> recipes;

  const MainRecipeList({
    Key? key,
    required this.categories,
    required this.recipes,
  }) : super(key: key);

  @override
  State<MainRecipeList> createState() => _MainRecipeListState();
}

class _MainRecipeListState extends State<MainRecipeList> {
  var selectedCategory = 'All';
  late List<QueryDocumentSnapshot<Map<String, dynamic>>> filteredRecipes;

  @override
  void initState() {
    super.initState();
    filteredRecipes = widget.recipes;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).getUser;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ...['All', ...widget.categories].map(
                (category) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedCategory = category;

                        if (category != 'All') {
                          filteredRecipes = widget.recipes.where((element) {
                            return element.data()['recipeCategory'] ==
                                selectedCategory;
                          }).toList();
                        } else {
                          filteredRecipes = widget.recipes;
                        }
                      });
                    },
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
        Flexible(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: filteredRecipes.length,
            itemBuilder: (context, index) {
              final recipe = filteredRecipes[index].data();

              return RecipeCard(
                recipe: recipe,
                isFavorite: recipe['likes'].contains(user.uid),
              );
            },
          ),
        ),
      ],
    );
  }
}
