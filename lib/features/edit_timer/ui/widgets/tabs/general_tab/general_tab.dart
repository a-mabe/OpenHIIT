import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:openhiit/core/logs/logs.dart';
import 'package:openhiit/core/providers/timer_creation_provider/timer_creation_provider.dart';
import 'package:openhiit/features/edit_timer/ui/widgets/start_save_toggle.dart';
import 'package:openhiit/features/edit_timer/ui/widgets/tabs/general_tab/constants.dart';
import 'package:provider/provider.dart';
import 'package:unit_number_input/unit_number_input.dart';

class GeneralTab extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController activeIntervalsController;
  final TextEditingController restartsController;
  final Map<String, UnitNumberInputController> timeSettingsControllers;
  final ValueChanged<StartSaveState> onEdited;
  final ValueChanged<bool> onUnitToggle;
  final ScrollController scrollController;

  final bool editing;

  GeneralTab(
      {super.key,
      required this.nameController,
      required this.activeIntervalsController,
      required this.restartsController,
      required this.timeSettingsControllers,
      required this.onEdited,
      required this.onUnitToggle,
      required this.scrollController,
      this.editing = false});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TimerCreationProvider>();

    return SingleChildScrollView(
        controller: scrollController,
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: TextFormField(
                key: const Key("timer-name"),
                controller: nameController,
                textCapitalization: TextCapitalization.words,
                style: const TextStyle(fontSize: 24),
                decoration: InputDecoration(
                  hintText: "Add title",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                ),
                onChanged: (value) {
                  provider.setTimerName(value);
                  onEdited(StartSaveState.save);
                  Log.debug("Timer name changed to $value");
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
              key: const Key("color-picker"),
              title: const Text('Color'),
              leading: const Icon(Icons.color_lens),
              trailing: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(provider.timer.color),
                ),
              ),
              onTap: () async {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: MaterialColorPicker(
                          onMainColorChange: (Color? value) {
                            if (value != null) {
                              Navigator.pop(context); // Close the dialog
                              provider.setTimerColor(value.value);
                              onEdited(StartSaveState.save);
                              Log.debug(
                                  "Timer color changed to ${value.value}");
                            }
                          },
                          allowShades: false,
                          selectedColor: Color(
                            provider.timer.color,
                          ),
                        ),
                      );
                    });
              },
            ),
            ListTile(
              leading: Icon(Icons.timer_10_select_rounded),
              key: const Key("timer-display-toggle"),
              title: const Text('Timer Display'),
              subtitle: Text(provider.timer.showMinutes == 1
                  ? "Minutes View"
                  : "Seconds View"),
              // widget.timer.showMinutes == 1 ? "Minutes View" : "Seconds View",
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () async {
                await showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 5),
                          Column(
                            children: [
                              Text(
                                "Minutes View",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "1:42",
                                style: TextStyle(
                                  fontSize: 34,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Divider(color: Colors.grey.shade800, thickness: 1),
                          SizedBox(height: 5),
                          Column(
                            children: [
                              Text(
                                "Seconds View",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "102s",
                                style: TextStyle(
                                  fontSize: 34,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          key: const Key("minutes-option"),
                          onPressed: () {
                            Navigator.pop(context);
                            provider.setTimerShowMinutes(1);
                            onEdited(StartSaveState.save);
                            onUnitToggle(true);
                            Log.debug("Timer display changed to Minutes");
                          },
                          child: const Text('Minutes'),
                        ),
                        TextButton(
                          key: const Key("seconds-option"),
                          onPressed: () {
                            Navigator.pop(context);
                            provider.setTimerShowMinutes(0);
                            onEdited(StartSaveState.save);
                            onUnitToggle(false);
                            Log.debug("Timer display changed to Seconds");
                          },
                          child: const Text('Seconds'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            Divider(),
            ListTile(
              key: const Key("active-intervals"),
              title: const Text('Active Intervals'),
              subtitle: Text('# of work intervals'),
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
                  // Must be > 0
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty ||
                        int.tryParse(value) == 0) {
                      return '';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    if (value.isEmpty) {
                      provider.setActiveIntervals(0);
                    } else {
                      provider.setActiveIntervals(int.tryParse(value) ?? 0);
                    }
                    onEdited(StartSaveState.save);
                    Log.debug("Active intervals changed to $value");
                  },
                ),
              ),
            ),
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
                  valueRequired: false,
                  onChanged: (value) {
                    provider.setTimerTimeSettingPart(workTime: value);
                    onEdited(StartSaveState.save);
                    Log.debug("Work time changed to $value");
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
                  valueRequired: false,
                  onChanged: (value) {
                    provider.setTimerTimeSettingPart(restTime: value);
                    onEdited(StartSaveState.save);
                    Log.debug("Rest time changed to $value");
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
                  prefill: true,
                  enableMinutesToggle: false,
                  valueRequired: false,
                  onChanged: (value) {
                    provider.setTimerTimeSettingPart(getReadyTime: value);
                    onEdited(StartSaveState.save);
                    Log.debug("Get ready time changed to $value");
                  },
                ),
              ),
            ),
            ListTile(
              key: const Key("warm-up"),
              title: const Text('Warm-up'),
              subtitle: Text('Optional'),
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
                    Log.debug("Warm-up time changed to $value");
                  },
                ),
              ),
            ),
            ListTile(
              key: const Key("cool-down"),
              title: const Text('Cool-down'),
              subtitle: Text('Optional'),
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
                    Log.debug("Cool-down time changed to $value");
                  },
                ),
              ),
            ),
            ListTile(
              key: const Key("restarts"),
              title: const Text('Restarts'),
              subtitle: Text('Optional, # of restarts'),
              leading: const Icon(Icons.replay),
              trailing: SizedBox(
                width: 80,
                child: TextFormField(
                  controller: restartsController,
                  decoration: inputDecoration,
                  maxLength: 3,
                  style: const TextStyle(fontSize: 30),
                  textAlign: TextAlign.end,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    if (value.isEmpty) {
                      provider.setRestarts(0);
                    } else {
                      provider.setRestarts(int.tryParse(value) ?? 0);
                    }
                    onEdited(StartSaveState.save);
                    Log.debug("Restarts time changed to $value");

                    // If restarts = 0, force breakTime = 0
                    if (value == 0) {
                      provider.setTimerTimeSettingPart(breakTime: 0);
                      timeSettingsControllers['break']?.setTotalSeconds(0);
                      Log.debug("Break time forced to 0 because restarts = 0");
                    }
                  },
                ),
              ),
            ),
            ListTile(
              key: const Key("break"),
              enabled: provider.breakEnabled,
              title: const Text('Break'),
              subtitle: Text('Optional, between restarts'),
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
                    Log.debug("Break time changed to $value");
                  },
                ),
              ),
            ),
            SizedBox(height: 100),
          ],
        ));
  }
}
