import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookpedia/providers/user_provider.dart';
import 'package:cookpedia/resources/favorite_methods.dart';
import 'package:cookpedia/providers/follwing_followes.dart';
import 'package:cookpedia/utils/colors.dart';
import 'package:cookpedia/widgets/view_recipe/recipe_specific_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'comment_screen.dart';

class ViewRecipe extends StatefulWidget {
  final String recipeId;
  const ViewRecipe({super.key, required this.recipeId});

  @override
  State<ViewRecipe> createState() => _ViewRecipeState();
}

class _ViewRecipeState extends State<ViewRecipe> {
  late final String recipeTitle;
  late final String recipeAuthorId;
  late final String recipeImage;
  late final String recipeDescription;
  late final String recipeCookTime;
  late final int recipeServes;
  late final String recipeCategory;
  late final List ingredients;
  late final List instructions;
  late final DateTime recipePublished;
  late final List likes;
  String recipeAuthorName = "";
  String recipeAuthorImage = "";
  bool isFollowing = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getRecipeDetails();
  }

  void getRecipeDetails() async {
    setState(() {
      isLoading = true;
    });
    await FirebaseFirestore.instance
        .collection('recipes')
        .doc(widget.recipeId)
        .get()
        .then((value) => {
              setState(() {
                recipeTitle = value['recipeTitle'];
                recipeAuthorId = value['recipeAuthorId'];
                recipeImage = value['recipeImage'];
                recipeDescription = value['recipeDescription'];
                recipeCookTime = value['recipeCookTime'];
                recipeServes = value['recipeServes'];
                recipeCategory = value['recipeCategory'];
                ingredients = value['ingredients'];
                instructions = value['instructions'];
                recipePublished = value['recipePublished'].toDate();
                likes = value['likes'];
              })
            });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(recipeAuthorId)
        .get()
        .then((value) => {
              setState(() {
                recipeAuthorName = value['username'];
                recipeAuthorImage = value['profileImg'];
                isFollowing = value['followers'].contains(
                    Provider.of<UserProvider>(context, listen: false)
                        .getUser
                        .uid);
              })
            });

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).getUser;

    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Stack(
                children: [
                  //! Recipe Image
                  Positioned(
                    left: 0,
                    right: 0,
                    child: SizedBox(
                      width: double.maxFinite,
                      height: MediaQuery.of(context).size.height * 0.35,
                      child: Image.network(
                        recipeImage,
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
                          onPressed: () async {
                            await FavoriteMethods().likeRecipe(
                              widget.recipeId,
                              user.uid,
                              likes,
                            );
                            setState(() {
                              likes.contains(user.uid)
                                  ? likes.remove(user.uid)
                                  : likes.add(user.uid);
                            });
                          },
                          backgroundColor: primaryColor,
                          child: Icon(
                            likes.contains(user.uid)
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                          ),
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
                            recipeTitle,
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
                              'posted ${timeago.format(recipePublished)}',
                              style: GoogleFonts.urbanist(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: ElevatedButton(
                                onPressed: () {
                                  FollowingFollowersMethods()
                                      .following(user.uid, recipeAuthorId);
                                  setState(() {
                                    isFollowing = !isFollowing;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  backgroundColor: primaryColor,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  isFollowing ? 'UnFollow' : 'Follow',
                                  style: GoogleFonts.urbanist(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                          ),
                          const Divider(),
                          Flexible(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 8),
                                  Text(
                                    recipeDescription,
                                    style: GoogleFonts.urbanist(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      RecipeSpecificCard(
                                        icon: Icons.schedule_rounded,
                                        label: recipeCookTime,
                                        subLabel: 'cook time',
                                      ),
                                      RecipeSpecificCard(
                                        icon: Icons.person_outline,
                                        label: '$recipeServes serving',
                                        subLabel: 'serves',
                                      ),
                                      RecipeSpecificCard(
                                        icon: Icons.food_bank_outlined,
                                        label: recipeCategory,
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
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: ingredients.length,
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
                                          ingredients[index],
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
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: instructions.length,
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
                                          instructions[index],
                                          style: GoogleFonts.urbanist(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      );
                                    },
                                  ),

                                  const SizedBox(height: 8),
                                  ElevatedButton(
                                    onPressed: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => CommentScreen(
                                          recipeId: widget.recipeId,
                                          commentAuthorId: user.uid,
                                          commentAuthorName: user.username,
                                          commentAuthorImage: user.profileImg,
                                        ),
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(32),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Comments',
                                          style: GoogleFonts.urbanist(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        const Icon(Icons.arrow_right_alt),
                                      ],
                                    ),
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
