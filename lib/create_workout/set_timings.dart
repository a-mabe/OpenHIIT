import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:openhiit/create_workout/constants/set_timings_constants.dart';
import 'package:openhiit/create_workout/helper_widgets/time_input_trailing.dart';
import '../workout_data_type/workout_type.dart';
import 'helper_widgets/submit_button.dart';
import 'helper_widgets/time_list_item.dart';
import 'set_sounds.dart';

var logger = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

class SetTimings extends StatefulWidget {
  const SetTimings({super.key});

  @override
  State<SetTimings> createState() => _SetTimingsState();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _SetTimingsState extends State<SetTimings> {
  Map<String, int> timeMap = {
    "Work-minutes": 0,
    "Work-seconds": 0,
    "Rest-minutes": 0,
    "Rest-seconds": 0,
    "Warm-up-minutes": 0,
    "Warm-up-seconds": 0,
    "Cool down-minutes": 0,
    "Cool down-seconds": 0,
    "Break-minutes": 0,
    "Break-seconds": 0,
    "Get ready-minutes": 0,
    "Get ready-seconds": 0,
  };

  int repeat = 0;

  @override
  Widget build(BuildContext context) {
    Workout workout = ModalRoute.of(context)!.settings.arguments as Workout;

    final formKey = GlobalKey<FormState>();

    ValueNotifier<int> iterationsNotifier = ValueNotifier(workout.iterations);

    return Scaffold(
        appBar: AppBar(
          title: const Text("New Interval Timer"),
        ),
        bottomSheet: SubmitButton(
          text: "Submit",
          color: const Color.fromARGB(255, 58, 165, 255),
          onTap: () {
            submitTimings(workout, formKey);
          },
        ),
        body: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 120),
            child: Form(
                key: formKey,
                child: ListView.builder(
                    itemCount: timeTitles.length,
                    itemBuilder: (context, index) {
                      return determineTile(workout, index, iterationsNotifier);
                    }))));
  }

  void submitTimings(Workout workoutArg, GlobalKey<FormState> formKey) {
    // Validate returns true if the form is valid, or false otherwise.
    final form = formKey.currentState!;
    if (form.validate()) {
      form.save();

      workoutArg.workTime = (timeMap["$workTitle-minutes"]! * 60) +
          timeMap["$workTitle-seconds"]!;
      workoutArg.restTime = (timeMap["$restTitle-minutes"]! * 60) +
          timeMap["$restTitle-seconds"]!;
      workoutArg.getReadyTime = (timeMap["$getReadyTitle-minutes"]! * 60) +
          timeMap["$getReadyTitle-seconds"]!;
      workoutArg.warmupTime = (timeMap["$warmUpTitle-minutes"]! * 60) +
          timeMap["$warmUpTitle-seconds"]!;
      workoutArg.cooldownTime = (timeMap["$coolDownTitle-minutes"]! * 60) +
          timeMap["$coolDownTitle-seconds"]!;
      workoutArg.breakTime = (timeMap["$breakTitle-minutes"]! * 60) +
          timeMap["$breakTitle-seconds"]!;
      workoutArg.iterations = repeat;

      logger.i("Saving workout: ${workoutArg.toString()}");
      logger.i(repeat);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SetSounds(),
          settings: RouteSettings(
            arguments: workoutArg,
          ),
        ),
      );
    }
  }

  Widget determineTile(
      Workout workoutArg, int index, ValueNotifier<int> iterationsNotifier) {
    switch (index) {
      case 0:
      case 1:
        return returnTile(
            workoutArg,
            index,
            determinePrefilledTime(workoutArg, timeTitles[index]),
            timeTitles,
            timeSubTitles,
            timeLeadingIcons,
            timeMinutesKeys[index],
            timeSecondsKeys[index],
            iterationsNotifier);
      case 2:
        return returnExpansionTile(workoutArg, index, iterationsNotifier);
      default:
        return const Text("");
    }
  }

  Widget returnTile(
      Workout workoutArg,
      int index,
      int time,
      List<String> titleList,
      List<String> subtitleList,
      List<Widget> iconList,
      String minutesKey,
      String secondsKey,
      ValueNotifier<int> iterationsNotifier) {
    return ValueListenableBuilder(
        valueListenable: iterationsNotifier,
        builder: (BuildContext context, int val, Widget? child) {
          return TimeListItem(
            titleText: titleList[index],
            subtitleText: subtitleList[index],
            enabled: titleList[index] == breakTitle
                ? (iterationsNotifier.value > 0 ? true : false)
                : true,
            leadingWidget: iconList[index],
            trailingWidget: titleList[index] != additionalConfigTitle
                ? Visibility(
                    visible: titleList[index] == breakTitle
                        ? (iterationsNotifier.value > 0 ? true : false)
                        : true,
                    child: TimeInputTrailing(
                      title: titleList[index],
                      unit: titleList[index] == repeatTitle ? "time(s)" : "s",
                      widgetWidth: workoutArg.showMinutes == 1 ? 160 : 120,
                      showMinutes: workoutArg.showMinutes,
                      timeInSeconds: time,
                      minutesValidator: (value) {
                        if ((titleList[index] == workTitle ||
                                titleList[index] == restTitle) &&
                            (value == null ||
                                value.isEmpty ||
                                int.parse(value) == 0)) {
                          return 'Enter time';
                        }
                        return null;
                      },
                      minutesOnSaved: (value) {
                        if (value != "") {
                          setState(() =>
                              timeMap["${titleList[index]}-minutes"] = value!
                                      .contains(".")
                                  ? int.parse(
                                      value.substring(0, value.indexOf(".")))
                                  : int.parse(value));
                        } else {
                          setState(
                              () => timeMap["${titleList[index]}-minutes"] = 0);
                        }
                      },
                      secondsValidator: (value) {
                        if ((titleList[index] == workTitle ||
                                titleList[index] == restTitle) &&
                            (value == null ||
                                value.isEmpty ||
                                int.parse(value) == 0)) {
                          return 'Enter time';
                        }
                        return null;
                      },
                      secondsOnSaved: (value) {
                        if (titleList[index] == repeatTitle) {
                          if (value != "") {
                            setState(() => repeat = value!.contains(".")
                                ? int.parse(
                                    value.substring(0, value.indexOf(".")))
                                : int.parse(value));
                          } else {
                            setState(() => repeat = 0);
                          }
                        } else {
                          if (value != "") {
                            setState(() =>
                                timeMap["${titleList[index]}-seconds"] = value!
                                        .contains(".")
                                    ? int.parse(
                                        value.substring(0, value.indexOf(".")))
                                    : int.parse(value));
                          } else {
                            setState(() =>
                                timeMap["${titleList[index]}-seconds"] = 0);
                          }
                        }
                      },
                      secondsOnChanged: (text) {
                        if (titleList[index] == repeatTitle) {
                          // setState(() {
                          if (text! != "") {
                            iterationsNotifier.value = int.parse(text);
                            print("Changed: ${iterationsNotifier.value}");
                          }
                          // });
                        }
                      },
                      minutesKey: minutesKey,
                      secondsKey: secondsKey,
                    ))
                : const Text(""),
          );
        });
  }

  Widget returnExpansionTile(
      Workout workoutArg, int index, ValueNotifier<int> iterationsNotifier) {
    return ExpansionTile(
      title: Text(timeTitles[index]),
      subtitle: Text(timeSubTitles[index]),
      leading: timeLeadingIcons[index],
      children: returnAdditionalTiles(workoutArg, index, iterationsNotifier),
    );
  }

  List<Widget> returnAdditionalTiles(
      Workout workoutArg, int index, ValueNotifier<int> iterationsNotifier) {
    List<Widget> tileList = [];
    for (int i = 0; i < additionalTimeTitles.length; i++) {
      tileList.add(returnTile(
          workoutArg,
          i,
          determinePrefilledTime(workoutArg, additionalTimeTitles[i]),
          additionalTimeTitles,
          additionalTimeSubTitles,
          additionalTimeLeadingIcons,
          additionalMinutesKeys[index],
          additionalSecondsKeys[index],
          additionalTimeTitles[i] == repeatTitle ||
                  additionalTimeTitles[i] == breakTitle
              ? iterationsNotifier
              : ValueNotifier(0)));
    }
    return tileList;
  }

  int determinePrefilledTime(Workout workoutArg, String title) {
    switch (title) {
      case workTitle:
        return workoutArg.id != "" ? workoutArg.workTime : -1;
      case restTitle:
        return workoutArg.id != "" ? workoutArg.restTime : -1;
      case getReadyTitle:
        return workoutArg.id != "" ? workoutArg.getReadyTime : 10;
      case warmUpTitle:
        return workoutArg.id != "" ? workoutArg.warmupTime : 0;
      case coolDownTitle:
        return workoutArg.id != "" ? workoutArg.cooldownTime : 0;
      case repeatTitle:
        return workoutArg.iterations;
      case breakTitle:
        return workoutArg.id != "" ? workoutArg.breakTime : 0;
      default:
        return 9;
    }
  }
}


// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:flutter/material.dart';
// import 'package:openhiit/create_workout/constants/set_timings_constants.dart';
// import 'package:openhiit/create_workout/helper_widgets/expansion_repeat_tile.dart';
// import '../workout_data_type/workout_type.dart';
// import './set_sounds.dart';
// import 'helper_widgets/number_input.dart';
// import 'helper_widgets/submit_button.dart';
// import 'helper_widgets/time_list_item.dart';
// import 'utils/utils.dart';

// class SetTimings extends StatefulWidget {
//   const SetTimings({super.key});

//   @override
//   State<SetTimings> createState() => _SetTimingsState();
// }

// // Define a corresponding State class.
// // This class holds the data related to the Form.
// class _SetTimingsState extends State<SetTimings> {
//   /// The global key for the form.
//   ///
//   final formKey = GlobalKey<FormState>();

//   int workMinutes = 0;
//   int workSeconds = 0;
//   int restMinutes = 0;
//   int restSeconds = 0;

//   int calcMinutes(int seconds) {
//     return (seconds - (seconds % 60)) ~/ 60;
//   }

//   int calcSeconds(int seconds) {
//     return (seconds % 60);
//   }

//   void submitTimings(Workout workout) async {
//     // Validate returns true if the form is valid, or false otherwise.
//     final form = formKey.currentState!;
//     if (form.validate()) {
//       form.save();

