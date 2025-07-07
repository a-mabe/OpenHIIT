import 'dart:async';

import 'package:background_hiit_timer/models/interval_type.dart';
import 'package:flutter/material.dart';
import 'package:openhiit/old/models/lists/timer_list_tile_model.dart';
import 'package:openhiit/old/models/timer/timer_type.dart';
import 'package:openhiit/old/pages/create/tabs/general/general.dart';
import 'package:openhiit/old/pages/create/tabs/preview/preview.dart';
import 'package:openhiit/old/pages/create/tabs/sounds/sounds.dart';
import 'package:openhiit/old/pages/home/home.dart';
import 'package:openhiit/old/providers/timer_creation_notifier.dart';
import 'package:openhiit/old/providers/timer_provider.dart';
import 'package:openhiit/old/utils/functions.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class CreateTabBar extends StatefulWidget {
  const CreateTabBar({super.key});

  @override
  State<CreateTabBar> createState() => _CreateTabBarState();
}

class _CreateTabBarState extends State<CreateTabBar>
    with SingleTickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  late final TabController _tabController;
  Future<List<IntervalType>>? intervalsFuture;
  List<TextEditingController> controllers = [];
  TimerType? timer;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (_tabController.index == 2 && !_tabController.indexIsChanging) {
      final timerCreationNotifier =
          Provider.of<TimerCreationNotifier>(context, listen: false);
      final timerProvider = Provider.of<TimerProvider>(context, listen: false);

      formKey.currentState?.save();

      if (timerCreationNotifier.timerDraft.activities.isEmpty) {
        timerCreationNotifier.timerDraft.activities = List.generate(
          timerCreationNotifier.timerDraft.activeIntervals *
              (timerCreationNotifier.timerDraft.timeSettings.restarts + 1),
          (_) => 'Work',
        );
      }

      if (controllers.isEmpty) {
        controllers = List.generate(
          timerCreationNotifier.timerDraft.activeIntervals *
              (timerCreationNotifier.timerDraft.timeSettings.restarts + 1),
          (index) => TextEditingController(
            text: timerCreationNotifier.timerDraft.activities[index],
          ),
        );
      }

      print("666666666666666666666666666666666666666666");
      print(timerCreationNotifier.timerDraft.activities.length);
      for (var i = 0; i < controllers.length; i++) {
        print('Controller $i: ${controllers[i].text}');
      }
      print("666666666666666666666666666666666666666666");

      setState(() {
        intervalsFuture = timerProvider
            .generateIntervalsFromSettings(timerCreationNotifier.timerDraft);
        timer = timerCreationNotifier.timerDraft.copy();
      });
    } else {
      formKey.currentState?.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    final saveButton = Shimmer.fromColors(
      baseColor: Colors.grey,
      highlightColor: const Color.fromARGB(255, 255, 255, 255),
      child: IconButton(
        key: const Key("save-timer"),
        icon: const Icon(Icons.save),
        onPressed: _onSavePressed,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.timer)),
            Tab(icon: Icon(Icons.volume_up)),
            Tab(text: "Editor"),
          ],
        ),
        actions: [saveButton],
      ),
      body: Form(
        key: formKey,
        child: TabBarView(
            controller: _tabController,
            children: [const GeneralTab(), const SoundTab(), editorTab()]),
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
          // List<TimerListTileModel> items = listItems(timer!, snapshot.data!);
          return PreviewTab(
            timer: timer!,
            intervals: snapshot.data!,
            controllers: controllers,
          );
        }
      },
    );
  }

  Future<void> _onSavePressed() async {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();
      final timerCreationNotifier =
          Provider.of<TimerCreationNotifier>(context, listen: false);
      final timerProvider = Provider.of<TimerProvider>(context, listen: false);

      await timerProvider.submitNewWorkout(timerCreationNotifier.timerDraft);

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const MyHomePage()),
          (route) => false,
        );
      }
    }
  }
}
