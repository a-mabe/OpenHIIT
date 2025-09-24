import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:openhiit/core/logs/logs.dart';
import 'package:openhiit/core/providers/timer_creation_provider/timer_creation_provider.dart';
import 'package:openhiit/features/edit_timer/ui/widgets/start_save_toggle.dart';
import 'package:openhiit/features/edit_timer/ui/widgets/tabs/general_tab/constants.dart';
import 'package:provider/provider.dart';
import 'package:unit_number_input/unit_number_input.dart';

class GeneralTab extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController activeIntervalsController;
  final Map<String, UnitNumberInputController> timeSettingsControllers;
  final ValueChanged<StartSaveState> onEdited;

  final bool editing;

  GeneralTab(
      {super.key,
      required this.nameController,
      required this.activeIntervalsController,
      required this.timeSettingsControllers,
      required this.onEdited,
      this.editing = false});

  final logger = Logger(
    printer: JsonLogPrinter('GeneralTab'),
  );

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TimerCreationProvider>();

    return SingleChildScrollView(
        child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
          child: TextFormField(
            key: const Key("timer-name"),
            controller: nameController,
            style: const TextStyle(fontSize: 24),
            decoration: InputDecoration(
              hintText: "Add title",
              border: InputBorder.none,
              contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            ),
            onChanged: (value) {
              provider.setTimerName(value);
              onEdited(StartSaveState.save);
              logger.d("Timer name changed to $value");
            },
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Name cannot be empty';
              }
              return null;
            },
          ),
        ),
        ListTile(
          key: const Key("active-intervals"),
          title: const Text('Active Intervals'),
          subtitle: Text('# of works intervals'),
          leading: const Icon(Icons.flag),
          trailing: SizedBox(
            width: 80,
            child: TextFormField(
              controller: activeIntervalsController,
              decoration: inputDecoration,
              maxLength: 3,
              style: const TextStyle(fontSize: 30),
              textAlign: TextAlign.end,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '';
                }
                return null;
              },
              onChanged: (value) {
                provider.setActiveIntervals(int.tryParse(value) ?? 1);
                onEdited(StartSaveState.save);
                logger.d("Active intervals changed to $value");
              },
            ),
          ),
        ),
        Divider(),
        ListTile(
          key: const Key("work-time"),
          title: const Text('Work'),
          subtitle: Text('Required'),
          leading: const Icon(Icons.fitness_center),
          trailing: FittedBox(
            fit: BoxFit.contain,
            child: UnitNumberInput(
              controller: timeSettingsControllers['work']!,
              prefill: editing,
              enableMinutesToggle: false,
              onChanged: (value) {
                provider.setTimerTimeSettingPart(workTime: value);
                onEdited(StartSaveState.save);
                logger.d("Work time changed to $value");
              },
            ),
          ),
        ),
        ListTile(
          key: const Key("rest-time"),
          title: const Text('Rest'),
          subtitle: Text('Required'),
          leading: const Icon(Icons.timer),
          trailing: FittedBox(
            fit: BoxFit.contain,
            child: UnitNumberInput(
              controller: timeSettingsControllers['rest']!,
              prefill: editing,
              enableMinutesToggle: false,
              onChanged: (value) {
                provider.setTimerTimeSettingPart(restTime: value);
                onEdited(StartSaveState.save);
                logger.d("Rest time changed to $value");
              },
            ),
          ),
        ),
        Divider(),
        ListTile(
          key: const Key("get-ready"),
          title: const Text('Get ready'),
          subtitle: Text('Optional, default 10s'),
          leading: const Icon(Icons.flag),
          trailing: FittedBox(
            fit: BoxFit.contain,
            child: UnitNumberInput(
              controller: timeSettingsControllers['get-ready']!,
              prefill: editing,
              enableMinutesToggle: false,
              valueRequired: false,
              onChanged: (value) {
                provider.setTimerTimeSettingPart(getReadyTime: value);
                onEdited(StartSaveState.save);
                logger.d("Get ready time changed to $value");
              },
            ),
          ),
        ),
        ListTile(
          key: const Key("warm-up"),
          title: const Text('Warm-up'),
          subtitle: Text('Required'),
          leading: const Icon(Icons.emoji_people),
          trailing: FittedBox(
            fit: BoxFit.contain,
            child: UnitNumberInput(
              controller: timeSettingsControllers['warm-up']!,
              prefill: editing,
              enableMinutesToggle: false,
              valueRequired: false,
              onChanged: (value) {
                provider.setTimerTimeSettingPart(warmupTime: value);
                onEdited(StartSaveState.save);
                logger.d("Warm-up time changed to $value");
              },
            ),
          ),
        ),
        ListTile(
          key: const Key("cool-down"),
          title: const Text('Cool-down'),
          subtitle: Text('Required'),
          leading: const Icon(Icons.ac_unit),
          trailing: FittedBox(
            fit: BoxFit.contain,
            child: UnitNumberInput(
              controller: timeSettingsControllers['cool-down']!,
              prefill: editing,
              enableMinutesToggle: false,
              valueRequired: false,
              onChanged: (value) {
                provider.setTimerTimeSettingPart(cooldownTime: value);
                onEdited(StartSaveState.save);
                logger.d("Cool-down time changed to $value");
              },
            ),
          ),
        ),
        ListTile(
          key: const Key("restarts"),
          title: const Text('Restarts'),
          subtitle: Text('Required'),
          leading: const Icon(Icons.replay),
          trailing: FittedBox(
            fit: BoxFit.contain,
            child: UnitNumberInput(
              controller: timeSettingsControllers['restarts']!,
              prefill: editing,
              enableMinutesToggle: false,
              valueRequired: false,
              onChanged: (value) {
                provider.setTimerTimeSettingPart(restarts: value);
                onEdited(StartSaveState.save);
                logger.d("Restarts time changed to $value");

                // If restarts = 0, force breakTime = 0
                if (value == 0) {
                  provider.setTimerTimeSettingPart(breakTime: 0);
                  timeSettingsControllers['break']?.setTotalSeconds(0);
                  logger.d("Break time forced to 0 because restarts = 0");
                }
              },
            ),
          ),
        ),
        ListTile(
          key: const Key("break"),
          enabled: provider.breakEnabled,
          title: const Text('Break'),
          subtitle: Text('Required'),
          leading: const Icon(Icons.snooze),
          trailing: FittedBox(
            fit: BoxFit.contain,
            child: UnitNumberInput(
              controller: timeSettingsControllers['break']!,
              enabled: provider.breakEnabled,
              prefill: editing,
              enableMinutesToggle: false,
              valueRequired: false,
              onChanged: (value) {
                provider.setTimerTimeSettingPart(breakTime: value);
                onEdited(StartSaveState.save);
                logger.d("Break time changed to $value");
              },
            ),
          ),
        ),
      ],
    ));
  }
}
