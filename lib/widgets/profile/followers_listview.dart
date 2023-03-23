import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookpedia/models/user.dart';
import 'package:cookpedia/providers/follwing_followes.dart';
import 'package:cookpedia/providers/user_provider.dart';
import 'package:cookpedia/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FollowersListView extends StatefulWidget {
  final String userId;
  const FollowersListView({required this.userId, super.key});

  @override
  State<FollowersListView> createState() => _FollowersListViewState();
}

class _FollowersListViewState extends State<FollowersListView> {
  bool _isLoading = false;

  @override
  void initState() {
    getFollwingList();
    super.initState();
  }

  List<User> listOfFollowing = [];
  void getFollwingList() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final user = await firestore.collection('users').doc(widget.userId).get();
      List<dynamic> following = user.data()!['following'];
      await firestore
          .collection('users')
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          if (following.contains(doc['uid'])) {
            listOfFollowing.add(User(
                uid: doc['uid'],
                email: doc['email'],
                username: doc['username'],
                profileImg: doc['profileImg'],
                followers: doc['followers'],
                following: doc['following']));
          }
        }
      });
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void removeUser(int index) {
    setState(() {
      listOfFollowing.removeAt(index);
    });
  }

  bool checkIsFollowing(int index, String userId) {
    return listOfFollowing[index].followers.contains(userId);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).getUser;
    final followMethods = Provider.of<FollowingFollowersMethods>(context);

    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(
              color: primaryColor,
            ),
          )
        : ListView.builder(
            itemCount: listOfFollowing.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                    backgroundColor: Colors.grey.shade400,
                    backgroundImage:
                        NetworkImage(listOfFollowing[index].profileImg)),
                title: Text(listOfFollowing[index].username),
                subtitle: Text(listOfFollowing[index].email),
                trailing: ElevatedButton(
                  onPressed: () {
                    FollowingFollowersMethods()
                        .following(user.uid, listOfFollowing[index].uid);
                    removeUser(index);
                    followMethods.getUserInformation(user.uid);
                  },
                  child: checkIsFollowing(index, user.uid)
                      ? const Text('Unfollow')
                      : const Text('Follow'),
                ),
              );
            },
          );
  }
}
