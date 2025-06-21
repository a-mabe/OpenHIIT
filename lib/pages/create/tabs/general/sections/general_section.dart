import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
// import 'package:openhiit/models/timer/timer_type.dart';
import 'package:openhiit/pages/create/tabs/general/sections/rows/tappable_row.dart';
import 'package:openhiit/pages/create/tabs/general/sections/rows/time_row.dart';
import 'package:openhiit/providers/timer_creation_notifier.dart';
import 'package:provider/provider.dart';

class GeneralSection extends StatefulWidget {
  const GeneralSection({super.key});

  @override
  GeneralSectionState createState() => GeneralSectionState();
}

class GeneralSectionState extends State<GeneralSection> {
  TextEditingController activeIntervalsController = TextEditingController();

  @override
  void initState() {
    super.initState();

    TimerCreationNotifier timerCreationNotifier =
        Provider.of<TimerCreationNotifier>(context, listen: false);

    activeIntervalsController.text =
        timerCreationNotifier.timerDraft.activeIntervals == 0
            ? ""
            : timerCreationNotifier.timerDraft.activeIntervals.toString();
  }

  @override
  Widget build(BuildContext context) {
    final timerCreationNotifier = Provider.of<TimerCreationNotifier>(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
          child: TextFormField(
            key: const Key("timer-name"),
            initialValue: timerCreationNotifier.timerDraft.name,
            style: const TextStyle(fontSize: 24),
            decoration: InputDecoration(
              hintText: "Add title",
              border: InputBorder.none,
              contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            ),
            onSaved: (value) {
              if (value != null && value.trim().isNotEmpty) {
                timerCreationNotifier.updateProperty("name", value.trim());
              } else {
                timerCreationNotifier.updateProperty("name", "Timer");
              }
            },
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Name cannot be empty';
              }
              return null;
            },
            // Handle validation
            // return null;
          ),
        ),
        TappableRow(
          key: const Key("color-picker"),
          title: "Color",
          trailing: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(timerCreationNotifier.timerDraft.color),
            ),
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: MaterialColorPicker(
                    onMainColorChange: (Color? value) {
                      if (value != null) {
                        Navigator.pop(context); // Close the dialog
                        setState(() {
                          timerCreationNotifier.updateProperty(
                            "color",
                            value.value,
                          );
                        });
                      }
                    },
                    allowShades: false,
                    selectedColor: Color(
                      timerCreationNotifier.timerDraft.color,
                    ),
                  ),
                );
              },
            );
          },
        ),
        TappableRow(
          // leading: Icon(Icons.timer_10_select_rounded),
          key: const Key("timer-display-toggle"),
          title: "Timer Display",
          subtitle: timerCreationNotifier.timerDraft.showMinutes == 1
              ? "Minutes View"
              : "Seconds View",
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
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              "Minutes View",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "1:42",
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(color: Colors.grey.shade800, thickness: 1),
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              "Seconds View",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "102s",
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      key: const Key("minutes-option"),
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          // widget.timer.showMinutes = 1;
                          timerCreationNotifier.updateProperty(
                            "showMinutes",
                            1,
                          );
                        });
                      },
                      child: const Text('Minutes'),
                    ),
                    TextButton(
                      key: const Key("seconds-option"),
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          // widget.timer.showMinutes = 0;
                          timerCreationNotifier.updateProperty(
                            "showMinutes",
                            0,
                          );
                        });
                      },
                      child: const Text('Seconds'),
                    ),
                  ],
                );
              },
            );
          },
        ),
        Divider(thickness: 1, color: Colors.grey),
        TimeRow(
          key: const Key("interval-input"),
          title: "Active Intervals",
          subtitle: "Required - work intervals",
          showMinutes: 0,
          leadingIcon: Icons.view_timeline_outlined,
          secondsController: activeIntervalsController,
          unit: "",
          // minutesController: controllerMap["$workKey-minutes"]!,
          // secondsController: controllerMap["$workKey-seconds"]!,
          minutesOnSaved: (value) {
            // Do nothing, save via the controller and secondsOnSaved
          },
          secondsOnSaved: (value) {
            final seconds = int.tryParse(value ?? '0') ?? 0;
            timerCreationNotifier.updateProperty("activeIntervals", seconds);
          },
        ),
      ],
    );
  }
}
