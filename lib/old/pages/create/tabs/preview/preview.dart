import 'package:background_hiit_timer/models/interval_type.dart';
import 'package:flutter/material.dart';
import 'package:openhiit/old/models/lists/timer_list_tile_model.dart';
import 'package:openhiit/old/models/timer/timer_type.dart';
import 'package:openhiit/old/pages/create/tabs/preview/widgets/editor_tile.dart';
import 'package:openhiit/old/providers/timer_creation_notifier.dart';
import 'package:openhiit/old/utils/functions.dart';
import 'package:provider/provider.dart';

class PreviewTab extends StatefulWidget {
  final TimerType timer;
  final List<IntervalType> intervals;
  final List<TextEditingController> controllers;

  const PreviewTab(
      {super.key,
      required this.timer,
      required this.intervals,
      required this.controllers});

  @override
  PreviewTabState createState() => PreviewTabState();
}

class PreviewTabState extends State<PreviewTab> {
  GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  // late final List<TextEditingController> controllers;
  late final List<TimerListTileModel> items;

  @override
  void initState() {
    super.initState();
    items = listItems(widget.timer, widget.intervals);
  }

  @override
  Widget build(BuildContext context) {
    int workCount = -1;

    return ListView.builder(
      itemCount: widget.intervals.length,
      itemBuilder: (context, index) {
        if ((items[index].interval) == 1) {
          workCount += 1;
        }

        if ((items[index].interval) > 0) {
          print("items[index].interval: ${items[index].interval}");
          print("workCount: $workCount");

          print("***********************");
          print((((items[index].interval) - 1) +
              (workCount * widget.timer.activeIntervals)));
        }

        void Function(String?) onSaved(int num) {
          return (String? val) {
            if (val != null) {
              print(items[index].interval);
              print("Saving value: $val");
              print(
                  "At location: ${((items[index].interval) - 1) + (num * widget.timer.activeIntervals)}");
              print("workCount: $num");

              TimerCreationNotifier timerCreationNotifier =
                  Provider.of<TimerCreationNotifier>(context, listen: false);
              timerCreationNotifier.timerDraft.activities[
                  ((items[index].interval) - 1) +
                      (num * widget.timer.activeIntervals)] = val;
            }
          };
        }

        return EditorTile(
          textKey: "editor-$index",
          item: items[index],
          controller: !["Rest", "Get Ready", "Warmup", "Cooldown", "Break"]
                  .contains(items[index].action)
              ? widget.controllers[((items[index].interval) - 1) +
                  (workCount * widget.timer.activeIntervals)]
              : null,
          fontColor: Colors.white,
          fontWeight: index == 0 ? FontWeight.bold : FontWeight.normal,
          backgroundColor: Colors.transparent,
          sizeMultiplier: 1,
          validator: (val) {
            if (val == null || val.isEmpty) {
              return "Enter an activity";
            }
            return null;
          },
          onSaved: onSaved(workCount),
        );
        // return ListTile(
        //   title: Text(interval.name),
        //   subtitle: Text('Duration: ${interval.time} seconds'),
        // );
      },
    );

    // final List<TextEditingController> controllers = widget.items
    //     .map((item) => TextEditingController(text: item.action))
    //     .toList();

    // TimerCreationNotifier timerCreationNotifier =
    //     Provider.of<TimerCreationNotifier>(context, listen: false);

    // return AnimatedList(
    //   key: listKey,
    //   initialItemCount: widget.items.length,
    //   itemBuilder: (context, index, animation) {
    //     return EditorTile(
    //       animation: animation,
    //       item: widget.items[index],
    //       fontColor: Colors.white,
    //       fontWeight: index == 0 ? FontWeight.bold : FontWeight.normal,
    //       backgroundColor: Colors.transparent,
    //       sizeMultiplier: 1,
    //       validator: (val) {
    //         if (val == null || val.isEmpty) {
    //           return "Enter an activity";
    //         }
    //         return null;
    //       },
    //       onSaved: (val) {
    //         if (val != null && val.toLowerCase() != 'work') {
    //           setState(
    //               () => timerCreationNotifier.timerDraft.activities.add(val));
    //         }
    //       },
    //     );
    //   },
    // );
  }
}
