import 'package:flutter/material.dart';

class RunTimerAppBar extends StatefulWidget {
  final String text;

  const RunTimerAppBar({super.key, required this.text});

  @override
  RunTimerAppBarState createState() => RunTimerAppBarState();
}

class RunTimerAppBarState extends State<RunTimerAppBar> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      GestureDetector(
        key: const Key("run-timer-appbar-back-button"),
        onTap: () {
          Navigator.pop(context);
        },
        child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: const Color.fromARGB(70, 0, 0, 0)),
              width: 50,
              height: 50,
              child: Icon(
                color: Colors.white,
                Icons.arrow_back,
                size: MediaQuery.of(context).orientation == Orientation.portrait
                    ? 50
                    : 30,
              ),
            )),
      ),
      const Spacer(),
      Text(
        widget.text,
        style: TextStyle(color: Colors.white, fontSize: 30),
      ),
      const Spacer(),
      const SizedBox(
        width: 50,
        height: 50,
      )
    ]);
  }
}
