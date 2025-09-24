import 'package:background_hiit_timer/models/interval_type.dart';
import 'package:flutter/material.dart';
import 'package:openhiit/core/models/interval_display_model.dart';
import 'package:openhiit/core/providers/timer_creation_provider/timer_creation_provider.dart';
import 'package:openhiit/core/providers/timer_provider/timer_provider.dart';
import 'package:openhiit/core/utils/interval_calculation.dart';
import 'package:openhiit/features/edit_timer/ui/widgets/start_save_toggle.dart';
import 'package:openhiit/features/edit_timer/ui/widgets/tabs/editor_tab/widgets/interval_list_tile.dart';
import 'package:openhiit/features/run_timer/widgets/functions/functions.dart';
import 'package:provider/provider.dart';

class EditorTab extends StatelessWidget {
  final bool controllersUpdated;
  final List<TextEditingController> controllers;
  final ValueChanged<StartSaveState> onEdited;
  final ValueChanged<StartSaveState> setButtonState;

  const EditorTab({
    super.key,
    required this.controllersUpdated,
    required this.controllers,
    required this.onEdited,
    required this.setButtonState,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TimerCreationProvider>();

    return FutureBuilder<List<IntervalDisplayModel>>(
      future: controllersUpdated
          ? generateIntervalDisplaysForTimer(provider.timer,
              singleIteration: true)
          : null,
      builder: (BuildContext context,
          AsyncSnapshot<List<IntervalDisplayModel>> snapshot) {
        List<Widget> children;
        if (snapshot.hasData) {
          final items = snapshot.data!;

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final interval = items[index];

              final isBreak = interval.name.toLowerCase() == "break";

              final isRestAfterLastActive =
                  interval.name.toLowerCase() == "rest" &&
                      index > 0 &&
                      items[index - 1].activeIndex ==
                          items
                              .map((e) => e.activeIndex)
                              .where((i) => i > 0)
                              .fold<int>(0, (a, b) => a > b ? a : b);

              // Build the normal tile
              final tile = IntervalListTile(
                interval: interval,
                backgroundColor: getIntervalColor(interval.name).withAlpha(200),
                editing: true,
                nameController: interval.activeIndex != 0
                    ? controllers[interval.activeIndex - 1]
                    : null,
                onNameChanged: interval.activeIndex != 0
                    ? (newName) {
                        provider.timer.activities = controllers
                            .map((c) =>
                                c.text.trim().isEmpty ? "Work" : c.text.trim())
                            .toList();

                        setButtonState(StartSaveState.save);
                      }
                    : null,
              );

              // If this interval completes the sequence, show both
              if (isBreak || isRestAfterLastActive) {
                return Column(
                  children: [
                    tile, // original Break/Rest
                    ListTile(
                        title: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0), // top & bottom padding
                        child: Row(
                          mainAxisSize:
                              MainAxisSize.min, // keep row centered & tight
                          children: [
                            const Icon(Icons.replay, size: 24),
                            const SizedBox(
                                width: 8), // spacing between icon and text
                            Text(
                              "Repeat for ${provider.timer.timeSettings.restarts}x",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
                  ],
                );
              }

              return tile;
            },
          );
        } else if (snapshot.hasError) {
          children = <Widget>[
            const Icon(Icons.error_outline, color: Colors.red, size: 60),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text('Error: ${snapshot.error}'),
            ),
          ];
        } else {
          children = const <Widget>[
            SizedBox(width: 60, height: 60, child: CircularProgressIndicator()),
            Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Generating intervals...')),
          ];
        }
        return Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center, children: children),
        );
      },
    );
  }
}
