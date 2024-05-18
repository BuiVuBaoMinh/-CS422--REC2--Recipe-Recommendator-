import 'package:flutter/material.dart';

class ParallaxRecipe extends StatelessWidget {
  const ParallaxRecipe({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            for (final recipe in recipes)
              RecipeListItem(
                imageUrl: recipe.imageUrl, 
                name: recipe.name),
          ],
        ),
      ),
    );
  }
}

@immutable
class RecipeListItem extends StatelessWidget {
  RecipeListItem({
    super.key,
    required this.imageUrl,
    required this.name,
  });

  final String imageUrl;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              _buildParallaxBackground(context),
              _buildGradient(),
              _buildTitleAndSubtitle(),
            ],
          ),
        ),
      ),
    );
  }

  final GlobalKey _backgroundImageKey = GlobalKey();

  Widget _buildParallaxBackground(BuildContext context) {
    return Flow(
      delegate: ParallaxFlowDelegate(
        scrollable: Scrollable.of(context),
        listItemContext: context,
        backgroundImageKey: _backgroundImageKey,
      ),
      children: [
        Image.network(
          imageUrl,
          key: _backgroundImageKey,
          fit: BoxFit.cover,
        ),
      ],
    );
  }

  Widget _buildGradient() {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.6, 0.95],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleAndSubtitle() {
    return Positioned(
      left: 20,
      bottom: 20,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class ParallaxFlowDelegate extends FlowDelegate {
  ParallaxFlowDelegate({
    required this.scrollable,
    required this.listItemContext,
    required this.backgroundImageKey,
  }) : super(repaint: scrollable.position);

  final ScrollableState scrollable;
  final BuildContext listItemContext;
  final GlobalKey backgroundImageKey;

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) {
    return BoxConstraints.tightFor(
      width: constraints.maxWidth,
    );
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    // Calculate the position of this list item within the viewport.
    final scrollableBox = scrollable.context.findRenderObject() as RenderBox;
    final listItemBox = listItemContext.findRenderObject() as RenderBox;
    final listItemOffset = listItemBox.localToGlobal(
      listItemBox.size.centerLeft(Offset.zero),
      ancestor: scrollableBox);

    // Determine the percent position of this list item within the
    // scrollable area.
    final viewportDimension = scrollable.position.viewportDimension;
    final scrollFraction = (listItemOffset.dy / viewportDimension).clamp(0.0, 1.0);

    // Calculate the vertical alignment of the background
    // based on the scroll percent.
    final verticalAlignment = Alignment(0.0, scrollFraction * 2 - 1);

    // Convert the background alignment into a pixel offset for
    // painting purposes.
    final backgroundSize =
        (backgroundImageKey.currentContext!.findRenderObject() as RenderBox)
            .size;
    final listItemSize = context.size;
    final childRect = verticalAlignment.inscribe(backgroundSize, Offset.zero & listItemSize);

    // Paint the background.
    context.paintChild(
      0,
      transform:
          Transform.translate(offset: Offset(0.0, childRect.top)).transform,
    );
  }

  @override
  bool shouldRepaint(covariant ParallaxFlowDelegate  oldDelegate) {
    return scrollable != oldDelegate.scrollable ||
      listItemContext != oldDelegate.listItemContext ||
      backgroundImageKey != oldDelegate.backgroundImageKey;
  }
}

class Recipe {
  const Recipe({
    required this.name,
    required this.imageUrl,
  });

  final String name;
  final String imageUrl;
}

const urlPrefix =
    'https://docs.flutter.dev/cookbook/img-files/effects/parallax';
const recipes = [
  Recipe(
    name: 'Mount Rushmore',
    imageUrl: '$urlPrefix/01-mount-rushmore.jpg',
  ),
  Recipe(
    name: 'Gardens By The Bay',
    imageUrl: '$urlPrefix/02-singapore.jpg',
  ),
  Recipe(
    name: 'Machu Picchu',
    imageUrl: '$urlPrefix/03-machu-picchu.jpg',
  ),
  Recipe(
    name: 'Vitznau',
    imageUrl: '$urlPrefix/04-vitznau.jpg',
  ),
  Recipe(
    name: 'Bali',
    imageUrl: '$urlPrefix/05-bali.jpg',
  ),
  Recipe(
    name: 'Mexico City',
    imageUrl: '$urlPrefix/06-mexico-city.jpg',
  ),
  Recipe(
    name: 'Cairo',
    imageUrl: '$urlPrefix/07-cairo.jpg',
  ),
];