//       workout.workTime = (workMinutes * 60) + workSeconds;
//       workout.restTime = (restMinutes * 60) + restSeconds;
//       workout.breakTime = 0;
//       workout.warmupTime = 0;
//       workout.cooldownTime = 0;
//       workout.iterations = 0;

//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => const SetSounds(),
//           settings: RouteSettings(
//             arguments: workout,
//           ),
//         ),
//       );
//     }
//   }

//   // Widget returnCombinedForm(Workout workout) {
//   //   return SizedBox(
//   //       height: (MediaQuery.of(context).size.height * 10) / 12,
//   //       child: SingleChildScrollView(
//   //           child: Padding(
//   //         padding: const EdgeInsets.all(30),
//   //         child: Form(
//   //           key: formKey,
//   //           child: Column(
//   //             crossAxisAlignment: CrossAxisAlignment.start,
//   //             children: [
//   //               SizedBox(
//   //                 height: MediaQuery.of(context).size.height / 22,
//   //                 child: const AutoSizeText("Enter the work time:",
//   //                     maxFontSize: 50,
//   //                     minFontSize: 16,
//   //                     style: TextStyle(
//   //                         color: Color.fromARGB(255, 107, 107, 107),
//   //                         fontSize: 30)),
//   //               ),
//   //               Row(
//   //                 mainAxisAlignment: MainAxisAlignment.center,
//   //                 children: [
//   //                   NumberInput(
//   //                       numberInputKey: const Key('work-minutes'),
//   //                       numberValue: workout.workTime,
//   //                       formatter: (value) {
//   //                         int calculation = ((workout.workTime -
//   //                                     (workout.workTime % 60)) /
//   //                                 60)
//   //                             .round();
//   //                         if (calculation == 0) {
//   //                           return "";
//   //                         }
//   //                         return calculation;
//   //                       },
//   //                       validator: (value) {
//   //                         if (value == null || value.isEmpty) {
//   //                           return 'Enter time';
//   //                         }
//   //                         return null;
//   //                       },
//   //                       onSaved: (value) {
//   //                         setState(() {
//   //                           workMinutes = value!.contains(".")
//   //                               ? int.parse(
//   //                                   value.substring(0, value.indexOf(".")))
//   //                               : int.parse(value);
//   //                         });
//   //                       },
//   //                       unit: "m",
//   //                       min: 1,
//   //                       max: 99),
//   //                   NumberInput(
//   //                       numberInputKey: const Key('work-seconds'),
//   //                       numberValue: workout.workTime,
//   //                       formatter: (value) {
//   //                         return workout.workTime % 60;
//   //                       },
//   //                       validator: (value) {
//   //                         return null;
//   //                       },
//   //                       onSaved: (value) {
//   //                         if (value != "") {
//   //                           setState(() => workSeconds = value!.contains(".")
//   //                               ? int.parse(
//   //                                   value.substring(0, value.indexOf(".")))
//   //                               : int.parse(value));
//   //                         } else {
//   //                           setState(() => workSeconds = 0);
//   //                         }
//   //                       },
//   //                       unit: "s",
//   //                       min: 0,
//   //                       max: 59),
//   //                 ],
//   //               ),
//   //               const SizedBox(
//   //                 height: 30,
//   //               ),
//   //               SizedBox(
//   //                   height: MediaQuery.of(context).size.height / 22,
//   //                   child: const AutoSizeText("Enter the rest time:",
//   //                       maxFontSize: 50,
//   //                       minFontSize: 16,
//   //                       style: TextStyle(
//   //                           color: Color.fromARGB(255, 107, 107, 107),
//   //                           fontSize: 30))),
//   //               Row(
//   //                 mainAxisAlignment: MainAxisAlignment.center,
//   //                 children: [
//   //                   NumberInput(
//   //                       numberInputKey: const Key('rest-minutes'),
//   //                       numberValue: workout.restTime,
//   //                       formatter: (value) {
//   //                         int calculation =
//   //                             ((workout.restTime - (workout.restTime % 60)) /
//   //                                     60)
//   //                                 .round();
//   //                         if (calculation == 0) {
//   //                           return "";
//   //                         }
//   //                         return calculation;
//   //                       },
//   //                       validator: (value) {
//   //                         if (value == null || value.isEmpty) {
//   //                           return 'Enter time';
//   //                         }
//   //                         return null;
//   //                       },
//   //                       onSaved: (value) => setState(() => restMinutes = value!
//   //                               .contains(".")
//   //                           ? int.parse(value.substring(0, value.indexOf(".")))
//   //                           : int.parse(value)),
//   //                       unit: "m",
//   //                       min: 1,
//   //                       max: 99),
//   //                   NumberInput(
//   //                       numberInputKey: const Key('rest-seconds'),
//   //                       numberValue: workout.restTime,
//   //                       formatter: (value) {
//   //                         return workout.restTime % 60;
//   //                       },
//   //                       validator: (value) {
//   //                         return null;
//   //                       },
//   //                       onSaved: (value) {
//   //                         if (value != "") {
//   //                           setState(() => restSeconds = value!.contains(".")
//   //                               ? int.parse(
//   //                                   value.substring(0, value.indexOf(".")))
//   //                               : int.parse(value));
//   //                         } else {
//   //                           setState(() => restSeconds = 0);
//   //                         }
//   //                       },
//   //                       unit: "s",
//   //                       min: 0,
//   //                       max: 59),
//   //                 ],
//   //               ),
//   //             ],
//   //           ),
//   //         ),
//   //       )));
//   // }

