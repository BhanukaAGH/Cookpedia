import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> likeRecipe(String recipeId, String userId, List likes) async {
    try {
      if (likes.contains(userId)) {
        await _firestore.collection('recipes').doc(recipeId).update({
          'likes': FieldValue.arrayRemove([userId]),
        });
      } else {
        await _firestore.collection('recipes').doc(recipeId).update({
          'likes': FieldValue.arrayUnion([userId]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
