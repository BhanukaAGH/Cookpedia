import 'dart:typed_data';

import 'package:cookpedia/resources/auth_methods.dart';
import 'package:cookpedia/screens/root_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../resources/storage_methods.dart';
import '../utils/colors.dart';
import '../utils/utils.dart';

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
            uid: uid, name: userName, photoUrl: profileImg, email: email);

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
        if (imageUrl.length != 0) {
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FloatingActionButton.small(
                onPressed: () => {
                  Navigator.of(context).pop(),
                },
                backgroundColor: Colors.grey.shade400,
                child: const Icon(Icons.arrow_back),
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
                    height: 50,
                  ),
                  buildTextFelid(
                      'Full Name', user.username, _userNameController),
                  buildTextFelid(
                      'Your Email Address', user.email, _emailController),
                  const SizedBox(
                    height: 30,
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