//   // Widget returnMinutesSecondsForm(Workout workout) {
//   //   return SizedBox(
//   //       height: (MediaQuery.of(context).size.height * 10) / 12,
//   //       child: SingleChildScrollView(
//   //           child: Padding(
//   //         padding: const EdgeInsets.all(30),
//   //         child: Form(
//   //           key: formKey,
//   //           child: Column(
//   //             crossAxisAlignment: CrossAxisAlignment.start,
//   //             children: [
//   //               SizedBox(
//   //                 height: MediaQuery.of(context).size.height / 22,
//   //                 child: const AutoSizeText("Enter the work time:",
//   //                     maxFontSize: 50,
//   //                     minFontSize: 16,
//   //                     style: TextStyle(
//   //                         color: Color.fromARGB(255, 107, 107, 107),
//   //                         fontSize: 30)),
//   //               ),
//   //               Row(
//   //                 mainAxisAlignment: MainAxisAlignment.center,
//   //                 children: [
//   //                   NumberInput(
//   //                       numberInputKey: const Key('work-minutes'),
//   //                       numberValue: workout.workTime,
//   //                       formatter: (value) {
//   //                         int calculation = ((workout.workTime -
//   //                                     (workout.workTime % 60)) /
//   //                                 60)
//   //                             .round();
//   //                         if (calculation == 0) {
//   //                           return "";
//   //                         }
//   //                         return calculation;
//   //                       },
//   //                       validator: (value) {
//   //                         if (value == null || value.isEmpty) {
//   //                           return 'Enter time';
//   //                         }
//   //                         return null;
//   //                       },
//   //                       onSaved: (value) {
//   //                         setState(() {
//   //                           workMinutes = value!.contains(".")
//   //                               ? int.parse(
//   //                                   value.substring(0, value.indexOf(".")))
//   //                               : int.parse(value);
//   //                         });
//   //                       },
//   //                       unit: "m",
//   //                       min: 1,
//   //                       max: 99),
//   //                   NumberInput(
//   //                       numberInputKey: const Key('work-seconds'),
//   //                       numberValue: workout.workTime,
//   //                       formatter: (value) {
//   //                         return workout.workTime % 60;
//   //                       },
//   //                       validator: (value) {
//   //                         return null;
//   //                       },
//   //                       onSaved: (value) {
//   //                         if (value != "") {
//   //                           setState(() => workSeconds = value!.contains(".")
//   //                               ? int.parse(
//   //                                   value.substring(0, value.indexOf(".")))
//   //                               : int.parse(value));
//   //                         } else {
//   //                           setState(() => workSeconds = 0);
//   //                         }
//   //                       },
//   //                       unit: "s",
//   //                       min: 0,
//   //                       max: 59),
//   //                 ],
//   //               ),
//   //               const SizedBox(
//   //                 height: 30,
//   //               ),
//   //               SizedBox(
//   //                   height: MediaQuery.of(context).size.height / 22,
//   //                   child: const AutoSizeText("Enter the rest time:",
//   //                       maxFontSize: 50,
//   //                       minFontSize: 16,
//   //                       style: TextStyle(
//   //                           color: Color.fromARGB(255, 107, 107, 107),
//   //                           fontSize: 30))),
//   //               Row(
//   //                 mainAxisAlignment: MainAxisAlignment.center,
//   //                 children: [
//   //                   NumberInput(
//   //                       numberInputKey: const Key('rest-minutes'),
//   //                       numberValue: workout.restTime,
//   //                       formatter: (value) {
//   //                         int calculation =
//   //                             ((workout.restTime - (workout.restTime % 60)) /
//   //                                     60)
//   //                                 .round();
//   //                         if (calculation == 0) {
//   //                           return "";
//   //                         }
//   //                         return calculation;
//   //                       },
//   //                       validator: (value) {
//   //                         if (value == null || value.isEmpty) {
//   //                           return 'Enter time';
//   //                         }
//   //                         return null;
//   //                       },
//   //                       onSaved: (value) => setState(() => restMinutes = value!
//   //                               .contains(".")
//   //                           ? int.parse(value.substring(0, value.indexOf(".")))
//   //                           : int.parse(value)),
//   //                       unit: "m",
//   //                       min: 1,
//   //                       max: 99),
//   //                   NumberInput(
//   //                       numberInputKey: const Key('rest-seconds'),
//   //                       numberValue: workout.restTime,
//   //                       formatter: (value) {
//   //                         return workout.restTime % 60;
//   //                       },
//   //                       validator: (value) {
//   //                         return null;
//   //                       },
//   //                       onSaved: (value) {
//   //                         if (value != "") {
//   //                           setState(() => restSeconds = value!.contains(".")
//   //                               ? int.parse(
//   //                                   value.substring(0, value.indexOf(".")))
//   //                               : int.parse(value));
//   //                         } else {
//   //                           setState(() => restSeconds = 0);
//   //                         }
//   //                       },
//   //                       unit: "s",
//   //                       min: 0,
//   //                       max: 59),
//   //                 ],
//   //               ),
//   //             ],
//   //           ),
//   //         ),
//   //       )));
//   // }

