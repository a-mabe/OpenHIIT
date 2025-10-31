import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

enum StartSaveState { save, start, saving }

class StartSaveToggle extends StatelessWidget {
  final StartSaveState state;
  final VoidCallback onPressed;
  final bool isExpanded;

  const StartSaveToggle({
    super.key,
    required this.state,
    required this.onPressed,
    required this.isExpanded,
  });

  @override
  Widget build(BuildContext context) {
    // Determine visual attributes by state
    final (color, icon, labelWidget, enabled) = switch (state) {
      StartSaveState.save => (
          Colors.blue,
          const Icon(Icons.save),
          const Text('Save'),
          true,
        ),
      StartSaveState.start => (
          Colors.green,
          const Icon(Icons.play_arrow),
          Shimmer.fromColors(
            baseColor: Colors.white,
            highlightColor: const Color.fromARGB(255, 155, 187, 162),
            child: const Text('Start'),
          ),
          true,
        ),
      StartSaveState.saving => (
          Colors.grey,
          const SizedBox(
            width: 18,
            height: 18,
            child:
                CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
          ),
          const Text('Saving'),
          false,
        ),
    };

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      width: isExpanded ? 140 : 56,
      height: 56,
      child: FloatingActionButton(
        key: const Key('start-save-button'),
        onPressed: enabled ? onPressed : null,
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: const StadiumBorder(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            ClipRect(
              child: AnimatedAlign(
                alignment: isExpanded ? Alignment.centerLeft : Alignment.center,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                widthFactor: isExpanded ? 1.0 : 0.0,
                child: AnimatedOpacity(
                  opacity: isExpanded ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: DefaultTextStyle(
                      style: const TextStyle(color: Colors.white),
                      child: labelWidget,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
