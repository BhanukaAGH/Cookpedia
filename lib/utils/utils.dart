import 'package:cookpedia/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: source);

  if (file != null) {
    return await file.readAsBytes();
  }
}

showSnackBar(String content, BuildContext context, Color? color) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
      backgroundColor: color,
    ),
  );
}

showAlertDialog({
  required BuildContext context,
  required String continueText,
  required String title,
  required String description,
  required VoidCallback continueFunc,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          title,
          style: GoogleFonts.urbanist(
            fontWeight: FontWeight.w600,
            color: primaryColor,
          ),
        ),
        titlePadding: const EdgeInsets.only(left: 20, top: 16),
        contentPadding: const EdgeInsets.only(left: 20, right: 20, top: 8),
        content: Text(
          description,
          style: GoogleFonts.urbanist(
            fontWeight: FontWeight.w600,
            color: Colors.black.withOpacity(0.6),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: GoogleFonts.urbanist(
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
          TextButton(
            onPressed: continueFunc,
            child: Text(
              continueText,
              style: GoogleFonts.urbanist(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ],
      );
    },
  );
}
