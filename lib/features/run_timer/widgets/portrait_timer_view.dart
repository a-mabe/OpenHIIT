import 'package:auto_size_text/auto_size_text.dart';
import 'package:background_hiit_timer/background_timer_controller.dart';
import 'package:background_hiit_timer/models/timer_state.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:openhiit/features/run_timer/widgets/control_bar.dart';
import 'package:openhiit/features/run_timer/widgets/models/timer_list_model_animated.dart';
import 'package:openhiit/features/run_timer/widgets/models/timer_list_tile_model.dart';
import 'package:openhiit/features/run_timer/widgets/run_timer_appbar.dart';
import 'package:openhiit/features/run_timer/widgets/timer_card_animated.dart';

class PortraitWorkoutView extends StatefulWidget {
  final TimerState timerState;
  final CountdownController controller;
  final bool paused;
  final double volume;
  final VoidCallback togglePause;
  final bool changeVolume;
  final VoidCallback toggleVolumeSlider;
  final GlobalKey<AnimatedListState> listKey;
  final TimerListModelAnimated<TimerListTileModel> intervalTiles;
  final int showMinutes;

  const PortraitWorkoutView({
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
    required this.showMinutes,
  });

  @override
  PortraitWorkoutViewState createState() => PortraitWorkoutViewState();
}

class PortraitWorkoutViewState extends State<PortraitWorkoutView> {
  String timerText(int currentSeconds, int showMinutes) {
    if (showMinutes == 1) {
      // int currentSecondsInt = int.parse(currentSeconds);
      int seconds = currentSeconds % 60;
      int minutes = ((currentSeconds - seconds) / 60).round();

      if (minutes == 0) {
        return currentSeconds.toString();
      }

      String secondsString = seconds.toString();
      if (seconds < 10) {
        secondsString = "0$seconds";
      }

      return "$minutes:$secondsString";
    } else {
      return currentSeconds.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
      children: [
        Column(
          children: [
            Expanded(
                flex: 8,
                child: RunTimerAppBar(
                  text: widget.intervalTiles.length > 0
                      ? widget.intervalTiles[0].intervalString()
                      : "",
                )),
            Expanded(
              flex: 35,
              child: Center(
                  child: FittedBox(
                      fit:
                          BoxFit.scaleDown, // Ensures text grows/shrinks to fit
                      child: AutoSizeText(
                        maxLines: 1,
                        minFontSize: 100,
                        style: GoogleFonts.dmMono(
                          // 'DmMono',
                          fontSize: 20000,
                          height: .9,
                          color: Colors.white,
                        ),
                        timerText(
                            (widget.timerState.currentMicroSeconds /
                                    const Duration(seconds: 1).inMicroseconds)
                                .round(),
                            widget.showMinutes),
                      ))),
            ),
            Expanded(
              flex: 10,
              child: ControlBar(
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
    ));
  }
}
