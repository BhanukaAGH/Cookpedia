import 'package:cookpedia/providers/user_provider.dart';
import 'package:cookpedia/resources/auth_methods.dart';
import 'package:cookpedia/utils/colors.dart';
import 'package:cookpedia/widgets/profile/counter_section.dart';
import 'package:cookpedia/widgets/profile/tabbar_section.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

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
                children: [
                  Image.asset(
                    './assets/recipe.png',
                    fit: BoxFit.cover,
                    width: 32,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Profile',
                    style: GoogleFonts.urbanist(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: primaryColor,
                    child: IconButton(
                      onPressed: () async {
                        await AuthMethods().signOut();
                      },
                      color: Colors.white,
                      icon: const Icon(Icons.power_settings_new),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ListTile(
                contentPadding: const EdgeInsets.all(0),
                leading: CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.grey.shade400,
                  backgroundImage: NetworkImage(
                    user.profileImg,
                  ),
                ),
                title: Text(
                  user.username,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.urbanist(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  user.email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.urbanist(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                trailing: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit'),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        color: primaryColor,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
              ),
              const Divider(indent: 8, endIndent: 8, height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CounterSection(title: 'Recipes', count: 125),
                  CounterSection(title: 'Following', count: 225),
                  CounterSection(title: 'Followers', count: 46),
                ],
              ),
              const Divider(indent: 8, endIndent: 8, height: 32),
              const TabBarSection(),
            ],
          ),
        ),
      ),
    );
  }
}
