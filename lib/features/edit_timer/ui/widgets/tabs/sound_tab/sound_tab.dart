import 'package:flutter/material.dart';
import 'package:openhiit/core/providers/timer_creation_provider/timer_creation_provider.dart';
import 'package:openhiit/features/edit_timer/ui/widgets/start_save_toggle.dart';
import 'package:openhiit/features/edit_timer/ui/widgets/tabs/sound_tab/constants.dart';
import 'package:openhiit_audioplayers/openhiit_audioplayers.dart';
import 'package:provider/provider.dart';

class SoundTab extends StatefulWidget {
  final ValueChanged<StartSaveState> onEdited;

  const SoundTab({super.key, required this.onEdited});

  @override
  State<SoundTab> createState() => _SoundTabState();
}

class _SoundTabState extends State<SoundTab> {
  late AudioPlayer player;

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    initAudioContext();
    player.audioCache =
        AudioCache(prefix: 'packages/background_hiit_timer/assets/');
  }

  Future<void> initAudioContext() async {
    await AudioPlayer.global.setAudioContext(
      AudioContextConfig(focus: AudioContextConfigFocus.mixWithOthers).build(),
    );
  }

  Future<void> _playPreview(String sound) async {
    if (sound != "none") {
      await player.play(AssetSource("audio/$sound.mp3"));
    }
  }

  Widget _buildSoundDropdown({
    required String keyName,
    required String label,
    required String initialValue,
    required ValueChanged<String> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      key: Key(keyName),
      initialValue: initialValue,
      decoration: InputDecoration(labelText: label),
      items: soundOptions.entries
          .map((entry) => DropdownMenuItem<String>(
                value: entry.key,
                child: Text(entry.value),
              ))
          .toList(),
      onChanged: (value) async {
        if (value != null) {
          await _playPreview(value);
          onChanged(value);
          widget.onEdited(StartSaveState.save);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TimerCreationProvider>();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSoundDropdown(
          keyName: "work-sound",
          label: "Work Sound",
          initialValue: provider.timer.soundSettings.workSound,
          onChanged: (value) =>
              provider.setTimerSoundSettingPart(workSound: value),
        ),
        const SizedBox(height: 16),
        _buildSoundDropdown(
          keyName: "rest-sound",
          label: "Rest Sound",
          initialValue: provider.timer.soundSettings.restSound,
          onChanged: (value) =>
              provider.setTimerSoundSettingPart(restSound: value),
        ),
        const SizedBox(height: 16),
        _buildSoundDropdown(
          keyName: "halfway-sound",
          label: "Halfway Sound",
          initialValue: provider.timer.soundSettings.halfwaySound,
          onChanged: (value) =>
              provider.setTimerSoundSettingPart(halfwaySound: value),
        ),
        const SizedBox(height: 16),
        _buildSoundDropdown(
          keyName: "countdown-sound",
          label: "Countdown Sound",
          initialValue: provider.timer.soundSettings.countdownSound,
          onChanged: (value) =>
              provider.setTimerSoundSettingPart(countdownSound: value),
        ),
        const SizedBox(height: 16),
        _buildSoundDropdown(
          keyName: "end-sound",
          label: "End Sound",
          initialValue: provider.timer.soundSettings.endSound,
          onChanged: (value) =>
              provider.setTimerSoundSettingPart(endSound: value),
        ),
      ],
    );
  }
}
