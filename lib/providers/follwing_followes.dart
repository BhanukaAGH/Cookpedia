import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookpedia/models/user.dart';
import 'package:flutter/cupertino.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class FollowingFollowersMethods with ChangeNotifier {
  bool isFollowed = false;
  List<User> followingList = [];
  Map<String, int> userInfo = {};

  void changeFollowing() {
    isFollowed = !isFollowed;
  }

  bool get isFollowedCheck {
    return isFollowed;
  }

  Map<String, int> get countValues {
    return userInfo;
  }

  List<User> get list {
    return followingList;
  }

  Future<void> following(String userId, String followerId) async {
    List<dynamic> following = await getFollowingList(userId, 'following');
    if (following.contains(followerId)) {
      following.remove(followerId);
    } else {
      following.add(followerId);
    }
    await _firestore
        .collection('users')
        .doc(userId)
        .update({'following': following});
    followers(userId, followerId);
  }

  Future<void> followers(String userId, String followerId) async {
    List<dynamic> followers = await getFollowingList(followerId, 'followers');
    if (followers.contains(userId)) {
      followers.remove(userId);
    } else {
      followers.add(userId);
    }
    await _firestore
        .collection('users')
        .doc(followerId)
        .update({'followers': followers});
  }

  Future<void> checkFollowed(String userId, String recipeId) async {
    final res = await _firestore.collection('recipes').doc(recipeId).get();
    List<dynamic> following = await getFollowingList(userId, 'following');
    if (following.contains(res.data()!['recipeAuthorId'])) {
      isFollowed = true;
    }
  }

  Future<List<dynamic>> getFollowingList(String userId, String type) async {
    final user = await _firestore.collection('users').doc(userId).get();
    List<dynamic> following = user.data()![type];
    return following;
  }

  Future<void> getUserInformation(String userId) async {
    final user = await _firestore.collection('users').doc(userId).get();
    final recipe = await _firestore
        .collection('recipes')
        .where('recipeAuthorId', isEqualTo: userId)
        .get();
    userInfo['recipeCount'] = recipe.docs.length;
    List<dynamic> following = user.data()!['following'];
    if (following.isEmpty) {
      userInfo['following'] = 0;
    } else {
      userInfo['following'] = following.length;
    }
    List<dynamic> followers = user.data()!['followers'];
    if (followers.isEmpty) {
      userInfo['followers'] = 0;
    } else {
      userInfo['followers'] = following.length;
    }
    notifyListeners();
  }
}
