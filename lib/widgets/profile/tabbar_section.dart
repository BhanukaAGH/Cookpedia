import 'package:cookpedia/providers/user_provider.dart';
import 'package:cookpedia/utils/colors.dart';
import 'package:cookpedia/widgets/profile/followers_listview.dart';
import 'package:cookpedia/widgets/profile/image_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TabBarSection extends StatefulWidget {
  const TabBarSection({super.key});

  @override
  State<TabBarSection> createState() => _TabBarSectionState();
}

class _TabBarSectionState extends State<TabBarSection> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).getUser;
    return DefaultTabController(
      length: 2,
      child: Flexible(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const TabBar(
              indicatorColor: primaryColor,
              labelColor: primaryColor,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(
                  icon: Icon(Icons.grid_on_rounded),
                  iconMargin: EdgeInsets.only(bottom: 0),
                ),
                Tab(
                  icon: Icon(Icons.people_alt_outlined),
                  iconMargin: EdgeInsets.only(bottom: 0),
                ),
              ],
            ),
            Flexible(
              child: TabBarView(
                children: [
                  const ImageGrid(),
                  FollowersListView(
                    userId: user.uid,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
