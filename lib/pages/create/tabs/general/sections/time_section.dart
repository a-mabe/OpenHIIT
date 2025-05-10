import 'package:flutter/material.dart';
import 'package:openhiit/pages/create/tabs/general/constants/set_timings_constants.dart';
import 'package:openhiit/pages/create/tabs/general/sections/rows/time_row.dart';
import 'package:openhiit/providers/timer_creation_notifier.dart';
import 'package:provider/provider.dart';

class TimeSection extends StatefulWidget {
  const TimeSection({super.key});

  @override
  TimeSectionState createState() => TimeSectionState();
}

class TimeSectionState extends State<TimeSection> {
  Map<String, TextEditingController> controllerMap = {
    for (var key in allKeys.where((key) => key != repeatKey))
      "$key-minutes": TextEditingController(),
    for (var key in allKeys.where((key) => key != repeatKey))
      "$key-seconds": TextEditingController(),
    repeatKey: TextEditingController(),
  };

  @override
  void initState() {
    super.initState();

    TimerCreationNotifier timerCreationNotifier =
        Provider.of<TimerCreationNotifier>(context, listen: false);

    controllerMap.forEach((key, controller) {
      final title = key.split("-")[0];
      final isMinutes = key.contains("-minutes");
      final isSeconds = key.contains("-seconds");

      if (key == repeatKey) {
        controller.text =
            timerCreationNotifier.timerDraft.timeSettings.restarts.toString();
      } else if (isMinutes || isSeconds) {
        final time = timerCreationNotifier.timerDraft.timeSettings
                .toJson()["${title}Time"] ??
            0;
        final value = isMinutes
            ? (timerCreationNotifier.timerDraft.showMinutes == 1
                ? time ~/ 60
                : "")
            : (timerCreationNotifier.timerDraft.showMinutes == 1
                ? time % 60
                : time);
        if ((key.contains(workKey) || key.contains(restKey)) && value == 0) {
          return;
        }
        controller.text = value.toString();
      }
    });
  }

