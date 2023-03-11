import 'package:flutter/material.dart';

class FollowersListView extends StatelessWidget {
  const FollowersListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey.shade400,
            backgroundImage: const NetworkImage(
              'https://images.unsplash.com/photo-1633332755192-727a05c4013d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8dXNlcnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60',
            ),
          ),
          title: Text('User $index'),
          subtitle: Text('User $index\'s bio'),
          trailing: ElevatedButton(
            onPressed: () {},
            child: const Text('Follow'),
          ),
        );
      },
    );
  }
}
