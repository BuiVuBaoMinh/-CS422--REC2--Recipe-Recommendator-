import 'package:flutter/material.dart';
import 'package:rec_rec_app/pages/homepage/edit_recipe_page.dart';

class MySilverAppBar extends StatelessWidget {
  final Widget child;
  final Widget title;

  const MySilverAppBar({super.key, required this.child, required this.title});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 280,
      collapsedHeight: 80,
      floating: false,
      pinned: true,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const EditRecipePage()));
          },
          icon: const Icon(Icons.add),
        )
      ],
      title: const Text("Home"),
      centerTitle: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: const EdgeInsets.only(bottom: 50.0),
          child: child,
        ),
        title: title,
        centerTitle: true,
        expandedTitleScale: 1,
        titlePadding: const EdgeInsets.only(left: 0, right: 0, top: 0),
      ),
    );
  }
}
