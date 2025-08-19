import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class StartButton extends StatefulWidget {
  final Function? onPressed;

  const StartButton({super.key, this.onPressed});

  @override
  State<StartButton> createState() => _StartButtonState();
}

class _StartButtonState extends State<StartButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (widget.onPressed != null) {
            widget.onPressed!();
          }
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: Colors.green,
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.white,
            period: const Duration(milliseconds: 2000),
            highlightColor: const Color.fromARGB(255, 155, 187, 162),
            child: SizedBox(
                width: 85,
                height: 35,
                child: Center(
                    child: Text(
                  'Start',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ))),
          ),
        ));
  }
}