  @override
  void dispose() {
    for (var controller in controllerMap.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timerCreationNotifier = Provider.of<TimerCreationNotifier>(context);

    return Column(
      children: [
        TimeRow(
          title: workTitle,
          subtitle: "Required",
          showMinutes: timerCreationNotifier.timerDraft.showMinutes,
          leadingIcon: Icons.fitness_center,
          minutesController: controllerMap["$workKey-minutes"]!,
          secondsController: controllerMap["$workKey-seconds"]!,
          minutesOnSaved: (value) {
            // Do nothing, save via the controller and secondsOnSaved
          },
          secondsOnSaved: (value) {
            timerCreationNotifier.timerDraft.timeSettings.workTime =
                (int.tryParse(value!) ?? 0) +
                    ((int.tryParse(controllerMap["$workKey-minutes"]!.text) ??
                            0)) *
                        60;
          },
          minutesValidator: (value) {
            if (value == "" &&
                (timerCreationNotifier.timerDraft.showMinutes != 1 ||
                    (controllerMap["$workKey-seconds"]?.text.isEmpty ??
                        true))) {
              return "";
            }
            return null;
          },
          secondsValidator: (value) {
            if (value == "" &&
                (timerCreationNotifier.timerDraft.showMinutes != 1 ||
                    (controllerMap["$workKey-minutes"]?.text.isEmpty ??
                        true))) {
              return "";
            }
            return null;
          },
        ),
        TimeRow(
          title: restTitle,
          subtitle: "Required",
          showMinutes: timerCreationNotifier.timerDraft.showMinutes,
          leadingIcon: Icons.pause,
          minutesController: controllerMap["$restKey-minutes"]!,
          secondsController: controllerMap["$restKey-seconds"]!,
          minutesOnSaved: (value) {
            // Do nothing, save via the controller and secondsOnSaved
          },
          secondsOnSaved: (value) {
            timerCreationNotifier.timerDraft.timeSettings.restTime =
                (int.tryParse(value!) ?? 0) +
                    ((int.tryParse(controllerMap["$restKey-minutes"]!.text) ??
                            0)) *
                        60;
          },
          minutesValidator: (value) {
            if (value == "" &&
                (timerCreationNotifier.timerDraft.showMinutes != 1 ||
                    (controllerMap["$workKey-seconds"]?.text.isEmpty ??
                        true))) {
              return "";
            }
            return null;
          },
          secondsValidator: (value) {
            if (value == "" &&
                (timerCreationNotifier.timerDraft.showMinutes != 1 ||
                    (controllerMap["$workKey-minutes"]?.text.isEmpty ??
                        true))) {
              return "";
            }
            return null;
          },
        ),
        Divider(
          thickness: 1,
          color: Colors.grey,
        ),
        TimeRow(
          title: getReadyTitle,
          subtitle: "Optional",
          showMinutes: timerCreationNotifier.timerDraft.showMinutes,
          leadingIcon: Icons.flag,
          minutesController: controllerMap["$getReadyKey-minutes"]!,
          secondsController: controllerMap["$getReadyKey-seconds"]!,
          minutesOnSaved: (value) {
            // Do nothing, save via the controller and secondsOnSaved
          },
          secondsOnSaved: (value) {
            timerCreationNotifier
                .timerDraft.timeSettings.getReadyTime = (int.tryParse(value!) ??
                    0) +
                ((int.tryParse(controllerMap["$getReadyKey-minutes"]!.text) ??
                        0)) *
                    60;
          },
          minutesValidator: (value) {
            return null;
          },
          secondsValidator: (value) {
            return null;
          },
        ),
        TimeRow(
          title: warmUpTitle,
          subtitle: "Optional",
          showMinutes: timerCreationNotifier.timerDraft.showMinutes,
          leadingIcon: Icons.emoji_people,
          minutesController: controllerMap["$warmUpKey-minutes"]!,
          secondsController: controllerMap["$warmUpKey-seconds"]!,
          minutesOnSaved: (value) {
            // Do nothing, save via the controller and secondsOnSaved
          },
          secondsOnSaved: (value) {
            timerCreationNotifier.timerDraft.timeSettings.warmupTime =
                (int.tryParse(value!) ?? 0) +
                    ((int.tryParse(controllerMap["$warmUpKey-minutes"]!.text) ??
                            0)) *
                        60;
          },
          minutesValidator: (value) {
            return null;
          },
          secondsValidator: (value) {
            return null;
          },
        ),
        TimeRow(
          title: coolDownTitle,
          subtitle: "Optional",
          showMinutes: timerCreationNotifier.timerDraft.showMinutes,
          leadingIcon: Icons.ac_unit,
          minutesController: controllerMap["$coolDownKey-minutes"]!,
          secondsController: controllerMap["$coolDownKey-seconds"]!,
          minutesOnSaved: (value) {
            // Do nothing, save via the controller and secondsOnSaved
          },
          secondsOnSaved: (value) {
            timerCreationNotifier
                .timerDraft.timeSettings.cooldownTime = (int.tryParse(value!) ??
                    0) +
                ((int.tryParse(controllerMap["$coolDownKey-minutes"]!.text) ??
                        0)) *
                    60;
          },
          minutesValidator: (value) {
            return null;
          },
          secondsValidator: (value) {
            return null;
          },
        ),
        TimeRow(
          title: repeatTitle,
          subtitle: "Auto restart",
          showMinutes: 0,
          leadingIcon: Icons.replay,
          unit: "",
          secondsController: controllerMap[repeatKey]!,
          minutesOnSaved: (value) {
            // Do nothing, save via the controller and secondsOnSaved
          },
          secondsOnSaved: (value) {
            timerCreationNotifier.timerDraft.timeSettings.restarts =
                (int.tryParse(value!) ?? 0);
          },
          minutesValidator: (value) {
            return null;
          },
          secondsValidator: (value) {
            return null;
          },
        ),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: controllerMap[repeatKey]!,
          builder: (context, value, child) {
            final repeat = int.tryParse(value.text) ?? 0;
            return TimeRow(
              title: breakTitle,
              subtitle: "Optional, between restarts",
              showMinutes: timerCreationNotifier.timerDraft.showMinutes,
              enabled: repeat > 0,
              leadingIcon: Icons.snooze,
              minutesController: controllerMap["$breakKey-minutes"]!,
              secondsController: controllerMap["$breakKey-seconds"]!,
              minutesOnSaved: (value) {
                // Do nothing
              },
              secondsOnSaved: (value) {
                timerCreationNotifier.timerDraft.timeSettings
                    .breakTime = (int.tryParse(value!) ??
                        0) +
                    ((int.tryParse(controllerMap["$breakKey-minutes"]!.text) ??
                            0)) *
                        60;
              },
              minutesValidator: (value) {
                return null;
              },
              secondsValidator: (value) {
                return null;
              },
            );
          },
        ),
      ],
    );
  }
}
