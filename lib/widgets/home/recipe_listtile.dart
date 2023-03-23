import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookpedia/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecipeListTile extends StatefulWidget {
  final String title;
  final String imageUrl;
  final String postedBy;
  final String cookTime;
  final void Function()? viewRecipe;

  const RecipeListTile({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.postedBy,
    required this.cookTime,
    this.viewRecipe,
  }) : super(key: key);

  @override
  State<RecipeListTile> createState() => _RecipeListTileState();
}

class _RecipeListTileState extends State<RecipeListTile> {
  String recipeAuthorName = "";
  @override
  void initState() {
    super.initState();
    getRecipeAuthorDetails();
  }

  void getRecipeAuthorDetails() async {
    final recipeAuthor = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.postedBy)
        .get();

    setState(() {
      recipeAuthorName = recipeAuthor['username'];
    });
  }

  @override
  void dispose() {
    recipeAuthorName = "";
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 112,
      margin: const EdgeInsets.only(bottom: 6),
      child: Card(
        elevation: 4,
        color: secondaryColor,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      overflow: TextOverflow.ellipsis,
                      widget.title,
                      style: GoogleFonts.urbanist(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      overflow: TextOverflow.ellipsis,
                      recipeAuthorName,
                      style: GoogleFonts.urbanist(
                        color: Colors.grey.shade500,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.schedule_rounded,
                              color: primaryColor,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.cookTime,
                              style: GoogleFonts.urbanist(
                                color: primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: widget.viewRecipe,
                          splashColor: Colors.grey.shade200,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'View Recipe',
                                style: GoogleFonts.urbanist(
                                  color: primaryColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 2),
                              const Icon(
                                Icons.arrow_right_alt_rounded,
                                color: primaryColor,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
