import 'package:cookpedia/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddIngredientInput extends StatelessWidget {
  final Key formKey;
  final TextEditingController textEditingController;
  final String label;
  final String hintText;
  final TextInputType textInputType;
  final List<String> items;
  final VoidCallback addFunction;
  final Function(int) deleteItem;

  const AddIngredientInput({
    super.key,
    required this.formKey,
    required this.textEditingController,
    required this.label,
    required this.hintText,
    required this.textInputType,
    required this.items,
    required this.addFunction,
    required this.deleteItem,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
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
          ListView.builder(
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];

              return ListTile(
                contentPadding: const EdgeInsets.all(0),
                leading: CircleAvatar(
                  radius: 16,
                  backgroundColor: secondaryColor,
                  child: Text(
                    "${index + 1}",
                    style: const TextStyle(color: primaryColor),
                  ),
                ),
                title: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    item,
                    style: GoogleFonts.urbanist(fontWeight: FontWeight.bold),
                  ),
                ),
                trailing: IconButton(
                  onPressed: () => deleteItem(index),
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: primaryColor,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: TextFormField(
                  style: GoogleFonts.urbanist(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  controller: textEditingController,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: GoogleFonts.urbanist(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade500),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(12),
                    ),
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
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter value';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(52, 44),
                  maximumSize: const Size(52, 44),
                  padding: const EdgeInsets.all(0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: addFunction,
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
