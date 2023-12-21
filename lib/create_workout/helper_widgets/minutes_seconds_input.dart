// /// Copyright (C) 2021 Abigail Mabe - All Rights Reserved
// /// You may use, distribute and modify this code under the terms
// /// of the license.
// ///
// /// You should have received a copy of the license with this file.
// /// If not, please email <mabe.abby.a@gmail.com>
// ///
// ///

// import 'package:flutter/material.dart';
// import 'package:openhiit/create_workout/helper_widgets/number_input.dart';

// class MinutesSecondsInput extends StatefulWidget {
//   /// Vars

//   final int numberValue;

//   final Function formatter;

//   final void Function(String?, String?) onSaved;

//   const MinutesSecondsInput({
//     Key? key,
//     required this.numberValue,
//     required this.formatter,
//     required this.onSaved,
//   }) : super(key: key);

//   @override
//   MinutesSecondsInputState createState() => MinutesSecondsInputState();
// }

// class MinutesSecondsInputState extends State<MinutesSecondsInput> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         NumberInput(
//             numberValue: widget.numberValue,
//             formatter: (value) {
//               return (widget.numberValue - (widget.numberValue % 60)) / 60;
//             },
//             onSaved: (value) {},
//             unit: "m",
//             min: 1,
//             max: 99),
//         NumberInput(
//             numberValue: widget.numberValue,
//             formatter: (value) {
//               return widget.numberValue % 60;
//             },
//             onSaved: (value) {},
//             unit: "s",
//             min: 0,
//             max: 59),
//       ],
//     );
//   }
// }
