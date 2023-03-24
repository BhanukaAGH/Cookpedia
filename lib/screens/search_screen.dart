import 'dart:async';

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
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    if (widget.searchQuery != null) {
      _searchController.text = widget.searchQuery!;
    }
  }

  _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
    _debounce?.cancel();
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
                          onChanged: _onSearchChanged,
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
                  future:
                      FirebaseFirestore.instance.collection('recipes').get(),
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

                    final List<QueryDocumentSnapshot> filteredRecipes =
                        (snapshot.data! as dynamic)
                            .docs
                            .where((recipe) => (recipe['recipeTitle']
                                .toString()
                                .toLowerCase()
                                .contains(
                                    _searchController.text.toLowerCase())))
                            .toList();

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredRecipes.length,
                      itemBuilder: (context, index) {
                        final recipe = filteredRecipes[index];

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
