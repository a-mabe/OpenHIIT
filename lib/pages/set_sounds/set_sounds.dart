import 'package:openhiit_audioplayers/openhiit_audioplayers.dart';
import 'package:background_hiit_timer/models/interval_type.dart';
import 'package:flutter/material.dart';
import 'package:openhiit/models/timer/timer_type.dart';
import 'package:openhiit/pages/home/home.dart';
import 'package:openhiit/providers/workout_provider.dart';
import 'package:openhiit/widgets/loader.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'widgets/sound_dropdown.dart';
import '../../widgets/form_widgets/submit_button.dart';
import 'constants/sounds.dart';

List<String> allSounds = soundsList + countdownSounds;

class SetSounds extends StatefulWidget {
  final TimerType timer;
  final bool edit;

  const SetSounds({super.key, required this.timer, this.edit = false});

  @override
  State<SetSounds> createState() => _SetSoundsState();
}

class _SetSoundsState extends State<SetSounds> {
  bool isLoading = false;
  AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    initAudioContext();
    player.audioCache =
        AudioCache(prefix: 'packages/background_hiit_timer/assets/');
  }

  Future<void> initAudioContext() async {
    await AudioPlayer.global.setAudioContext(
        AudioContextConfig(focus: AudioContextConfigFocus.mixWithOthers)
            .build());
  }

  void submitWorkout(TimerType timer, BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    WorkoutProvider workoutProvider =
        Provider.of<WorkoutProvider>(context, listen: false);

    if (timer.id == "") {
      timer.id = const Uuid().v1();
      timer.timeSettings.id = const Uuid().v1();
      timer.soundSettings.id = const Uuid().v1();
      timer.timeSettings.timerId = timer.id;
      timer.soundSettings.timerId = timer.id;

      List<IntervalType> intervals =
          workoutProvider.generateIntervalsFromSettings(timer);
      timer.totalTime =
          workoutProvider.calculateTotalTimeFromIntervals(intervals);

      await workoutProvider.addIntervals(intervals);
      await workoutProvider.addTimer(timer);
    } else {
      List<IntervalType> intervals =
          workoutProvider.generateIntervalsFromSettings(timer);
      timer.totalTime =
          workoutProvider.calculateTotalTimeFromIntervals(intervals);

      await workoutProvider.deleteIntervalsByWorkoutId(timer.id);
      await workoutProvider.addIntervals(intervals);
      await workoutProvider.updateTimer(timer);
    }

    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const MyHomePage()),
          (route) => false);
    }

    setState(() {
      isLoading = false;
    });
  }

  void pushHome() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MyHomePage()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text("New Interval Timer"),
          ),
          bottomSheet: SubmitButton(
            text: "Submit",
            color: Colors.blue,
            onTap: () {
              submitWorkout(widget.timer, context);
            },
          ),
          body: SizedBox(
              height: (MediaQuery.of(context).size.height * 10) / 12,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(30, 20, 10, 30),
                      child: Form(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SoundDropdown(
                              dropdownKey: const Key("work-sound"),
                              title: "Work Sound",
                              initialSelection:
                                  widget.timer.soundSettings.workSound,
                              soundsList: soundsList,
                              onFinished: (value) async {
                                if (!value.contains("none")) {
                                  await player
                                      .play(AssetSource("audio/$value.mp3"));
                                  widget.timer.soundSettings.workSound = value!;
                                } else {
                                  widget.timer.soundSettings.workSound = "";
                                }
                              }),
                          SoundDropdown(
                              dropdownKey: const Key("rest-sound"),
                              title: "Rest Sound",
                              initialSelection:
                                  widget.timer.soundSettings.restSound,
                              soundsList: soundsList,
                              onFinished: (value) async {
                                if (!value.contains("none")) {
                                  await player
                                      .play(AssetSource("audio/$value.mp3"));
                                  widget.timer.soundSettings.restSound = value!;
                                } else {
                                  widget.timer.soundSettings.restSound = "";
                                }
                              }),
                          SoundDropdown(
                              dropdownKey: const Key("halfway-sound"),
                              title: "Halfway Sound",
                              initialSelection:
                                  widget.timer.soundSettings.halfwaySound,
                              soundsList: soundsList,
                              onFinished: (value) async {
                                if (!value.contains("none")) {
                                  await player
                                      .play(AssetSource("audio/$value.mp3"));
                                  widget.timer.soundSettings.halfwaySound =
                                      value!;
                                } else {
                                  widget.timer.soundSettings.halfwaySound = "";
                                }
                              }),
                          SoundDropdown(
                              dropdownKey: const Key("countdown-sound"),
                              title: "Countdown Sound",
                              initialSelection:
                                  widget.timer.soundSettings.countdownSound,
                              soundsList: countdownSounds,
                              onFinished: (value) async {
                                if (!value.contains("none")) {
                                  await player
                                      .play(AssetSource("audio/$value.mp3"));
                                  widget.timer.soundSettings.countdownSound =
                                      value!;
                                } else {
                                  widget.timer.soundSettings.countdownSound =
                                      "";
                                }
                              }),
                          SoundDropdown(
                              dropdownKey: const Key("end-sound"),
                              title: "Timer End Sound",
                              initialSelection:
                                  widget.timer.soundSettings.endSound,
                              soundsList: soundsList,
                              onFinished: (value) async {
                                if (!value.contains("none")) {
                                  await player
                                      .play(AssetSource("audio/$value.mp3"));
                                  widget.timer.soundSettings.endSound = value!;
                                } else {
                                  widget.timer.soundSettings.endSound = "";
                                }
                              }),
                        ],
                      ))))),
        ),
        if (isLoading)
          SafeArea(
              child: Scaffold(
                  body: LoaderTransparent(
            visible: isLoading,
            loadingMessage: "Saving ${widget.timer.name} to database...",
          )))
      ],
    );
  }
}
