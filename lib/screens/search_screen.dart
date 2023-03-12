import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookpedia/screens/view_recipe_screen.dart';
import 'package:cookpedia/widgets/home/recipe_listtile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchScreen extends StatefulWidget {
  final String? searchQuery;
  const SearchScreen({super.key, this.searchQuery});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.searchQuery != null) {
      _searchController.text = widget.searchQuery!;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    FloatingActionButton.small(
                      heroTag: "searchbtn",
                      onPressed: () => Navigator.of(context).pop(),
                      backgroundColor: Colors.grey.shade400,
                      child: const Icon(Icons.arrow_back),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: ListTile(
                        minVerticalPadding: 0,
                        minLeadingWidth: 0,
                        horizontalTitleGap: 8,
                        visualDensity: const VisualDensity(vertical: -2),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
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
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('recipes')
                      .where('recipeTitle',
                          isGreaterThanOrEqualTo: _searchController.text)
                      .get(),
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

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      itemBuilder: (context, index) {
                        final recipe = (snapshot.data! as dynamic).docs[index];

                        return RecipeListTile(
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
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
