import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookpedia/resources/comment_methods.dart';
import 'package:cookpedia/utils/colors.dart';
import 'package:cookpedia/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cookpedia/providers/user_provider.dart';

class CommentScreen extends StatefulWidget {
  final String recipeId;
  final String commentAuthorId;
  final String commentAuthorName;
  final String commentAuthorImage;
  const CommentScreen({
    super.key,
    required this.recipeId,
    required this.commentAuthorId,
    required this.commentAuthorName,
    required this.commentAuthorImage,
  });
  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentController = TextEditingController();
  createComment() async {
    if (_commentController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Comment is empty');
      return;
    }
    await CommentMethods().addComment(
      recipeId: widget.recipeId,
      comment: _commentController.text,
      commentAuthorId: widget.commentAuthorId,
      commentAuthorName: widget.commentAuthorName,
      commentAuthorImage: widget.commentAuthorImage,
    );
    _commentController.clear();
    Fluttertoast.showToast(msg: 'Comment added');
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  FloatingActionButton.small(
                    onPressed: () => Navigator.of(context).pop(),
                    backgroundColor: Colors.grey.shade400,
                    child: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Comments',
                    style: GoogleFonts.urbanist(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('comments')
                      .where('recipeId', isEqualTo: widget.recipeId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.data!.docs.isEmpty) {
                      return Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            'No comments yet. Be the first to comment!',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.urbanist(
                              color: Colors.black54,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }
                    final comments = snapshot.data!.docs;
                    return Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          final comment = comments[index].data();
                          return Column(
                            children: [
                              ListTile(
                                minLeadingWidth: 12,
                                leading: CircleAvatar(
                                  radius: 16,
                                  backgroundImage: NetworkImage(
                                      comment['commentAuthorImage']),
                                ),
                                title: Text(
                                  comment['commentAuthorName'],
                                  style: GoogleFonts.urbanist(
                                    color: Colors.black54,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                isThreeLine: true,
                                subtitle: Text(
                                  comment['comment'],
                                  style: GoogleFonts.urbanist(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                trailing: user.uid == comment['commentAuthorId']
                                    ? IconButton(
                                        onPressed: () => {
                                          showAlertDialog(
                                            context: context,
                                            title: 'Delete Comment',
                                            description:
                                                'Are you sure you want to delete this comment?',
                                            continueText: 'Delete',
                                            continueFunc: () {
                                              CommentMethods().deleteComment(
                                                  comment['commentId']);
                                              Navigator.of(context).pop();
                                              Fluttertoast.showToast(
                                                  msg: 'Comment deleted');
                                            },
                                          ),
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          size: 20,
                                          color: primaryColor,
                                        ),
                                      )
                                    : null,
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  }),
              TextFormField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: 'Write a comment...',
                  hintStyle: GoogleFonts.urbanist(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  contentPadding: const EdgeInsets.all(16),
                ),
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (value) => createComment(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
