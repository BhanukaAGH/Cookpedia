import 'package:cookpedia/providers/user_provider.dart';
import 'package:cookpedia/utils/colors.dart';
import 'package:cookpedia/utils/global_variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    addData();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  addData() async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    await userProvider.refreshUser();
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
        children: mainScreens,
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: CupertinoTabBar(
          border: null,
          activeColor: primaryColor,
          inactiveColor: Colors.black38,
          currentIndex: _page,
          backgroundColor: Colors.white,
          items: [
            const BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(Icons.home),
            ),
            const BottomNavigationBarItem(
              label: 'My Recipes',
              icon: Icon(Icons.description_outlined),
            ),
            BottomNavigationBarItem(
              icon: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      color: primaryColor,
                      spreadRadius: 1,
                    )
                  ],
                ),
                child: const CircleAvatar(
                  backgroundColor: primaryColor,
                  radius: 24,
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const BottomNavigationBarItem(
              label: 'Favorites',
              icon: Icon(Icons.favorite),
            ),
            const BottomNavigationBarItem(
              label: 'Profile',
              icon: Icon(Icons.perm_identity),
            ),
          ],
          onTap: navigationTapped,
        ),
      ),
    );
  }
}
