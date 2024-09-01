import 'package:flutter/material.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

class ReorderableWorkoutGridView extends StatefulWidget {
  const ReorderableWorkoutGridView(
      {super.key, required this.onReorder, this.workouts});

  /// Callback function for when a workout is reordered.
  ///
  final Function onReorder;

  /// List of workouts to display in the grid view.
  ///
  final List<Widget>? workouts;

  @override
  State<ReorderableWorkoutGridView> createState() =>
      _ReorderableWorkoutGridViewState();
}

class _ReorderableWorkoutGridViewState
    extends State<ReorderableWorkoutGridView> {
  @override
  Widget build(BuildContext context) {
    return ReorderableGridView.count(
      dragWidgetBuilderV2: DragWidgetBuilderV2(
          builder: (int index, Widget child, ImageProvider? screenshot) {
        return child;
      }),
      childAspectRatio: MediaQuery.of(context).size.width < 550 ? 3 : 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: MediaQuery.of(context).size.width < 550 ? 1 : 2,
      onReorder: (oldIndex, newIndex) async {
        widget.onReorder(oldIndex, newIndex);
      },
      children: widget.workouts ?? [],
    );
  }
}
