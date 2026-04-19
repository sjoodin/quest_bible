import 'package:flutter/material.dart';

class LeftSideSections extends StatelessWidget {
  const LeftSideSections({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = [
      Colors.green[200],
      Colors.green[400],
      Colors.green[600],
      Colors.green[800],
      Colors.blue,
      Colors.blue[200],
      Colors.indigo,
      Colors.purple,
      Colors.red,
      Colors.yellow[400],
      Colors.yellow[800],
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final sectionHeight = constraints.hasBoundedHeight
            ? constraints.maxHeight / colors.length
            : 24.0;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(colors.length, (index) {
            return GestureDetector(
              onTap: () {},
              child: Container(
                width: 25,
                height: sectionHeight,
                color: colors[index],
              ),
            );
          }),
        );
      },
    );
  }
}
