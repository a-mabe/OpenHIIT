import 'package:flutter/material.dart';
import 'package:openhiit/models/lists/timer_list_tile_model.dart';
import 'package:openhiit/pages/create/tabs/preview/widgets/editor_tile.dart';
import 'package:openhiit/providers/timer_creation_notifier.dart';
import 'package:provider/provider.dart';

class PreviewTab extends StatefulWidget {
  final List<TimerListTileModel> items;

  const PreviewTab({super.key, required this.items});

  @override
  PreviewTabState createState() => PreviewTabState();
}

class PreviewTabState extends State<PreviewTab> {
  GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    // final List<TextEditingController> controllers = widget.items
    //     .map((item) => TextEditingController(text: item.action))
    //     .toList();

    TimerCreationNotifier timerCreationNotifier =
        Provider.of<TimerCreationNotifier>(context, listen: false);

    print(timerCreationNotifier.timerDraft.activities);
    print(timerCreationNotifier.timerDraft.activities.length);

    return AnimatedList(
      key: listKey,
      initialItemCount: widget.items.length,
      itemBuilder: (context, index, animation) {
        return EditorTile(
          animation: animation,
          item: widget.items[index],
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
          onSaved: (val) {
            if (val != null && val.toLowerCase() != 'work') {
              setState(
                  () => timerCreationNotifier.timerDraft.activities.add(val));
            }
          },
        );
      },
    );
  }
}
