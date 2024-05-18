import 'package:flutter/material.dart';
import 'random_recipes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  var currentPageID = 0; // default to WelcomePage upon launch

  @override
  Widget build(BuildContext context) {
    Widget page;

    switch (currentPageID) {
      case 0:
        page = WelcomePage();
      default:
        throw UnimplementedError('no widget for $currentPageID');
    }

    return SafeArea(
      child: LayoutBuilder(builder: (context, constraints) {
        return Scaffold(
          body: Column(
            children: [
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              const Text('Welcome'),
              IconButton(
                  onPressed: () {
                    print('history');
                  },
                  icon: const Icon(
                      IconData(0xee2d, fontFamily: 'MaterialIcons'))),
            ],
          ),
        ],
      ),
    );
  }
}
