import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookpedia/providers/user_provider.dart';
import 'package:cookpedia/resources/favorite_methods.dart';
import 'package:cookpedia/screens/view_recipe_screen.dart';
import 'package:cookpedia/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RecipeCard extends StatefulWidget {
  final Map<String, dynamic> recipe;
  final bool isFavorite;

  const RecipeCard({
    Key? key,
    required this.recipe,
    required this.isFavorite,
  }) : super(key: key);

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  String recipeAuthorName = "";
  bool _isFavorite = false;
  @override
  void initState() {
    super.initState();
    getRecipeAuthorDetails();
    checkIsFavorite();
  }

  void getRecipeAuthorDetails() async {
    final recipeAuthor = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.recipe['recipeAuthorId'])
        .get();

    if (mounted) {
      setState(() {
        recipeAuthorName = recipeAuthor['username'];
      });
    }
  }

  void checkIsFavorite() async {
    setState(() {
      _isFavorite = widget.isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).getUser;

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
              onPressed: () async {
                await FavoriteMethods()
                    .likeRecipe(
                  widget.recipe['recipeId'],
                  user.uid,
                  widget.recipe['likes'],
                )
                    .then((value) {
                  if (mounted) {
                    setState(() {
                      _isFavorite = !_isFavorite;
                    });
                  }
                  Fluttertoast.showToast(
                    msg: mounted && _isFavorite
                        ? 'Recipe added to favorites'
                        : 'Recipe removed from favorites',
                  );
                });
              },
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(8),
              ),
              child: Icon(
                _isFavorite
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
