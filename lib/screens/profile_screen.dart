import 'package:cookpedia/resources/auth_methods.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Profile Screen'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              AuthMethods().signOut();
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
