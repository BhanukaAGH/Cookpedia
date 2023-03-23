// ignore_for_file: use_build_context_synchronously
import 'dart:typed_data';

import 'package:cookpedia/providers/user_provider.dart';
import 'package:cookpedia/resources/auth_methods.dart';
import 'package:cookpedia/resources/storage_methods.dart';
import 'package:cookpedia/screens/login_screen.dart';
import 'package:cookpedia/screens/root_screen.dart';
import 'package:cookpedia/utils/colors.dart';
import 'package:cookpedia/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileEdit extends StatefulWidget {
  const ProfileEdit({super.key});

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final myController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  Uint8List? _image;
  bool isLoading = false;
  bool isAccountDelete = false;
  void updateProfileImage() async {
    Uint8List image = await pickImage(ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  update(String uid, String userName, String email, String profileImg,
      BuildContext context) async {
    String nameInputValue = _userNameController.text;
    String emailInputValue = _emailController.text;

    userName = nameInputValue.isEmpty ? userName : nameInputValue;
    email = emailInputValue.isEmpty ? email : emailInputValue;

    if ((_image == null) & nameInputValue.isEmpty & emailInputValue.isEmpty) {
      showSnackBar("Please update at least on felid", context, redIconColor);
    }
    setState(() {
      isLoading = true;
    });
    try {
      if (_image == null) {
        String res = await AuthMethods().updateUser(
          uid: uid,
          name: userName,
          photoUrl: profileImg,
          email: email,
        );

        if (res == 'success') {
          showSnackBar('Updated!', context, null);
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const RootScreen()),
          );
        } else {
          showSnackBar('error', context, redIconColor);
        }
        setState(() {
          isLoading = false;
        });
      } else {
        String imageUrl = await StorageMethods()
            .uploadImageToStorage('profileImages', _image!, false, null);
        if (imageUrl.isNotEmpty) {
          String res = await AuthMethods().updateUser(
              uid: FirebaseAuth.instance.currentUser!.uid,
              name: userName,
              photoUrl: imageUrl,
              email: email);

          if (res == 'success') {
            showSnackBar('Updated!', context, null);
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const RootScreen()),
            );
          } else {
            showSnackBar('error', context, redIconColor);
          }
        }
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      showSnackBar(e as String, context, redIconColor);
    }
    setState(() {
      isLoading = false;
    });
  }

  void deletDialogBox(BuildContext context) {
    showAlertDialog(
        context: context,
        continueText: 'delete',
        title: 'Account Delete',
        description: 'Are you sure do you want to delete this account ?',
        continueFunc: () => accountdelete(context));
  }

  void accountdelete(BuildContext context) async {
    try {
      setState(() {
        isAccountDelete = true;
      });
      await AuthMethods().deleteAccount();
      setState(() {
        isAccountDelete = false;
      });
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
      showSnackBar('Account Deleted Succssfully', context, null);
    } catch (e) {
      setState(() {
        isAccountDelete = false;
      });
      showSnackBar('error happen!', context, redIconColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).getUser;
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FloatingActionButton.small(
                      onPressed: () => {
                        Navigator.of(context).pop(),
                      },
                      backgroundColor: Colors.grey.shade400,
                      child: const Icon(Icons.arrow_back),
                    ),
                    isAccountDelete
                        ? const CircularProgressIndicator()
                        : OutlinedButton(
                            onPressed: () => {deletDialogBox(context)},
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.all(15),
                              disabledForegroundColor:
                                  Colors.red.withOpacity(0.38),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                            ),
                            child: Text(
                              'Delete Your Account',
                              style: GoogleFonts.urbanist(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ))
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                ListView(
                  shrinkWrap: true,
                  children: [
                    Center(
                      child: Stack(children: [
                        Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                              border: Border.all(width: 4, color: Colors.white),
                              boxShadow: [
                                BoxShadow(
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    color: Colors.black.withOpacity(0.1))
                              ],
                              shape: BoxShape.circle,
                              image: _image != null
                                  ? DecorationImage(
                                      fit: BoxFit.cover,
                                      image: MemoryImage(_image!))
                                  : DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(user.profileImg))),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(width: 4, color: primaryColor)),
                            child: IconButton(
                              icon: const Icon(Icons.edit),
                              color: primaryColor,
                              onPressed: () {
                                updateProfileImage();
                              },
                            ),
                          ),
                        )
                      ]),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    buildTextFelid(
                        'Full Name', user.username, _userNameController),
                    buildTextFelid(
                        'Your Email Address', user.email, _emailController),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: () => update(user.uid, user.username,
                            user.email, user.profileImg, context),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          backgroundColor: primaryColor,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                        ),
                        child: isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'Update Your Profile',
                                style: GoogleFonts.urbanist(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ))
                  ],
                )
              ],
            ),
          ),
        )),
      ),
    );
  }
}

Widget buildTextFelid(
    String label, String placeholder, TextEditingController myController) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 30),
    child: TextField(
      controller: myController,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(bottom: 5),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
          ),
          labelText: label,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: placeholder,
          hintStyle: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
    ),
  );
}
