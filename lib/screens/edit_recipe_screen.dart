import 'package:cookpedia/models/user.dart';
import 'package:cookpedia/providers/user_provider.dart';
import 'package:cookpedia/utils/colors.dart';
import 'package:cookpedia/utils/utils.dart';
import 'package:cookpedia/widgets/add_recipe/add_ingredients_input.dart';
import 'package:cookpedia/widgets/add_recipe/image_input.dart';
import 'package:cookpedia/widgets/add_recipe/recipe_dropdown.dart';
import 'package:cookpedia/widgets/add_recipe/recipe_text_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class EditRecipeScreen extends StatefulWidget {
  final Map<String, dynamic> recipe;

  const EditRecipeScreen({super.key, required this.recipe});

  @override
  State<EditRecipeScreen> createState() => _EditRecipeScreenState();
}

class _EditRecipeScreenState extends State<EditRecipeScreen> {
  final _basicFormKey = GlobalKey<FormState>();
  final _ingredientsFormKey = GlobalKey<FormState>();
  final _stepsFormKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _cookTimeController = TextEditingController();
  final TextEditingController _servesController = TextEditingController();
  final TextEditingController _ingredientController = TextEditingController();
  final TextEditingController _instructionController = TextEditingController();
  late List<String> ingredients = [];
  late List<String> instructions = [];
  Uint8List? imageFile;
  String recipeCategory = 'All';
  bool isImageError = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setInitialImage());
    _titleController.text = widget.recipe['recipeTitle'];
    _descriptionController.text = widget.recipe['recipeDescription'];
    _cookTimeController.text = widget.recipe['recipeCookTime'];
    _servesController.text = widget.recipe['recipeServes'].toString();
    recipeCategory = widget.recipe['recipeCategory'];
    ingredients = (widget.recipe['ingredients'] as List)
        .map((item) => item as String)
        .toList();
    instructions = (widget.recipe['instructions'] as List)
        .map((item) => item as String)
        .toList();
  }

  setInitialImage() async {
    http.Response response =
        await http.get(Uri.parse(widget.recipe['recipeImage']));
    setState(() {
      imageFile = response.bodyBytes;
    });
  }

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

  void editRecipe() async {}

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

    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
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
                  children: [
                    FloatingActionButton.small(
                      heroTag: "backbtn",
                      onPressed: () => Navigator.of(context).pop(),
                      backgroundColor: Colors.grey.shade400,
                      child: const Icon(Icons.arrow_back),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Edit Recipe',
                      style: GoogleFonts.urbanist(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onPressed: () => editRecipe(),
                      child: !_isLoading
                          ? Text(
                              'Save',
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
      ),
    );
  }
}
