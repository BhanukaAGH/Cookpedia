import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookpedia/models/comment.dart';
import 'package:uuid/uuid.dart';

class CommentMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //! Add Comment
  Future<String> addComment({
    required String recipeId,
    required String comment,
    required String commentAuthorId,
    required String commentAuthorName,
    required String commentAuthorImage,
  }) async {
    String res = 'some error occured';
    try {
      String commentId = const Uuid().v1();

      Comment newComment = Comment(
        commentId: commentId,
        recipeId: recipeId,
        comment: comment,
        commentAuthorId: commentAuthorId,
        commentAuthorName: commentAuthorName,
        commentAuthorImage: commentAuthorImage,
      );

      _firestore.collection('comments').doc(commentId).set(newComment.toJson());
      res = 'Success';
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

  //! Delete Comment
  Future<void> deleteComment(String commentId) async {
    try {
      await _firestore.collection('comments').doc(commentId).delete();
    } catch (error) {
      // ignore: avoid_print
      print(error.toString());
    }
  }
}