//   // Widget returnSecondsForm(Workout workout) {
//   //   return SizedBox(
//   //       height: (MediaQuery.of(context).size.height * 10) / 12,
//   //       child: SingleChildScrollView(
//   //           child: Padding(
//   //         padding: const EdgeInsets.all(30),
//   //         child: Form(
//   //           key: formKey,
//   //           child: Column(
//   //             crossAxisAlignment: CrossAxisAlignment.start,
//   //             children: [
//   //               const Padding(
//   //                   padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
//   //                   child: Text("Enter the work time:",
//   //                       style: TextStyle(
//   //                           color: Color.fromARGB(255, 107, 107, 107),
//   //                           fontSize: 18))),
//   //               Row(
//   //                 mainAxisAlignment: MainAxisAlignment.center,
//   //                 children: [
//   //                   NumberInput(
//   //                       numberInputKey: const Key('work-seconds'),
//   //                       numberValue: workout.workTime,
//   //                       formatter: (value) {
//   //                         return workout.workTime;
//   //                       },
//   //                       validator: (value) {
//   //                         if (value == null || value.isEmpty) {
//   //                           return 'Enter time';
//   //                         }
//   //                         return null;
//   //                       },
//   //                       onSaved: (value) {
//   //                         if (value != "") {
//   //                           setState(() => workSeconds = value!.contains(".")
//   //                               ? int.parse(
//   //                                   value.substring(0, value.indexOf(".")))
//   //                               : int.parse(value));
//   //                         } else {
//   //                           setState(() => workSeconds = 0);
//   //                         }
//   //                       },
//   //                       unit: "s",
//   //                       min: 1,
//   //                       max: 999),
//   //                 ],
//   //               ),
//   //               const Padding(
//   //                   padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
//   //                   child: Text("Enter the rest time:",
//   //                       style: TextStyle(
//   //                           color: Color.fromARGB(255, 107, 107, 107),
//   //                           fontSize: 18))),
//   //               Row(
//   //                 mainAxisAlignment: MainAxisAlignment.center,
//   //                 children: [
//   //                   NumberInput(
//   //                       numberInputKey: const Key('rest-seconds'),
//   //                       numberValue: workout.restTime,
//   //                       formatter: (value) {
//   //                         return workout.restTime;
//   //                       },
//   //                       validator: (value) {
//   //                         if (value == null || value.isEmpty) {
//   //                           return 'Enter time';
//   //                         }
//   //                         return null;
//   //                       },
//   //                       onSaved: (value) {
//   //                         if (value != "") {
//   //                           setState(() => restSeconds = value!.contains(".")
//   //                               ? int.parse(
//   //                                   value.substring(0, value.indexOf(".")))
//   //                               : int.parse(value));
//   //                         } else {
//   //                           setState(() => restSeconds = 0);
//   //                         }
//   //                       },
//   //                       unit: "s",
//   //                       min: 1,
//   //                       max: 999),
//   //                 ],
//   //               ),
//   //             ],
//   //           ),
//   //         ),
//   //       )));
//   // }

