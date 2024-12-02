import 'package:flutter/material.dart';

class LandscapeRunTimerAppBar extends StatefulWidget {
  const LandscapeRunTimerAppBar({super.key});

  @override
  LandscapeRunTimerAppBarState createState() => LandscapeRunTimerAppBarState();
}

class LandscapeRunTimerAppBarState extends State<LandscapeRunTimerAppBar> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? const Color.fromARGB(70, 0, 0, 0)
                          : Colors.transparent),
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
      const Spacer(),
      const SizedBox(
        width: 50,
        height: 50,
      )
    ]);
  }
}
