// import 'package:flutter/material.dart';
// import 'package:openhiit/pages/create/tabs/general/sections/rows/widgets/time_input_trailing.dart';
// import 'package:openhiit/pages/create/tabs/general/sections/rows/widgets/time_list_item.dart';

// class TimeRow extends StatefulWidget {
//   final String title;
//   final String subtitle;
//   final int showMinutes;
//   final bool enabled;
//   final String unit;
//   final IconData? leadingIcon;
//   final TextEditingController? minutesController;
//   final TextEditingController? secondsController;
//   final Function(String?)? minutesOnSaved;
//   final Function(String?)? secondsOnSaved;
//   final Function(String?)? secondsOnChanged;
//   final String? Function(String?)? minutesValidator;
//   final String? Function(String?)? secondsValidator;

//   const TimeRow(
//       {super.key,
//       required this.title,
//       required this.subtitle,
//       required this.showMinutes,
//       this.enabled = true,
//       this.unit = "s",
//       this.leadingIcon,
//       this.minutesController,
//       this.secondsController,
//       this.minutesOnSaved,
//       this.secondsOnSaved,
//       this.secondsOnChanged,
//       this.minutesValidator,
//       this.secondsValidator});

//   @override
//   TimeRowState createState() => TimeRowState();
// }

// class TimeRowState extends State<TimeRow> {
//   @override
//   Widget build(BuildContext context) {
//     return TimeListItem(
//       titleText: widget.title,
//       subtitleText: widget.subtitle,
//       enabled: widget.enabled,
//       leadingWidget: widget.leadingIcon != null
//           ? Icon(
//               widget.leadingIcon,
//             )
//           : null,
//       trailingWidget: TimeInputTrailing(
//           enabled: widget.enabled,
//           secondsOnChanged: (text) {},
//           showMinutes: widget.showMinutes,
//           // timeInSeconds: 0,
//           minutesKey: "${widget.title.toLowerCase()}-minutes",
//           secondsKey: "${widget.title.toLowerCase()}-seconds",
//           unit: widget.unit,
//           title: widget.title,
//           widgetWidth: widget.showMinutes == 1 ? 185 : 80,
//           minutesController: widget.minutesController ??
//               TextEditingController(
//                 text: widget.minutesController?.text ?? "0",
//               ),
//           secondsController: widget.secondsController ??
//               TextEditingController(
//                 text: widget.secondsController?.text ?? "0",
//               ),
//           minutesValidator: (widget.minutesValidator ??
//               (value) {
//                 if (value == null || value.isEmpty) {
//                   return '';
//                 }
//                 return null;
//               }),
//           minutesOnSaved: (widget.minutesOnSaved ??
//               (value) {
//                 if (value == null || value.isEmpty) {
//                   return '';
//                 }
//                 return null;
//               }),
//           secondsValidator: (widget.secondsValidator ??
//               (value) {
//                 if (value == null || value.isEmpty) {
//                   return '';
//                 }
//                 return null;
//               }),
//           secondsOnSaved: (widget.secondsOnSaved ??
//               (value) {
//                 if (value == null || value.isEmpty) {
//                   return '';
//                 }
//                 return null;
//               })),
//     );
//   }
// }
