import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookpedia/utils/colors.dart';
import 'package:cookpedia/widgets/view_recipe/recipe_specific_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;

class ViewRecipe extends StatefulWidget {
  final String recipeId;
  final String recipeTitle;
  final String recipeImage;
  final String recipeAuthorId;
  final String recipeDescription;
  final String recipeCookTime;
  final String recipeServes;
  final String recipeCategory;
  final List ingredients;
  final List instructions;
  final DateTime recipePublished;

  const ViewRecipe({
    super.key,
    required this.recipeId,
    required this.recipeTitle,
    required this.recipeAuthorId,
    required this.recipeImage,
    required this.recipeDescription,
    required this.recipeCookTime,
    required this.recipeServes,
    required this.recipeCategory,
    required this.ingredients,
    required this.instructions,
    required this.recipePublished,
  });

  @override
  State<ViewRecipe> createState() => _ViewRecipeState();
}

class _ViewRecipeState extends State<ViewRecipe> {
  String recipeAuthorName = "";
  String recipeAuthorImage = "";

  @override
  void initState() {
    super.initState();
    getRecipeAuthorDetails();
  }

  void getRecipeAuthorDetails() async {
    final recipeAuthor = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.recipeAuthorId)
        .get();

    setState(() {
      recipeAuthorName = recipeAuthor['username'];
      recipeAuthorImage = recipeAuthor['profileImg'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        body: Stack(
          children: [
            //! Recipe Image
            Positioned(
              left: 0,
              right: 0,
              child: SizedBox(
                width: double.maxFinite,
                height: MediaQuery.of(context).size.height * 0.35,
                child: Image.network(
                  widget.recipeImage,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            //! Recipe Top Bar
            Positioned(
              top: MediaQuery.of(context).viewPadding.top + 8,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FloatingActionButton.small(
                    heroTag: "backbtn",
                    onPressed: () => Navigator.of(context).pop(),
                    backgroundColor: Colors.grey.shade400,
                    child: const Icon(Icons.arrow_back),
                  ),
                  FloatingActionButton.small(
                    heroTag: "favbtn",
                    onPressed: () {},
                    backgroundColor: primaryColor,
                    child: const Icon(Icons.favorite_border_outlined),
                  ),
                ],
              ),
            ),

            //! Recipe Bottom Sheet
            Positioned(
              left: 0,
              right: 0,
              top: MediaQuery.of(context).size.height * 0.35 - 30,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 24,
                  bottom: 16,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.recipeTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.urbanist(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      leading: CircleAvatar(
                        radius: 24,
                        backgroundImage: recipeAuthorImage.isEmpty
                            ? const AssetImage('assets/user.jpg')
                            : NetworkImage(
                                recipeAuthorImage,
                              ) as ImageProvider,
                      ),
                      title: Text(
                        recipeAuthorName,
                        style: GoogleFonts.urbanist(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        'posted ${timeago.format(widget.recipePublished)}',
                        style: GoogleFonts.urbanist(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          backgroundColor: primaryColor,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                        ),
                        child: Text(
                          "Follow",
                          style: GoogleFonts.urbanist(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const Divider(),
                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Text(
                              widget.recipeDescription,
                              style: GoogleFonts.urbanist(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RecipeSpecificCard(
                                  icon: Icons.schedule_rounded,
                                  label: widget.recipeCookTime,
                                  subLabel: 'cook time',
                                ),
                                RecipeSpecificCard(
                                  icon: Icons.person_outline,
                                  label: '${widget.recipeServes} serving',
                                  subLabel: 'serves',
                                ),
                                RecipeSpecificCard(
                                  icon: Icons.food_bank_outlined,
                                  label: widget.recipeCategory,
                                  subLabel: 'category',
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Divider(),
                            const SizedBox(height: 8),
                            Text(
                              'Ingredients:',
                              style: GoogleFonts.urbanist(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            //! Ingredients List
                            ListView.builder(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: widget.ingredients.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  visualDensity: const VisualDensity(
                                    horizontal: 0,
                                    vertical: -2,
                                  ),
                                  horizontalTitleGap: 6,
                                  contentPadding: const EdgeInsets.all(0),
                                  leading: CircleAvatar(
                                    radius: 14,
                                    backgroundColor: secondaryColor,
                                    child: Text(
                                      "${index + 1}",
                                      style: const TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    widget.ingredients[index],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.urbanist(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const Divider(),

                            //! Recipe Instructions
                            const SizedBox(height: 8),
                            Text(
                              'Instructions:',
                              style: GoogleFonts.urbanist(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            //! Instructions List
                            ListView.builder(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: widget.instructions.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  horizontalTitleGap: 6,
                                  contentPadding: const EdgeInsets.all(0),
                                  leading: CircleAvatar(
                                    radius: 14,
                                    backgroundColor: secondaryColor,
                                    child: Text(
                                      "${index + 1}",
                                      style: const TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    widget.instructions[index],
                                    style: GoogleFonts.urbanist(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
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
