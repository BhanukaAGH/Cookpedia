import 'package:cookpedia/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({super.key});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const SearchScreen(),
        ),
      ),
      minVerticalPadding: 0,
      minLeadingWidth: 0,
      horizontalTitleGap: 8,
      visualDensity: const VisualDensity(vertical: -2),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
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
          _searchController.clear();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SearchScreen(searchQuery: value),
            ),
          );
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
    );
  }
}
