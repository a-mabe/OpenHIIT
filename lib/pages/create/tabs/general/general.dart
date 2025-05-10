// import 'package:flutter/material.dart';
// import 'package:openhiit/models/timer/timer_type.dart';
// import 'package:openhiit/widgets/form_widgets/create_form.dart';

// class GeneralTab extends StatefulWidget {
//   final TimerType timer;
//   final GlobalKey<FormState> formKey;

//   const GeneralTab({super.key, required this.timer, required this.formKey});

//   @override
//   GeneralTabState createState() => GeneralTabState();
// }

// class GeneralTabState extends State<GeneralTab> {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: CreateForm(timer: widget.timer, formKey: widget.formKey),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:openhiit/models/timer/timer_type.dart';
import 'package:openhiit/pages/create/tabs/general/sections/general_section.dart';
// import 'package:openhiit/pages/create/tabs/general/sections/interval_settings_rows.dart';
import 'package:openhiit/pages/create/tabs/general/sections/time_section.dart';
// import 'package:openhiit/widgets/form_widgets/number_input.dart';
// import 'package:openhiit/widgets/form_widgets/color_picker.dart';

class GeneralTab extends StatefulWidget {
  const GeneralTab({super.key});

  @override
  GeneralTabState createState() => GeneralTabState();
}

