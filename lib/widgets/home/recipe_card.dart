import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookpedia/screens/view_recipe_screen.dart';
import 'package:cookpedia/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecipeCard extends StatefulWidget {
  final Map<String, dynamic> recipe;
  final bool isFavorite;
  final void Function()? clickFavorite;

  const RecipeCard({
    Key? key,
    required this.recipe,
    required this.isFavorite,
    this.clickFavorite,
  }) : super(key: key);

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  String recipeAuthorName = "";
  @override
  void initState() {
    super.initState();
    getRecipeAuthorDetails();
  }

  void getRecipeAuthorDetails() async {
    final recipeAuthor = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.recipe['recipeAuthorId'])
        .get();

    setState(() {
      recipeAuthorName = recipeAuthor['username'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.2,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ViewRecipe(
                    recipeId: widget.recipe['recipeId'],
                    recipeTitle: widget.recipe['recipeTitle'],
                    recipeAuthorId: widget.recipe['recipeAuthorId'],
                    recipeImage: widget.recipe['recipeImage'],
                    recipeDescription: widget.recipe['recipeDescription'],
                    recipeCookTime: widget.recipe['recipeCookTime'],
                    recipeServes: widget.recipe['recipeServes'].toString(),
                    recipeCategory: widget.recipe['recipeCategory'],
                    ingredients: widget.recipe['ingredients'],
                    instructions: widget.recipe['instructions'],
                    recipePublished: widget.recipe['recipePublished'].toDate(),
                  ),
                ),
              );
            },
            child: Card(
              clipBehavior: Clip.antiAlias,
              elevation: 3,
              shape: const RoundedRectangleBorder(
                side: BorderSide(
                  color: borderColor,
                ),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: GridTile(
                footer: Container(
                  height: 64,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.8),
                        Colors.black.withOpacity(0.3),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.recipe['recipeTitle'],
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.urbanist(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'By $recipeAuthorName',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.urbanist(
                          height: 1.4,
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                child: Image.network(
                  widget.recipe['recipeImage'],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 1,
            child: ElevatedButton(
              onPressed: widget.clickFavorite,
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(8),
              ),
              child: Icon(
                widget.isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
