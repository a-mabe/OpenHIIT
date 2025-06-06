import 'dart:async';
import 'dart:math';

import 'package:background_hiit_timer/models/interval_type.dart';
import 'package:flutter/material.dart';
import 'package:openhiit/models/lists/timer_list_tile_model.dart';
import 'package:openhiit/models/timer/timer_type.dart';
import 'package:openhiit/pages/create/tabs/general/general.dart';
import 'package:openhiit/pages/create/tabs/preview/preview.dart';
import 'package:openhiit/pages/create/tabs/sounds/sounds.dart';
import 'package:openhiit/pages/home/home.dart';
import 'package:openhiit/providers/timer_creation_notifier.dart';
import 'package:openhiit/providers/timer_provider.dart';
import 'package:openhiit/utils/functions.dart';
import 'package:openhiit/widgets/timer_card_item_animated.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class CreateTabBar extends StatefulWidget {
  const CreateTabBar({super.key});

  @override
  CreateTabBarState createState() => CreateTabBarState();
}

class CreateTabBarState extends State<CreateTabBar>
    with SingleTickerProviderStateMixin {
  // final TimerType timer = TimerType.empty();
  final formKey = GlobalKey<FormState>();
  late TabController _tabController;
  Future<List<IntervalType>>? intervalsFuture;
  List<TextEditingController> controllers = [];
  TimerType? timer;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.index == 2 && !_tabController.indexIsChanging) {
        var timerCreationNotifier =
            Provider.of<TimerCreationNotifier>(context, listen: false);
        var timerProvider = Provider.of<TimerProvider>(context, listen: false);

        if (timerCreationNotifier.timerDraft.activities.isEmpty) {
          timerCreationNotifier.timerDraft.activities = List.generate(
              timerCreationNotifier.timerDraft.activeIntervals,
              (index) => 'Work');
        }
        if (controllers.isEmpty) {
          controllers = List.generate(
            timerCreationNotifier.timerDraft.activeIntervals,
            (index) => TextEditingController(
              text: timerCreationNotifier.timerDraft.activities[index],
            ),
          );
        }

        // timerCreationNotifier.timerDraft.activities.clear();
        formKey.currentState?.save();
        setState(() {
          intervalsFuture = timerProvider
              .generateIntervalsFromSettings(timerCreationNotifier.timerDraft);
          timer = timerCreationNotifier.timerDraft.copy();
        });
      } else {
        formKey.currentState?.save();
      }
    });

    // timerCreationNotifier =
    //     Provider.of<TimerCreationNotifier>(context, listen: false);
  }

  // void updateTimer(void Function(TimerType) update) {
  //   setState(() {
  //     update(timer);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.timer)),
            Tab(icon: Icon(Icons.volume_up)),
            Tab(
              text: "Editor",
            ),
          ],
        ),
        actions: [
          Shimmer.fromColors(
            baseColor: Colors.grey,
            highlightColor: const Color.fromARGB(255, 255, 255, 255),
            child: IconButton(
              icon: const Icon(Icons.save),
              onPressed: () async {
                // Add your save logic here
                if (formKey.currentState?.validate() ?? false) {
                  formKey.currentState?.save();
                  TimerCreationNotifier timerCreationNotifier =
                      Provider.of<TimerCreationNotifier>(context,
                          listen: false);
                  TimerProvider timerProvider =
                      Provider.of<TimerProvider>(context, listen: false);

                  await timerProvider.submitNewWorkout(
                    timerCreationNotifier.timerDraft,
                  );

                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const MyHomePage()),
                        (route) => false);
                  }
                }
              },
            ),
          ),
        ],
      ),
      body: Form(
        key: formKey,
        child: TabBarView(
          controller: _tabController,
          children: [
            GeneralTab(),
            SoundTab(),
            // SetTimings(timer: timer),
            editorTab(),
          ],
        ),
      ),
    );
  }

  Widget editorTab() {
    if (intervalsFuture == null) {
      return Center(child: CircularProgressIndicator());
    }

    return FutureBuilder<List<IntervalType>>(
      future: intervalsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final intervals = snapshot.data!;
          return PreviewTab(
              intervals: intervals, timer: timer!, controllers: controllers);

          // List<TimerListTileModel> items = listItems(timer!, snapshot.data!);

          // return PreviewTab(
          //   items: items,
          // );
        }
      },
    );
  }
}
