import 'package:flutter/material.dart';
import 'package:soundpool/soundpool.dart';
import '../data/sound_name_map.dart';

/// Possible interval states
// enum IntervalStates { start, work, rest, complete }

///
/// Background service countdown interval timer.
///
class SoundDropdown extends StatefulWidget {
  final String title;

  final String initialSelection;

  final Soundpool pool;

  final Key dropdownKey;

  final List<String> soundsList;

  final Function? onFinished;

  ///
  /// Simple countdown timer
  ///
  const SoundDropdown({
    super.key,
    required this.title,
    required this.initialSelection,
    required this.pool,
    required this.dropdownKey,
    required this.soundsList,
    required this.onFinished,
  });

  @override
  SoundDropdownState createState() => SoundDropdownState();
}

///
/// State of timer
///
class SoundDropdownState extends State<SoundDropdown>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
            child: Text(
              widget.title,
              style: const TextStyle(
                // color: Colors.grey[700],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          DropdownMenu<String>(
            key: widget.dropdownKey,
            width: 240,
            initialSelection: widget.initialSelection,
            onSelected: (String? value) {
              // This is called when the user selects an item.
              widget.onFinished!(value);
            },
            dropdownMenuEntries: widget.soundsList
                .map<DropdownMenuEntry<String>>((String value) {
              return DropdownMenuEntry<String>(
                  value: value, label: soundNames[value]!);
            }).toList(),
          )
        ],
      ),
    );
  }
}
