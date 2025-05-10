import 'package:openhiit/providers/timer_creation_notifier.dart';
import 'package:openhiit_audioplayers/openhiit_audioplayers.dart';
import 'package:background_hiit_timer/models/interval_type.dart';
import 'package:flutter/material.dart';
import 'package:openhiit/models/timer/timer_type.dart';
import 'package:openhiit/pages/home/home.dart';
import 'package:openhiit/providers/timer_provider.dart';
import 'package:openhiit/widgets/loader.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:openhiit/pages/create/tabs/sounds/widgets/sound_dropdown.dart';
import 'package:openhiit/pages/create/tabs/sounds/constants/sounds.dart';

List<String> allSounds = soundsList + countdownSounds;

class SoundTab extends StatefulWidget {
  // final TimerType timer;
  final bool edit;

  const SoundTab({super.key, this.edit = false});

  @override
  State<SoundTab> createState() => SoundTabState();
}

class SoundTabState extends State<SoundTab> {
  bool isLoading = false;
  AudioPlayer player = AudioPlayer();
  late TimerCreationNotifier timerCreationNotifier;

  @override
  void initState() {
    super.initState();
    initAudioContext();
    player.audioCache =
        AudioCache(prefix: 'packages/background_hiit_timer/assets/');
    timerCreationNotifier =
        Provider.of<TimerCreationNotifier>(context, listen: false);
  }

  Future<void> initAudioContext() async {
    await AudioPlayer.global.setAudioContext(
        AudioContextConfig(focus: AudioContextConfigFocus.mixWithOthers)
            .build());
  }

  void pushHome() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MyHomePage()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SoundDropdown(
              dropdownKey: const Key("work-sound"),
              title: "Work Sound",
              initialSelection: timerCreationNotifier.timerDraft.soundSettings
                  .workSound, //widget.timer.soundSettings.workSound,
              soundsList: soundsList,
              onFinished: (value) async {
                if (!value.contains("none")) {
                  await player.play(AssetSource("audio/$value.mp3"));
                  timerCreationNotifier.timerDraft.soundSettings.workSound =
                      value!;
                } else {
                  timerCreationNotifier.timerDraft.soundSettings.workSound = "";
                }
              }),
          SoundDropdown(
              dropdownKey: const Key("rest-sound"),
              title: "Rest Sound",
              initialSelection:
                  timerCreationNotifier.timerDraft.soundSettings.restSound,
              soundsList: soundsList,
              onFinished: (value) async {
                if (!value.contains("none")) {
                  await player.play(AssetSource("audio/$value.mp3"));
                  timerCreationNotifier.timerDraft.soundSettings.restSound =
                      value!;
                } else {
                  timerCreationNotifier.timerDraft.soundSettings.restSound = "";
                }
              }),
          SoundDropdown(
              dropdownKey: const Key("halfway-sound"),
              title: "Halfway Sound",
              initialSelection:
                  timerCreationNotifier.timerDraft.soundSettings.halfwaySound,
              soundsList: soundsList,
              onFinished: (value) async {
                if (!value.contains("none")) {
                  await player.play(AssetSource("audio/$value.mp3"));
                  timerCreationNotifier.timerDraft.soundSettings.halfwaySound =
                      value!;
                } else {
                  timerCreationNotifier.timerDraft.soundSettings.halfwaySound =
                      "";
                }
              }),
          SoundDropdown(
              dropdownKey: const Key("countdown-sound"),
              title: "Countdown Sound",
              initialSelection:
                  timerCreationNotifier.timerDraft.soundSettings.countdownSound,
              soundsList: countdownSounds,
              onFinished: (value) async {
                if (!value.contains("none")) {
                  await player.play(AssetSource("audio/$value.mp3"));
                  timerCreationNotifier
                      .timerDraft.soundSettings.countdownSound = value!;
                } else {
                  timerCreationNotifier
                      .timerDraft.soundSettings.countdownSound = "";
                }
              }),
          SoundDropdown(
              dropdownKey: const Key("end-sound"),
              title: "Timer End Sound",
              initialSelection:
                  timerCreationNotifier.timerDraft.soundSettings.endSound,
              soundsList: soundsList,
              onFinished: (value) async {
                if (!value.contains("none")) {
                  await player.play(AssetSource("audio/$value.mp3"));
                  timerCreationNotifier.timerDraft.soundSettings.endSound =
                      value!;
                } else {
                  timerCreationNotifier.timerDraft.soundSettings.endSound = "";
                }
              }),
        ],
      )),
    );
  }
}
