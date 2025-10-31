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

//   const TimeRow({
//     super.key,
//     required this.title,
//     required this.subtitle,
//     required this.showMinutes,
//     this.enabled = true,
//     this.unit = "s",
//     this.leadingIcon,
//     this.minutesController,
//     this.secondsController,
//     this.minutesOnSaved,
//     this.secondsOnSaved,
//     this.secondsOnChanged,
//     this.minutesValidator,
//     this.secondsValidator,
//   });

//   @override
//   State<TimeRow> createState() => _TimeRowState();
// }

// class _TimeRowState extends State<TimeRow> {
//   String? _defaultValidator(String? value) =>
//       (value == null || value.isEmpty) ? '' : null;

//   String? _defaultOnSaved(String? value) =>
//       (value == null || value.isEmpty) ? '' : null;

//   @override
//   Widget build(BuildContext context) {
//     final minutesController =
//         widget.minutesController ?? TextEditingController(text: "0");
//     final secondsController =
//         widget.secondsController ?? TextEditingController(text: "0");

//     return TimeListItem(
//       titleText: widget.title,
//       subtitleText: widget.subtitle,
//       enabled: widget.enabled,
//       leadingWidget:
//           widget.leadingIcon != null ? Icon(widget.leadingIcon) : null,
//       trailingWidget: TimeInputTrailing(
//         enabled: widget.enabled,
//         secondsOnChanged: widget.secondsOnChanged ?? (_) {},
//         showMinutes: widget.showMinutes,
//         minutesKey: "${widget.title.toLowerCase()}-minutes",
//         secondsKey: "${widget.title.toLowerCase()}-seconds",
//         unit: widget.unit,
//         title: widget.title,
//         widgetWidth: widget.showMinutes == 1 ? 185 : 80,
//         minutesController: minutesController,
//         secondsController: secondsController,
//         minutesValidator: widget.minutesValidator ?? _defaultValidator,
//         minutesOnSaved: widget.minutesOnSaved ?? _defaultOnSaved,
//         secondsValidator: widget.secondsValidator ?? _defaultValidator,
//         secondsOnSaved: widget.secondsOnSaved ?? _defaultOnSaved,
//       ),
//     );
//   }
// }
