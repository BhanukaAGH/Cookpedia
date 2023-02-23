import 'package:cookpedia/utils/colors.dart';
import 'package:cookpedia/widgets/view_recipe/recipe_specific_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewRecipe extends StatelessWidget {
  const ViewRecipe({super.key});

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
              child: Container(
                width: double.maxFinite,
                height: MediaQuery.of(context).size.height * 0.35,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1505576633757-0ac1084af824?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=735&q=80',
                    ),
                  ),
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
                      "Recipe Title",
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
                      leading: const CircleAvatar(
                        radius: 24,
                        backgroundImage: NetworkImage(
                          'https://images.unsplash.com/photo-1505576633757-0ac1084af824?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=735&q=80',
                        ),
                      ),
                      title: Text(
                        "Recipe Author",
                        style: GoogleFonts.urbanist(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        "posted 2 days ago",
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
                              'lorem ipsum dolor sit amet lorem ipsum lorem ipsum dolor sit amet lorem ipsum lorem ipsum dolor sit amet lorem ipsum lorem ipsum dolor sit amet lorem ipsum',
                              style: GoogleFonts.urbanist(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                RecipeSpecificCard(
                                  icon: Icons.schedule_rounded,
                                  label: '30 mins',
                                  subLabel: 'cook time',
                                ),
                                RecipeSpecificCard(
                                  icon: Icons.person_outline,
                                  label: '1 serving',
                                  subLabel: 'serves',
                                ),
                                RecipeSpecificCard(
                                  icon: Icons.food_bank_outlined,
                                  label: 'pizza',
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
                              itemCount: 4,
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
                                    'Item ${index + 1}',
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
                              itemCount: 6,
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
                                    'Instructions ${index + 1}',
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
