import 'package:background_hiit_timer/background_timer.dart';
import 'package:background_hiit_timer/background_timer_controller.dart';
import 'package:background_hiit_timer/models/interval_type.dart';
import 'package:background_hiit_timer/models/timer_state.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:openhiit/core/models/timer_type.dart';
import 'package:openhiit/features/run_timer/widgets/functions/functions.dart';
import 'package:openhiit/features/run_timer/widgets/landscape_timer_view.dart';
import 'package:openhiit/features/run_timer/widgets/models/timer_list_model_animated.dart';
import 'package:openhiit/features/run_timer/widgets/models/timer_list_tile_model.dart';
import 'package:openhiit/features/run_timer/widgets/portrait_timer_view.dart';
import 'package:openhiit/features/run_timer/widgets/timer_card_animated.dart';
import 'package:openhiit/features/run_timer/widgets/timer_complete.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class RunTimer extends StatefulWidget {
  final TimerType timer;
  final List<IntervalType> intervals;

  const RunTimer({
    super.key,
    required this.timer,
    required this.intervals,
  });

  @override
  RunTimerState createState() => RunTimerState();
}

class RunTimerState extends State<RunTimer> {
  final CountdownController _controller = CountdownController(autoStart: true);
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  bool _paused = false;
  bool _changeVolume = false;
  double _volume = .8;
  late ConfettiController _controllerCenter;
  late SharedPreferences prefs;
  late TimerListModelAnimated<TimerListTileModel> intervalTiles;
  late TimerListModelAnimated<TimerListTileModel> removedTiles;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    loadPreferences();
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    intervalTiles = TimerListModelAnimated<TimerListTileModel>(
      listKey: _listKey,
      initialItems: listItems(widget.timer, widget.intervals),
      removedItemBuilder: _buildRemovedItem,
    );
    removedTiles = TimerListModelAnimated<TimerListTileModel>(
      listKey: _listKey,
      initialItems: [],
      removedItemBuilder: _buildRemovedItem,
    );
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    WakelockPlus.disable();
    super.dispose();
  }

  Widget _buildRemovedItem(TimerListTileModel item, BuildContext context,
      Animation<double> animation) {
    return TimerCardItemAnimated(
      animation: animation,
      item: item,
      fontColor: const Color.fromARGB(153, 255, 255, 255),
      fontWeight: FontWeight.normal,
      backgroundColor: Colors.transparent,
      sizeMultiplier: 1,
    );
  }

  Future<void> loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _volume = prefs.getDouble('volume') ?? .8;
      _changeVolume = prefs.getBool('changeVolume') ?? false;
    });
  }

  Future<void> toggleVolumeSlider() async {
    setState(() {
      _changeVolume = !_changeVolume;
    });
    await prefs.setBool('changeVolume', _changeVolume);
  }

  Future<void> togglePause() async {
    setState(() {
      _paused = !_paused;
    });
    _paused ? _controller.pause() : _controller.resume();
    _paused ? WakelockPlus.disable() : WakelockPlus.enable();
  }

  Color backgroundColor(String state) {
    switch (state) {
      case 'Get Ready':
        return Colors.black;
      case 'Warmup':
        return Colors.orange;
      case 'Work':
        return Colors.green;
      case 'Rest':
        return Colors.red;
      case 'Cooldown':
        return Colors.blue;
      case 'Break':
        return Colors.teal;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Countdown(
            controller: _controller,
            intervals: widget.intervals,
            build: (_, TimerState timerState) {
              while (intervalTiles.length + timerState.currentInterval >
                  widget.intervals.length) {
                removedTiles.insert(removedTiles.length,
                    intervalTiles[0]); //add(intervalTiles[0]);
                intervalTiles.removeAt(0);
              }

              while (intervalTiles.length + timerState.currentInterval <
                  widget.intervals.length) {
                intervalTiles.insert(0, removedTiles[removedTiles.length - 1]);
                removedTiles.removeAt(removedTiles.length - 1);
              }

              Widget workoutView = orientation == Orientation.landscape
                  ? LandscapeWorkoutView(
                      timerState: timerState,
                      controller: _controller,
                      paused: _paused,
                      volume: _volume,
                      togglePause: togglePause,
                      changeVolume: _changeVolume,
                      toggleVolumeSlider: toggleVolumeSlider,
                      listKey: _listKey,
                      intervalTiles: intervalTiles,
                      showMinutes: widget.timer.showMinutes)
                  : PortraitWorkoutView(
                      timerState: timerState,
                      controller: _controller,
                      paused: _paused,
                      volume: _volume,
                      togglePause: togglePause,
                      changeVolume: _changeVolume,
                      toggleVolumeSlider: toggleVolumeSlider,
                      listKey: _listKey,
                      intervalTiles: intervalTiles,
                      showMinutes: widget.timer.showMinutes);

              return Stack(
                children: [
                  Container(
                    color: backgroundColor(timerState.status),
                    child: SafeArea(child: workoutView),
                  ),
                  TimerComplete(
                    controller: _controllerCenter,
                    visible: timerState.status == 'End',
                    onRestart: () => _controller.restart(),
                    timerName: widget.timer.name,
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
