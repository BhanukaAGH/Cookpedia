import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String commentId;
  final String recipeId;
  final String comment;
  final String commentAuthorId;
  final String commentAuthorName;
  final String commentAuthorImage;
  Comment({
    required this.commentId,
    required this.recipeId,
    required this.comment,
    required this.commentAuthorId,
    required this.commentAuthorName,
    required this.commentAuthorImage,
  });
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'commentId': commentId,
      'recipeId': recipeId,
      'comment': comment,
      'commentAuthorId': commentAuthorId,
      'commentAuthorName': commentAuthorName,
      'commentAuthorImage': commentAuthorImage,
    };
  }

  static Comment fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Comment(
      commentId: snapshot['commentId'],
      recipeId: snapshot['recipeId'],
      comment: snapshot['comment'],
      commentAuthorId: snapshot['commentAuthorId'],
      commentAuthorName: snapshot['commentAuthorName'],
      commentAuthorImage: snapshot['commentAuthorImage'],
    );
  }
}
