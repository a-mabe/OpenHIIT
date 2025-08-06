// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:background_hiit_timer/models/interval_type.dart';
// import 'package:flutter/material.dart';
// import 'package:openhiit/models/lists/timer_list_tile_model.dart';

// class EditorTile extends StatelessWidget {
//   final Color fontColor;
//   final FontWeight fontWeight;
//   final Color backgroundColor;
//   final TimerListTileModel item;
//   final String textKey;

//   final VoidCallback? onTap;
//   final void Function(String?)? onSaved;
//   final String? Function(String?)? validator;
//   final void Function(String)? onChanged;

//   final double sizeMultiplier;
//   final TextEditingController? controller;

//   const EditorTile(
//       {super.key,
//       this.onTap,
//       this.onSaved,
//       this.validator,
//       this.onChanged,
//       required this.fontColor,
//       required this.backgroundColor,
//       required this.fontWeight,
//       required this.item,
//       required this.textKey,
//       required this.sizeMultiplier,
//       this.controller});

//   /// Calculate padding to place around text depending on the device orientation.
//   ///
//   double calcPadding(context) {
//     // return MediaQuery.of(context).orientation == Orientation.portrait ? 15 : 5;
//     return 10;
//   }

//   double calcHeight(String action) {
//     if (action.length > 20) {
//       if (action.length > 30) {
//         return 110 * sizeMultiplier;
//       }
//       return 100 * sizeMultiplier;
//     } else {
//       return 75 * sizeMultiplier;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     /// Minimum height that each ListTile can be.
//     ///
//     double minHeight = 75;

//     return Container(
//         decoration: BoxDecoration(
//           color: backgroundColor,
//           // Set top border.
//           border: const Border(
//             top: BorderSide(
//               color: Color.fromARGB(53, 255, 255, 255),
//               width: 3.0,
//             ),
//           ),
//         ),
//         child: ConstrainedBox(
//           constraints: BoxConstraints(
//             minHeight: minHeight,
//             maxHeight: calcHeight(item.action),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               // Interval number, e.g. 1/8.
//               Expanded(
//                   flex: 20,
//                   child: Padding(
//                       padding: EdgeInsets.fromLTRB(15, calcPadding(context) + 5,
//                           8, calcPadding(context) + 5),
//                       child: ConstrainedBox(
//                           constraints: const BoxConstraints(
//                             minHeight: 50,
//                             maxHeight: 100,
//                           ),
//                           child: AutoSizeText(
//                             item.interval != 0 ? item.interval.toString() : "",
//                             maxLines: 1,
//                             minFontSize: 14,
//                             maxFontSize: 500,
//                             style: TextStyle(
//                               color: fontColor,
//                               fontSize: 500,
//                             ),
//                           )))),
//               // Current interval text, "Work" if no exercise provided.
//               Expanded(
//                   flex: 60,
//                   child: Padding(
//                       padding: EdgeInsets.fromLTRB(
//                           8, calcPadding(context), 8.0, calcPadding(context)),
//                       child: ![
//                         "get ready",
//                         "warmup",
//                         "cooldown",
//                         "break",
//                         "rest"
//                       ].contains(item.action.toLowerCase())
//                           ? TextFormField(
//                               key: Key(textKey),
//                               controller: controller,
//                               initialValue:
//                                   controller == null ? item.action : null,
//                               onSaved: onSaved,
//                               validator: validator,
//                               onTap: onTap,
//                               onChanged: onChanged,
//                               style: TextStyle(
//                                 fontSize: 24,
//                                 color: fontColor,
//                                 fontWeight: fontWeight,
//                               ),
//                               decoration: InputDecoration(
//                                 // labelText: "Action ",
//                                 filled: true,
//                                 fillColor:
//                                     const Color.fromARGB(255, 58, 58, 58),
//                                 suffix: Icon(
//                                   Icons.edit,
//                                   size: 20,
//                                 ),
//                                 suffixIconConstraints: BoxConstraints(
//                                   minWidth: 25,
//                                   minHeight: 0,
//                                 ),
//                                 contentPadding:
//                                     EdgeInsets.fromLTRB(10, 0, 10, 0),
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                   borderSide: BorderSide.none,
//                                 ),
//                                 // border: OutlineInputBorder(),
//                               ),
//                             )
//                           : AutoSizeText(
//                               item.action,
//                               maxLines: 2,
//                               minFontSize: 20,
//                               maxFontSize: 20000,
//                               style: TextStyle(
//                                 fontSize: 20000,
//                                 color: fontColor,
//                               ),
//                             ))),
//               // AutoSizeText(
//               //   item.action.padRight(50, " "),
//               //   maxLines: 2,
//               //   minFontSize: 20,
//               //   maxFontSize: 20000,
//               //   style: TextStyle(fontSize: 20000, color: fontColor),
//               // )
//               // Time allotted to the interval.
//               Expanded(
//                 flex: 20,
//                 child: Padding(
//                     padding: EdgeInsets.fromLTRB(
//                         8.0, calcPadding(context), 15, calcPadding(context)),
//                     child: AutoSizeText(
//                       item.timeString(),
//                       maxLines: 1,
//                       minFontSize: 0,
//                       maxFontSize: 20000,
//                       textAlign: TextAlign.end,
//                       style: TextStyle(fontSize: 20000, color: fontColor),
//                     )),
//               )
//             ],
//           ),
//         ));
//   }
// }
