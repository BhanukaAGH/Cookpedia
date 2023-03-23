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
      if (err.toString().contains('[firebase_auth/email-already-in-use]')) {
        res = "This email is already taken";
      } else if (err.toString().contains('[firebase_auth/weak-password]')) {
        res = " Password should be at least 6 characters long";
      } else {
        res = "Could not authenticate you. Please try aging letter!";
      }
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
      print(err);
      if (err.toString().contains('[firebase_auth/user-not-found]')) {
        res = "Credential invalid or The user may have been deleted";
      } else if (err.toString().contains('[firebase_auth/wrong-password]')) {
        res = "This is not a valid password";
      } else if (err.toString().contains('EMAIL_EXISTS')) {
        res = 'This email is already taken';
      } else {
        res = "Could not authenticate you. Please try aging letter!";
      }
      // res = err.toString();
      print(res);
    }

    return res;
  }

  //Update User
  Future<String> updateUser({
    required String uid,
    required String name,
    required String photoUrl,
    required String email,
  }) async {
    String res = 'some error occured';
    try {
      if (_auth.currentUser!.email != email) {
        await _auth.currentUser!.updateEmail(email);
      }

      model.User user = model.User(
          uid: uid,
          username: name,
          email: email,
          profileImg: photoUrl,
          followers: [],
          following: []);

      _firestore.collection('users').doc(uid).update(user.toJson());

      res = 'success';
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

  //Delete User account
  Future<void> deleteAccount() async {
    try {
      await _auth.currentUser!.delete();
      await _auth.signOut();
    } catch (err) {
      print(err);
    }
  }
}
