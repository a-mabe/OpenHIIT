import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

enum StartSaveState { save, start, saving }

class StartSaveToggle extends StatefulWidget {
  final StartSaveState state;
  final VoidCallback onPressed;

  const StartSaveToggle({
    super.key,
    required this.state,
    required this.onPressed,
  });

  @override
  State<StartSaveToggle> createState() => _StartSaveToggleState();
}

class _StartSaveToggleState extends State<StartSaveToggle> {
  late StartSaveState _currentState;

  @override
  void initState() {
    super.initState();
    _currentState = widget.state;
  }

  @override
  void didUpdateWidget(covariant StartSaveToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state != widget.state) {
      _currentState = widget.state;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentState = widget.state;
  }

  @override
  Widget build(BuildContext context) {
    switch (_currentState) {
      case StartSaveState.save:
        return TextButton.icon(
          key: const Key('save-button'),
          onPressed: widget.onPressed,
          style: TextButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          icon: const Icon(Icons.save),
          label: const Text('Save'),
        );
      case StartSaveState.start:
        return TextButton(
          key: const Key('start-button'),
          onPressed: widget.onPressed,
          style: TextButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.white,
            highlightColor: const Color.fromARGB(255, 155, 187, 162),
            child: const Text('Start'),
          ),
        );
      case StartSaveState.saving:
        return TextButton.icon(
          key: const Key('saving-button'),
          onPressed: null,
          style: TextButton.styleFrom(
            backgroundColor: Colors.grey,
            foregroundColor: Colors.white,
          ),
          icon: const SizedBox(
            width: 18,
            height: 18,
            child:
                CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
          ),
          label: const Text('Saving'),
        );
    }
  }
}
