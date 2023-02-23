import 'package:cookpedia/utils/colors.dart';
import 'package:cookpedia/utils/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecipeDropDown extends StatelessWidget {
  final String label;
  final String hintText;
  final String selectValue;
  final Function(String?) onChanged;

  const RecipeDropDown({
    super.key,
    required this.label,
    required this.hintText,
    required this.selectValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade200),
      borderRadius: BorderRadius.circular(12),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.urbanist(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButtonFormField(
                value: selectValue == 'All' ? null : selectValue,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(right: 12),
                  hintText: '   $hintText',
                  hintStyle: GoogleFonts.urbanist(
                      fontWeight: FontWeight.w500, color: Colors.grey.shade500),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  focusedBorder: inputBorder,
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: primaryColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: recipeCategories
                    .map(
                      (e) => DropdownMenuItem<String>(
                        value: e,
                        child: Text(
                          e,
                          style: GoogleFonts.urbanist(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: onChanged,
                validator: (value) {
                  if (value == null) {
                    return 'Please enter a $hintText.';
                  }
                  return null;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
