import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rec_rec_app/pages/components/my_drawer_tile.dart';
import 'package:rec_rec_app/pages/homepage/random_recipes.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // App logo
          const Padding(
            padding: EdgeInsets.only(top: 100.0),
            child: Icon(
              Icons.lock_open_rounded,
              size: 80,
            ),
          ),

          const Padding(
            padding: EdgeInsets.all(25.0),
            child: Divider(),
          ),

          // Icon

          // Home list tile
          MyDrawerTile(
              text: "Home",
              icon: Icons.home,
              onTap: () => Navigator.pop(context)),

          // Setting list tile
          MyDrawerTile(
            text: "History",
            icon: Icons.access_time_outlined,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ParallaxRecipe()),
            ),
          ),

          const Spacer(),

          // Logout list tile
          MyDrawerTile(
              text: "Log out", icon: Icons.logout, onTap: signUserOutDrawer),

          const SizedBox(
            height: 25,
          )
        ],
      ),
    );
  }

  void signUserOutDrawer() {
    FirebaseAuth.instance.signOut();
  }
}
