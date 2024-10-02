import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:openhiit/pages/set_timings/constants/set_timings_constants.dart';
import 'widgets/time_input_trailing.dart';
import '../../models/workout_type.dart';
import '../../widgets/form_widgets/submit_button.dart';
import 'widgets/time_list_item.dart';
import '../set_sounds/set_sounds.dart';

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
    "$workTitle-minutes": 0,
    "$workTitle-seconds": 0,
    "$restTitle-minutes": 0,
    "$restTitle-seconds": 0,
    "$warmUpTitle-minutes": 0,
    "$warmUpTitle-seconds": 0,
    "$coolDownTitle-minutes": 0,
    "$coolDownTitle-seconds": 0,
    "$breakTitle-minutes": 0,
    "$breakTitle-seconds": 0,
    "$getReadyTitle-minutes": 0,
    "$getReadyTitle-seconds": 0,
  };

  Map<String, TextEditingController> controllerMap = {
    "$workTitle-minutes": TextEditingController(),
    "$workTitle-seconds": TextEditingController(),
    "$restTitle-minutes": TextEditingController(),
    "$restTitle-seconds": TextEditingController(),
    "$warmUpTitle-minutes": TextEditingController(),
    "$warmUpTitle-seconds": TextEditingController(),
    "$coolDownTitle-minutes": TextEditingController(),
    "$coolDownTitle-seconds": TextEditingController(),
    "$breakTitle-minutes": TextEditingController(),
    "$breakTitle-seconds": TextEditingController(),
    "$getReadyTitle-minutes": TextEditingController(),
    "$getReadyTitle-seconds": TextEditingController(),
  };

  void addListeners() {
    for (String key in controllerMap.keys) {
      controllerMap[key]!.addListener(() {
        controllerListener(key, controllerMap[key]!);
      });
    }
  }

  Map<String, FocusNode> focusMap = {
    "$workTitle-minute": FocusNode(),
    "$workTitle-second": FocusNode(),
    "$restTitle-minute": FocusNode(),
    "$restTitle-second": FocusNode(),
    "$warmUpTitle-minute": FocusNode(),
    "$warmUpTitle-second": FocusNode(),
    "$coolDownTitle-minute": FocusNode(),
    "$coolDownTitle-second": FocusNode(),
    "$breakTitle-minute": FocusNode(),
    "$breakTitle-second": FocusNode(),
    "$getReadyTitle-minute": FocusNode(),
    "$getReadyTitle-second": FocusNode(),
    "$repeatTitle-minute": FocusNode(),
    "$repeatTitle-second": FocusNode(),
  };

  int repeat = 0;

  bool hasExpanded = false;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Workout workout = ModalRoute.of(context)!.settings.arguments as Workout;

    addListeners();

    logger.i(
        "Loading workout object for creation/editing: ${workout.toString()}");

    Map<String, ValueNotifier<int>> notifierMap = {
      "Work": ValueNotifier(workout.workTime),
      "Rest": ValueNotifier(workout.restTime),
      "Warm-up": ValueNotifier(workout.warmupTime),
      "Cool down": ValueNotifier(workout.cooldownTime),
      "Restart": ValueNotifier(workout.iterations),
      "Break": ValueNotifier(workout.iterations),
      "Get ready": ValueNotifier(workout.getReadyTime)
    };

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
                child: SingleChildScrollView(
                  child: Column(
                      children: List<Widget>.generate(
                          timeTitles.length,
                          (int index) =>
                              determineTile(workout, index, notifierMap))),
                ))));
  }

  void controllerListener(String title, TextEditingController controller) {
    controller.addListener(() {
      if (controller.text != "") {
        timeMap[title] = int.parse(controller.text);
      } else {
        timeMap[title] = 0;
      }
    });
  }

  void submitTimings(Workout workoutArg, GlobalKey<FormState> formKey) {
    // Validate returns true if the form is valid, or false otherwise.
    final form = formKey.currentState!;
    if (form.validate()) {
      form.save();

      logger.i("Form submitted.");

      workoutArg.workTime = (timeMap["$workTitle-minutes"]! * 60) +
          timeMap["$workTitle-seconds"]!;
      workoutArg.restTime = (timeMap["$restTitle-minutes"]! * 60) +
          timeMap["$restTitle-seconds"]!;

      if (hasExpanded) {
        workoutArg.getReadyTime = (timeMap["$getReadyTitle-minutes"]! * 60) +
            timeMap["$getReadyTitle-seconds"]!;
        workoutArg.warmupTime = (timeMap["$warmUpTitle-minutes"]! * 60) +
            timeMap["$warmUpTitle-seconds"]!;
        workoutArg.cooldownTime = (timeMap["$coolDownTitle-minutes"]! * 60) +
            timeMap["$coolDownTitle-seconds"]!;
        workoutArg.breakTime = (timeMap["$breakTitle-minutes"]! * 60) +
            timeMap["$breakTitle-seconds"]!;
        workoutArg.iterations = repeat;
      }

      logger.i("Saving workout: ${workoutArg.toString()}");

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

  Widget determineTile(Workout workoutArg, int index,
      Map<String, ValueNotifier<int>> notifierMap) {
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
            notifierMap);
      case 2:
        return returnExpansionTile(workoutArg, index, notifierMap);
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
      Map<String, ValueNotifier<int>> notifierMap) {
    return ValueListenableBuilder(
        valueListenable: (titleList[index] == breakTitle)
            ? notifierMap[breakTitle]!
            : notifierMap[titleList[index]]!,
        builder: (BuildContext context, int val, Widget? child) {
          return GestureDetector(
              onTap: () {
                if (workoutArg.showMinutes == 1) {
                  if (focusMap["${titleList[index]}-minute"]!.hasFocus) {
                    focusMap["${titleList[index]}-second"]!.requestFocus();
                  } else {
                    focusMap["${titleList[index]}-minute"]!.requestFocus();
                  }
                } else {
                  focusMap["${titleList[index]}-second"]!.requestFocus();
                }
              },
              child: TimeListItem(
                titleText: titleList[index],
                subtitleText: subtitleList[index],
                enabled: titleList[index] == breakTitle
                    ? (notifierMap[breakTitle]!.value > 0 ? true : false)
                    : true,
                leadingWidget: iconList[index],
                trailingWidget: titleList[index] != additionalConfigTitle
                    ? Visibility(
                        visible: titleList[index] == breakTitle
                            ? (notifierMap[breakTitle]!.value > 0
                                ? true
                                : false)
                            : true,
                        child: TimeInputTrailing(
                          title: titleList[index],
                          minuteFocusNode:
                              focusMap["${titleList[index]}-minute"],
                          secondFocusNode:
                              focusMap["${titleList[index]}-second"],
                          minutesController:
                              controllerMap["${titleList[index]}-minutes"],
                          secondsController:
                              controllerMap["${titleList[index]}-seconds"],
                          unit:
                              titleList[index] == repeatTitle ? "time(s)" : "s",
                          widgetWidth: (workoutArg.showMinutes == 1 ||
                                  titleList[index] == repeatTitle)
                              ? 185
                              : 80,
                          showMinutes: workoutArg.showMinutes,
                          timeInSeconds: time,
                          minutesValidator: (value) {
                            return null;
                          },
                          minutesOnSaved: (value) {
                            if (value != "") {
                              setState(() =>
                                  timeMap["${titleList[index]}-minutes"] =
                                      value!.contains(".")
                                          ? int.parse(value.substring(
                                              0, value.indexOf(".")))
                                          : int.parse(value));
                            } else {
                              setState(() =>
                                  timeMap["${titleList[index]}-minutes"] = 0);
                            }
                          },
                          secondsValidator: (value) {
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
                                    timeMap["${titleList[index]}-seconds"] =
                                        value!.contains(".")
                                            ? int.parse(value.substring(
                                                0, value.indexOf(".")))
                                            : int.parse(value));
                              } else {
                                setState(() =>
                                    timeMap["${titleList[index]}-seconds"] = 0);
                              }
                            }
                          },
                          secondsOnChanged: (text) {
                            if (titleList[index] == repeatTitle) {
                              if (text! != "") {
                                notifierMap[breakTitle]!.value =
                                    int.parse(text);
                              }
                            }
                          },
                          minutesKey: minutesKey,
                          secondsKey: secondsKey,
                        ))
                    : const Text(""),
              ));
        });
  }

  Widget returnExpansionTile(Workout workoutArg, int index,
      Map<String, ValueNotifier<int>> notifierMap) {
    return ExpansionTile(
      maintainState: true,
      title: Text(timeTitles[index]),
      subtitle: Text(timeSubTitles[index]),
      leading: timeLeadingIcons[index],
      children: returnAdditionalTiles(workoutArg, index, notifierMap),
      onExpansionChanged: (expanded) {
        hasExpanded = true;
      },
    );
  }

  List<Widget> returnAdditionalTiles(Workout workoutArg, int index,
      Map<String, ValueNotifier<int>> notifierMap) {
    List<Widget> tileList = [];
    for (int i = 0; i < additionalTimeTitles.length; i++) {
      tileList.add(returnTile(
          workoutArg,
          i,
          determinePrefilledTime(workoutArg, additionalTimeTitles[i]),
          additionalTimeTitles,
          additionalTimeSubTitles,
          additionalTimeLeadingIcons,
          additionalMinutesKeys[i],
          additionalSecondsKeys[i],
          notifierMap));
    }

    return tileList;
  }

  int determinePrefilledTime(Workout workoutArg, String title) {
    switch (title) {
      case workTitle:
        return workoutArg.workTime != 0 ? workoutArg.workTime : -1;
      case restTitle:
        return workoutArg.restTime != 0 ? workoutArg.restTime : -1;
      case getReadyTitle:
        return workoutArg.getReadyTime != 10 ? workoutArg.getReadyTime : 10;
      case warmUpTitle:
        return workoutArg.warmupTime != 0 ? workoutArg.warmupTime : 0;
      case coolDownTitle:
        return workoutArg.cooldownTime != 0 ? workoutArg.cooldownTime : 0;
      case repeatTitle:
        return workoutArg.iterations;
      case breakTitle:
        return workoutArg.breakTime != 0 ? workoutArg.breakTime : 0;
      default:
        return 9;
    }
  }
}
