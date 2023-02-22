import 'package:cookpedia/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecipeTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String label;
  final String hintText;
  final TextInputType textInputType;
  final TextInputAction? textInputAction;
  final int maxLines;

  const RecipeTextField(
      {super.key,
      required this.textEditingController,
      required this.label,
      required this.hintText,
      required this.textInputType,
      this.textInputAction,
      this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade200),
      borderRadius: BorderRadius.circular(12),
    );

    return Column(
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
        TextFormField(
          style: GoogleFonts.urbanist(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          controller: textEditingController,
          maxLines: maxLines,
          cursorColor: Colors.black,
          decoration: InputDecoration(
            hintText: hintText,
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
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
          ),
          keyboardType: textInputType,
          textInputAction: textInputAction,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter value';
            }

            return null;
          },
        ),
      ],
    );
  }
}