class GeneralTabState extends State<GeneralTab> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: Column(
        children: [
          GeneralSection(),
          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),
          TimeSection(),
        ],
      ),
    ));

    // List<bool> selectedTimerDisplayOptions =
    //     widget.timer.showMinutes == 1 ? [false, true] : [true, false];

    // /// The onTap logic for [ColorPicker]. Opens a dialog that
    // /// allows the user to select a color.
    // ///
    // void pickColor() {
    //   Color selectedColor = Color(widget.timer.color);
    //   showDialog(
    //     context: context,
    //     builder: (context) {
    //       return AlertDialog(
    //         content: MaterialColorPicker(
    //           onMainColorChange: (value) {
    //             selectedColor = value as Color;
    //           },
    //           allowShades: false,
    //           selectedColor: selectedColor,
    //         ),
    //         actions: [
    //           TextButton(
    //             onPressed: () {
    //               Navigator.pop(context);
    //             },
    //             child: const Text('Cancel'),
    //           ),
    //           TextButton(
    //             onPressed: () {
    //               Navigator.pop(context);
    //               setState(() {
    //                 widget.timer.color = selectedColor.value;
    //               });
    //             },
    //             child: const Text('Select'),
    //           ),
    //         ],
    //       );
    //     },
    //   );
    // }
    // ---

    // return CreateForm(timer: widget.timer, formKey: widget.formKey);

    // return SizedBox(
    //     height: (MediaQuery.of(context).size.height) -
    //         MediaQuery.of(context).size.height / 12,
    //     child: SingleChildScrollView(
    //         child: Form(
    //       key: widget.formKey,
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.start,
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: <Widget>[
    //           Padding(
    //               padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
    //               child: TextFormField(
    //                 key: const Key('timer-name'),
    //                 initialValue: widget.timer.name,
    //                 textCapitalization: TextCapitalization.sentences,
    //                 validator: (value) {
    //                   if (value == null || value.isEmpty) {
    //                     return 'Please enter some text';
    //                   }
    //                   return null;
    //                 },
    //                 onSaved: (String? val) {
    //                   widget.timer.name = val!;
    //                 },
    //                 onChanged: (String? val) {
    //                   widget.timer.name = val!;
    //                 },
    //                 style: const TextStyle(fontSize: 24),
    //                 decoration: InputDecoration(
    //                   hintText: "Add title",
    //                   border: InputBorder.none,
    //                   contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
    //                 ),
    //               )),

    //           Divider(
    //             color: Colors.grey.shade800,
    //             thickness: 1,
    //           ),

    //           GeneralTapRow(
    //             leading: Container(
    //               width: 20,
    //               height: 20,
    //               decoration: BoxDecoration(
    //                 shape: BoxShape.circle,
    //                 color: Color(widget.timer.color),
    //               ),
    //             ),
    //             title: "Color",
    //             trailing: Container(),
    //             onTap: () {
    //               pickColor();
    //             },
    //           ),

    //           Divider(
    //             color: Colors.grey.shade800,
    //             thickness: 1,
    //           ),

    //           GeneralTrailingInputRow(
    //             leading: const Icon(Icons.view_timeline_outlined,
    //                 color: Colors.grey),
    //             title: "Active Intervals",
    //             subtitle: "# of work intervals",
    //             trailing: Expanded(
    //                 child: TimeInput(
    //               widgetWidth: 60,
    //               numberInputKey: const Key('interval-input'),
    //               controller: TextEditingController(
    //                   text: widget.timer.activeIntervals == 0
    //                       ? ""
    //                       : widget.timer.activeIntervals.toString()),
    //               formatter: (value) {
    //                 return value;
    //               },
    //               validator: (value) {
    //                 if (value == null || value.isEmpty) {
    //                   return 'Enter intervals';
    //                 }
    //                 return null;
    //               },
    //               onSaved: (String? val) {
    //                 widget.timer.activeIntervals = int.parse(val!);
    //               },
    //               onChanged: (String? val) {
    //                 if (val!.isNotEmpty) {
    //                   widget.timer.activeIntervals = int.parse(val);
    //                 }
    //               },
    //               unit: "intervals",
    //               min: 1,
    //               max: 999,
    //             )),
    //           ),

    //           Divider(
    //             color: Colors.grey.shade800,
    //             thickness: 1,
    //           ),

    //           GeneralTrailingInputRow(
    //               leading: const Icon(Icons.timer_outlined, color: Colors.grey),
    //               title: "Timer Display",
    //               subtitle: "Seconds or minutes",
    //               trailing: ClockPicker(
    //                   displayOption: 1,
    //                   selectedTimerDisplayOptions: selectedTimerDisplayOptions,
    //                   onPressed: (int index) {
    //                     setState(() {
    //                       // The button that is tapped is set to true, and the others to false.
    //                       for (int i = 0;
    //                           i < selectedTimerDisplayOptions.length;
    //                           i++) {
    //                         selectedTimerDisplayOptions[i] = i == index;
    //                         widget.timer.showMinutes = index;
    //                       }
    //                     });
    //                   })),

    //           Divider(
    //             color: Colors.grey.shade800,
    //             thickness: 1,
    //           ),

    //           /// Workout/timer color form field.
    //           ///
    //           // Padding(
    //           //   padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
    //           //   child: SizedBox(
    //           //     height: MediaQuery.of(context).size.height / 22,
    //           //     child: const AutoSizeText("Set color:",
    //           //         maxFontSize: 50,
    //           //         minFontSize: 16,
    //           //         style: TextStyle(
    //           //             color: Color.fromARGB(255, 107, 107, 107),
    //           //             fontSize: 30)),
    //           //   ),
    //           // ),
    //           // Center(
    //           //     child: ColorPicker(
    //           //   key: const Key('color-picker'),
    //           //   onTap: () {
    //           //     pickColor();
    //           //   },
    //           //   color: Color(widget.timer.color),
    //           // )),

    //           /// Workout/timer number of intervals.
    //           ///
    //           // Padding(
    //           //   padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
    //           //   child: SizedBox(
    //           //     height: MediaQuery.of(context).size.height / 22,
    //           //     child: const AutoSizeText("Number of intervals:",
    //           //         maxFontSize: 50,
    //           //         minFontSize: 16,
    //           //         style: TextStyle(
    //           //             color: Color.fromARGB(255, 107, 107, 107),
    //           //             fontSize: 30)),
    //           //   ),
    //           // ),
    //           // NumberInput(
    //           //     widgetWidth: 60,
    //           //     numberInputKey: const Key('interval-input'),
    //           //     controller: TextEditingController(
    //           //         text: widget.timer.activeIntervals == 0
    //           //             ? ""
    //           //             : widget.timer.activeIntervals.toString()),
    //           //     formatter: (value) {
    //           //       return value;
    //           //     },
    //           //     validator: (value) {
    //           //       if (value == null || value.isEmpty) {
    //           //         return 'Enter intervals';
    //           //       }
    //           //       return null;
    //           //     },
    //           //     onSaved: (String? val) {
    //           //       widget.timer.activeIntervals = int.parse(val!);
    //           //     },
    //           //     onChanged: (String? val) {
    //           //       if (val!.isNotEmpty) {
    //           //         widget.timer.activeIntervals = int.parse(val);
    //           //       }
    //           //     },
    //           //     unit: "intervals",
    //           //     min: 1,
    //           //     max: 999),

    //           /// Workout/timer timer display
    //           ///
    //           // Padding(
    //           //   padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
    //           //   child: SizedBox(
    //           //     height: MediaQuery.of(context).size.height / 22,
    //           //     child: const AutoSizeText("Timer display:",
    //           //         maxFontSize: 50,
    //           //         minFontSize: 16,
    //           //         style: TextStyle(
    //           //             color: Color.fromARGB(255, 107, 107, 107),
    //           //             fontSize: 30)),
    //           //   ),
    //           // ),
    //           // Padding(
    //           //     padding: const EdgeInsets.fromLTRB(0, 0, 0, 35),
    //           //     child: ClockPicker(
    //           //         displayOption: 1,
    //           //         selectedTimerDisplayOptions: selectedTimerDisplayOptions,
    //           //         onPressed: (int index) {
    //           //           setState(() {
    //           //             // The button that is tapped is set to true, and the others to false.
    //           //             for (int i = 0;
    //           //                 i < selectedTimerDisplayOptions.length;
    //           //                 i++) {
    //           //               selectedTimerDisplayOptions[i] = i == index;
    //           //               widget.timer.showMinutes = index;
    //           //             }
    //           //           });
    //           //         }))
    //         ],
    //       ),
    //     )));
  }
}
