import 'package:cookpedia/models/user.dart';
import 'package:cookpedia/providers/user_provider.dart';
import 'package:cookpedia/resources/recipe_methods.dart';
import 'package:cookpedia/utils/colors.dart';
import 'package:cookpedia/utils/utils.dart';
import 'package:cookpedia/widgets/add_recipe/add_ingredients_input.dart';
import 'package:cookpedia/widgets/add_recipe/image_input.dart';
import 'package:cookpedia/widgets/add_recipe/recipe_dropdown.dart';
import 'package:cookpedia/widgets/add_recipe/recipe_text_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _basicFormKey = GlobalKey<FormState>();
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
  Uint8List? imageFile;
  String recipeCategory = 'All';
  bool isImageError = false;
  bool _isLoading = false;

  void _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              'Choose image source',
              textAlign: TextAlign.center,
              style: GoogleFonts.urbanist(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                  ),
                  label: const Text(
                    'Camera',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: null,
                  icon: const Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.white,
                  ),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    imageFile = file;
                  });
                },
              ),
              const SizedBox(height: 4),
              SimpleDialogOption(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                  ),
                  label: const Text(
                    'Gallery',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: null,
                  icon: const Icon(
                    Icons.collections_outlined,
                    color: Colors.white,
                  ),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    imageFile = file;
                  });
                },
              ),
            ],
          );
        });
  }

  void clearImage() {
    setState(() {
      imageFile = null;
    });
  }

  void createRecipe({required String userId}) async {
    // Validate form fields
    final isBasicFieldValid = _basicFormKey.currentState!.validate();
    if (ingredients.isEmpty) _ingredientsFormKey.currentState!.validate();
    if (instructions.isEmpty) _stepsFormKey.currentState!.validate();

    // Check if image is selected
    if (imageFile == null) {
      setState(() {
        isImageError = true;
      });
    } else {
      setState(() {
        isImageError = false;
      });
    }

    // Check if all fields are valid
    if (!isBasicFieldValid ||
        ingredients.isEmpty ||
        instructions.isEmpty ||
        imageFile == null) {
      return;
    }

    // Create recipe
    try {
      setState(() {
        _isLoading = true;
      });
      String res = await RecipeMethods().createRecipe(
        recipeTitle: _titleController.text,
        recipeCategory: recipeCategory,
        imageFile: imageFile!,
        recipeDescription: _descriptionController.text,
        recipeCookTime: _cookTimeController.text,
        recipeServes: int.parse(_servesController.text),
        recipeAuthorId: userId,
        ingredients: ingredients,
        instructions: instructions,
      );

      if (res == 'Success') {
        setState(() {
          _isLoading = false;
        });
        clearImage();

        Fluttertoast.showToast(
          msg: 'Recipe created successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          // textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        setState(() {
          _isLoading = false;
        });
        Fluttertoast.showToast(
          msg: res,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          // textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        // textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

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
    final User user = Provider.of<UserProvider>(context).getUser;

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
                    onPressed: () => createRecipe(userId: user.uid),
                    child: !_isLoading
                        ? Text(
                            'Publish',
                            style: GoogleFonts.urbanist(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        : const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ImageInput(
                        imageFile: imageFile,
                        selectImage: () => _selectImage(context),
                        isError: isImageError,
                      ),
                      const SizedBox(height: 20),
                      Form(
                        key: _basicFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                              textInputType: TextInputType.number,
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
                          ],
                        ),
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
