import 'package:cookpedia/screens/view_recipe_screen.dart';
import 'package:cookpedia/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecipeCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String postedBy;
  final bool isFavorite;
  final void Function()? clickFavorite;

  const RecipeCard({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.postedBy,
    required this.isFavorite,
    this.clickFavorite,
  }) : super(key: key);

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
                  builder: (context) => const ViewRecipe(
                    recipeId: "1",
                    recipeTitle: 'recipeTitle',
                    recipeAuthorId: 'yd9873wifDXKimy3ItHmz5viW4h2',
                    recipeImage:
                        'https://images.unsplash.com/photo-1547496502-affa22d38842?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=977&q=80',
                    recipeDescription: 'recipeDescription',
                    recipeCookTime: 'recipeCookTime',
                    recipeServes: '12',
                    recipeCategory: 'recipeCategory',
                    ingredients: ['ingredients'],
                    instructions: ['instructions'],
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
                        overflow: TextOverflow.ellipsis,
                        title,
                        style: GoogleFonts.urbanist(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        overflow: TextOverflow.ellipsis,
                        'By $postedBy',
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
                  imageUrl,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 1,
            child: ElevatedButton(
              onPressed: clickFavorite,
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(8),
              ),
              child: Icon(
                isFavorite
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
