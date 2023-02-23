import 'package:cookpedia/utils/colors.dart';
import 'package:cookpedia/widgets/add_recipe/add_ingredients_input.dart';
import 'package:cookpedia/widgets/add_recipe/image_input.dart';
import 'package:cookpedia/widgets/add_recipe/recipe_dropdown.dart';
import 'package:cookpedia/widgets/add_recipe/recipe_text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _ingredientsFormKey = GlobalKey<FormState>();
  final _stepsFormKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _cookTimeController = TextEditingController();
  final TextEditingController _servesController = TextEditingController();
  final TextEditingController _ingredientController = TextEditingController();
  final TextEditingController _instructionController = TextEditingController();
  final List<String> ingredients = [];
  final List<String> instructions = [];
  String recipeCategory = 'All';

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _cookTimeController.dispose();
    _servesController.dispose();
    _ingredientController.dispose();
    _instructionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Create Recipe',
                    style: GoogleFonts.urbanist(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      'Publish',
                      style: GoogleFonts.urbanist(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ImageInput(),
                      const SizedBox(height: 20),
                      RecipeTextField(
                        textEditingController: _titleController,
                        label: 'Title',
                        hintText: 'Recipe Title',
                        textInputType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 20),
                      RecipeTextField(
                        textEditingController: _descriptionController,
                        label: 'Description',
                        hintText: 'Write Recipe Description ...',
                        textInputType: TextInputType.multiline,
                        textInputAction: TextInputAction.next,
                        maxLines: 5,
                      ),
                      const SizedBox(height: 20),
                      RecipeTextField(
                        textEditingController: _cookTimeController,
                        label: 'Cook Time',
                        hintText: '1 hour 30 mins etc',
                        textInputType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 20),
                      RecipeTextField(
                        textEditingController: _servesController,
                        label: 'Serves',
                        hintText: '3 people',
                        textInputType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 20),
                      RecipeDropDown(
                        label: "Category",
                        hintText: "category",
                        selectValue: recipeCategory,
                        onChanged: (String? value) {
                          setState(() {
                            recipeCategory = value!;
                          });
                        },
                      ),

                      // Add Ingredients section
                      const Divider(height: 36),
                      AddIngredientInput(
                        formKey: _ingredientsFormKey,
                        label: "Ingredients:",
                        hintText: "Ingredient",
                        items: ingredients,
                        textEditingController: _ingredientController,
                        textInputType: TextInputType.text,
                        addFunction: () {
                          if (_ingredientsFormKey.currentState!.validate()) {
                            setState(() {
                              ingredients.add(_ingredientController.text);
                              _ingredientController.clear();
                            });
                          }
                        },
                        deleteItem: (index) => {
                          setState(() {
                            ingredients.removeAt(index);
                          })
                        },
                      ),

                      // Add Steps to Prepare Meal
                      const Divider(height: 36),
                      AddIngredientInput(
                        formKey: _stepsFormKey,
                        label: "Instructions:",
                        hintText: "Instruction to prepare meal",
                        items: instructions,
                        textEditingController: _instructionController,
                        textInputType: TextInputType.text,
                        addFunction: () {
                          if (_stepsFormKey.currentState!.validate()) {
                            setState(() {
                              instructions.add(_instructionController.text);
                              _instructionController.clear();
                            });
                          }
                        },
                        deleteItem: (index) => {
                          setState(() {
                            instructions.removeAt(index);
                          })
                        },
                      ),
                      const SizedBox(height: 28),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
