import 'package:flutter/material.dart';
import 'package:soundpool/soundpool.dart';
import '../constants/sounds.dart';

class SoundDropdown extends StatefulWidget {
  final String title;
  final String initialSelection;
  final Soundpool pool;
  final Key dropdownKey;
  final List<String> soundsList;
  final Function? onFinished;

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
    String initialSelection;
    widget.initialSelection == ""
        ? initialSelection = "none"
        : initialSelection = widget.initialSelection;

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
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          DropdownMenu<String>(
            key: widget.dropdownKey,
            width: 240,
            initialSelection: initialSelection,
            onSelected: (String? value) {
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