//   @override
//   Widget build(BuildContext context) {
//     Workout workout = ModalRoute.of(context)!.settings.arguments as Workout;

//     final List<TimeListItem> items = List<TimeListItem>.generate(
//       timeTitles.length,
//       (i) => TimeMessageItem(timeTitles[i], timeSubTitles[i], workout),
//     );

//     return Scaffold(
//         appBar: AppBar(
//           title: const Text("New Interval Timer"),
//         ),
//         bottomSheet: SubmitButton(
//           text: "Submit",
//           color: const Color.fromARGB(255, 58, 165, 255),
//           onTap: () {
//             submitTimings(workout);
//           },
//         ),
//         body: ListView.builder(
//           // Let the ListView know how many items it needs to build.
//           itemCount: items.length + 1,
//           // Provide a builder function. This is where the magic happens.
//           // Convert each item into a widget based on the type of item it is.
//           itemBuilder: (context, index) {
//             if (index > 1) {
//               return ExpansionRepeatTileClass();
//             }

//             final item = items[index];

//             return ListTile(
//               title: item.buildTitle(context),
//               subtitle: item.buildSubtitle(context),
//               leading: index < timeLeadingIcons.length
//                   ? Icon(timeLeadingIcons[index])
//                   : const Text(""),
//               trailing: buildTrailingWidget(timeTitles[index], workout),
//             );
//           },
//         ));
//   }

