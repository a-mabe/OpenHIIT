import 'package:auto_size_text/auto_size_text.dart';
import 'package:background_hiit_timer/background_timer_controller.dart';
import 'package:background_hiit_timer/models/timer_state.dart';
import 'package:flutter/material.dart';
import 'package:openhiit/models/lists/timer_list_model_animated.dart';
import 'package:openhiit/models/lists/timer_list_tile_model.dart';
import 'package:openhiit/pages/active_timer/widgets/landscape_control_bar.dart';
import 'package:openhiit/pages/active_timer/widgets/landscape_run_timer_appbar.dart';
import 'package:openhiit/widgets/timer_card_item_animated.dart';

class LandscapeWorkoutView extends StatefulWidget {
  final TimerState timerState;
  final CountdownController controller;
  final bool paused;
  final double volume;
  final VoidCallback togglePause;
  final bool changeVolume;
  final VoidCallback toggleVolumeSlider;
  final GlobalKey<AnimatedListState> listKey;
  final TimerListModelAnimated<TimerListTileModel> intervalTiles;

  const LandscapeWorkoutView({
    super.key,
    required this.timerState,
    required this.controller,
    required this.paused,
    required this.volume,
    required this.togglePause,
    required this.changeVolume,
    required this.toggleVolumeSlider,
    required this.listKey,
    required this.intervalTiles,
  });

  @override
  LandscapeWorkoutViewState createState() => LandscapeWorkoutViewState();
}

class LandscapeWorkoutViewState extends State<LandscapeWorkoutView> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          children: [
            Expanded(flex: 8, child: LandscapeRunTimerAppBar()),
            Expanded(
              flex: 35,
              child: Column(children: [
                Expanded(
                    flex: 80,
                    child: Center(
                        child: FittedBox(
                            fit: BoxFit
                                .scaleDown, // Ensures text grows/shrinks to fit
                            child: AutoSizeText(
                              maxLines: 1,
                              minFontSize: 100,
                              style: const TextStyle(
                                  height: 1,
                                  color: Colors.white,
                                  fontSize: 1000),
                              (widget.timerState.currentMicroSeconds /
                                      const Duration(seconds: 1).inMicroseconds)
                                  .round()
                                  .toString(),
                            )))),
                Expanded(
                  flex: 20,
                  child: LandscapeControlBar(
                    onRestart: () => widget.controller.restart(),
                    paused: widget.paused,
                    changeVolume: widget.changeVolume,
                    volume: widget.volume,
                    onTogglePlayPause: widget.togglePause,
                    onAdjustVolume: widget.toggleVolumeSlider,
                    onSkipNext: widget.controller.skipNext,
                    onSkipPrevious: widget.controller.skipPrevious,
                    color: Colors.transparent,
                  ),
                ),
              ]),
            ),
            Expanded(
                flex: 47,
                child: AnimatedList(
                  key: widget.listKey,
                  initialItemCount: widget.intervalTiles.length,
                  itemBuilder: (context, index, animation) {
                    if (index >= widget.intervalTiles.length) {
                      return Container();
                    } else {
                      return TimerCardItemAnimated(
                        animation: animation,
                        item: widget.intervalTiles[index],
                        fontColor: index == 0
                            ? Colors.white
                            : const Color.fromARGB(153, 255, 255, 255),
                        fontWeight:
                            index == 0 ? FontWeight.bold : FontWeight.normal,
                        backgroundColor: Colors.transparent,
                        sizeMultiplier: index == 0 ? 1.5 : 1,
                      );
                    }
                  },
                ))
          ],
        )
      ],
    );
  }
}
