import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookpedia/resources/storage_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cookpedia/models/user.dart' as model;
import 'package:flutter/foundation.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }

  //! SignUp User
  Future<String> signUpUser({
    required String username,
    required String email,
    required String password,
    required Uint8List? image,
  }) async {
    String res = "Some error occured";

    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          image != null) {
        // register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String profileImgUrl = await StorageMethods().uploadImageToStorage(
          'profileImages',
          image!,
          false,
          null,
        );

        // add user to our database
        model.User user = model.User(
          uid: cred.user!.uid,
          username: username,
          email: email,
          profileImg: profileImgUrl,
          followers: [],
          following: [],
        );

        await _firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());
        res = 'success';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //! Login User
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occured";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = 'success';
      } else {
        res = 'Please enter all the fields.';
      }
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  //! SignOut User
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (err) {
      if (kDebugMode) {
        print(err.toString());
      }
    }
  }
}
