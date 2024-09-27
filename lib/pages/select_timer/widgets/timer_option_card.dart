import 'package:flutter/material.dart';

class TimerOptionCard extends StatefulWidget {
  /// Vars

  /// Function to run when the InkWell is tapped.
  ///
  final Function? onTap;

  /// Icon to display on the card.
  ///
  final IconData optionIcon;

  /// Title text to display on the card.
  ///
  final String optionTitle;

  /// Description text to display on the card.
  ///
  final String optionDescription;

  const TimerOptionCard(
      {super.key,
      required this.onTap,
      required this.optionIcon,
      required this.optionTitle,
      required this.optionDescription});

  @override
  TimerOptionCardState createState() => TimerOptionCardState();
}

class TimerOptionCardState extends State<TimerOptionCard> {
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
    return Card(
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                    child: Icon(widget.optionIcon, size: 20),
                  ),
                  Text(
                    widget.optionTitle,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_forward,
                    size: 20,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Text(widget.optionDescription),
              )
            ],
          ),
        ),
        onTap: () {
          widget.onTap!();
        },
      ),
    );
  }
}
