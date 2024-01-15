import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class SubmitButton extends StatefulWidget {
  /// Vars

  /// Text to display on the button.
  ///
  /// e.g., Submit
  ///
  final String text;

  final Color color;

  final Function onTap;

  const SubmitButton(
      {super.key,
        required this.text,
        required this.color,
        required this.onTap});

  @override
  SubmitButtonState createState() => SubmitButtonState();
}

class SubmitButtonState extends State<SubmitButton> {
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
    double sizeHeight = MediaQuery.of(context).size.height;
    double sizeWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
          decoration: BoxDecoration(
              color: widget.color,
              // border: Border.fromBorderSide(BorderSide.lerp(a, b, t)),
              borderRadius: BorderRadius.circular((sizeHeight * sizeWidth) * .0005),
          ),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 12,
          child: InkWell(
            onTap: () {
              widget.onTap();
            },
            child: Ink(
              height: MediaQuery.of(context).size.height / 12,
              width: MediaQuery.of(context).size.width,
              child: SafeArea(
                child: Stack(
                  children: [
                    Center(

                        child: AutoSizeText(
                          widget.text,
                          minFontSize: 18,
                          // maxFontSize: 200,
                          style: const TextStyle(
                              fontSize: 25, color: Colors.white),
                        )
                    ),
                    Positioned(
                      right: 5,
                      top: 5,
                      child: Container(
                        height: MediaQuery.of(context).size.height / 14,
                        width: MediaQuery.of(context).size.height / 14,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255,32,132,231),
                          borderRadius: BorderRadius.all(Radius.circular(35)),
                        ),
                        child: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
      ),
    );
  }
}
