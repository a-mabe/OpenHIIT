import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:openhiit/create_workout/constants/set_timings_constants.dart';
import './form_picker_widgets/time_input_trailing.dart';
import '../workout_data_type/workout_type.dart';
import 'main_widgets/submit_button.dart';
import './form_picker_widgets/time_list_item.dart';
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

  bool hasExpanded = false;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Workout workout = ModalRoute.of(context)!.settings.arguments as Workout;

    print("here it is");
    print(workout);

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

  void submitTimings(Workout workoutArg, GlobalKey<FormState> formKey) {
    // Validate returns true if the form is valid, or false otherwise.
    final form = formKey.currentState!;
    if (form.validate()) {
      form.save();

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
          return TimeListItem(
            titleText: titleList[index],
            subtitleText: subtitleList[index],
            enabled: titleList[index] == breakTitle
                ? (notifierMap[breakTitle]!.value > 0 ? true : false)
                : true,
            leadingWidget: iconList[index],
            trailingWidget: titleList[index] != additionalConfigTitle
                ? Visibility(
                    visible: titleList[index] == breakTitle
                        ? (notifierMap[breakTitle]!.value > 0 ? true : false)
                        : true,
                    child: TimeInputTrailing(
                      title: titleList[index],
                      minutesController: TextEditingController(),
                      secondsController: TextEditingController(),
                      unit: titleList[index] == repeatTitle ? "time(s)" : "s",
                      widgetWidth: (workoutArg.showMinutes == 1 ||
                              titleList[index] == repeatTitle)
                          ? 150
                          : 80,
                      showMinutes: workoutArg.showMinutes,
                      timeInSeconds: time,
                      minutesValidator: (value) {
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
                          if (text! != "") {
                            notifierMap[breakTitle]!.value = int.parse(text);
                          }
                        }
                      },
                      minutesKey: minutesKey,
                      secondsKey: secondsKey,
                    ))
                : const Text(""),
          );
        });
  }

  Widget returnExpansionTile(Workout workoutArg, int index,
      Map<String, ValueNotifier<int>> notifierMap) {
    return ExpansionTile(
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
          additionalMinutesKeys[index],
          additionalSecondsKeys[index],
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
