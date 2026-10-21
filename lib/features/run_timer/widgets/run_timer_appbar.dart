import 'package:flutter/material.dart';

class RunTimerAppBar extends StatelessWidget {
  final String intervalLabel;
  final String? setLabel;
  final String? totalLabel;

  const RunTimerAppBar(
      {super.key, required this.intervalLabel, this.setLabel, this.totalLabel});

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
      FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              intervalLabel,
              style: const TextStyle(color: Colors.white, fontSize: 30),
            ),
            if (setLabel != null && setLabel!.isNotEmpty)
              Text(
                setLabel!,
                style: TextStyle(
                    color: Colors.white.withValues(alpha: .9),
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            if (totalLabel != null && totalLabel!.isNotEmpty)
              Text(
                totalLabel!,
                key: const Key("run-timer-total-label"),
                style: TextStyle(
                    color: Colors.white.withValues(alpha: .9),
                    fontSize: 16,
                    fontFeatures: const [FontFeature.tabularFigures()]),
              ),
          ],
        ),
      ),
      const Spacer(),
      const SizedBox(
        width: 50,
        height: 50,
      )
    ]);
  }
}
