import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class StaggeredGridTemplete extends StatelessWidget {
  final List<Widget> listTile;
  const StaggeredGridTemplete({super.key, required this.listTile});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: StaggeredGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        children: listTile,
      ),
    );
  }
}