//   Widget buildTrailingWidget(String title, Workout workout) {
//     int numberValue = 0, min = 0, max = 0;
//     Function onSaved, validator;
//     String numberInputKey;


//     if (workout.showMinutes == 1) {

//       switch (title) {
//         case workTitle:
//           numberValue = -1;
//           onSaved =
//           validator =
//           break;
//         case restTitle:
//           numberValue = -1;
//           onSaved =
//           validator =
//           break;
//       }

//       return SizedBox(
//         width: 120,
//         child: Row(
//           children: [
//             NumberInput(
//                 numberValue: 0,
//                 formatter: secondsFormatter,
//                 onSaved: (value) {},
//                 validator: (value) {},
//                 unit: "m",
//                 min: 0,
//                 max: 99,
//                 numberInputKey: const Key('getready-seconds')),
//             NumberInput(
//                 numberValue: numberValue,
//                 formatter: secondsFormatter,
//                 onSaved: (value) {},
//                 validator: (value) {},
//                 unit: "s",
//                 min: 0,
//                 max: 59,
//                 numberInputKey: const Key('getready-seconds'))
//           ],
//         ),
//       );
//     } else {



//       return NumberInput(
//           numberValue: numberValue,
//           formatter: secondsFormatter,
//           onSaved: (value) {},
//           validator: (value) {},
//           unit: "s",
//           min: 0,
//           max: 999,
//           numberInputKey: const Key('getready-seconds'));
//     }
//   }
// }
