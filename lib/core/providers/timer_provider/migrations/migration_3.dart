import 'package:openhiit/core/db/repositories/timer_repository.dart';
import 'package:openhiit/core/db/repositories/timer_sound_settings_repository.dart';
import 'package:openhiit/core/db/repositories/timer_time_settings_repository.dart';
import 'package:openhiit/core/logs/logs.dart';
import 'package:openhiit/core/models/timer_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> breakSoundMigration(
    List<TimerType> timers,
    TimerRepository timerRepository,
    TimerTimeSettingsRepository timerTimeSettingsRepository,
    TimerSoundSettingsRepository timerSoundSettingsRepository) async {
  final prefs = await SharedPreferences.getInstance();
  bool hasRunBreakSoundMigration =
      prefs.getBool('hasRunBreakSoundMigration') ?? false;

  if (!hasRunBreakSoundMigration) {
    Log.info("Running break sound migration...");

    Log.debug("Found ${timers.length} timers to migrate");

    for (var timer in timers) {
      Log.debug("Migrating timer: ${timer.name} (${timer.id})");

      // Grab sound settings from the timer
      timer.soundSettings = (await timerSoundSettingsRepository
          .getSoundSettingsByTimerId(timer.id))!;

      timer.timeSettings = (await timerTimeSettingsRepository
          .getTimeSettingsByTimerId(timer.id))!;

      if (timer.timeSettings.breakTime > 0) {
        // Update the break sound to match the rest sound if not already set
        if (timer.soundSettings.breakSound.isEmpty) {
          timer.soundSettings.breakSound = timer.soundSettings.restSound;
          await timerSoundSettingsRepository
              .updateSoundSettings(timer.soundSettings);
        }
      } else {
        // If break time is 0, set it to the default horn sound
        if (timer.soundSettings.breakSound.isEmpty) {
          timer.soundSettings.breakSound = "horn";
          await timerSoundSettingsRepository
              .updateSoundSettings(timer.soundSettings);
        }
      }
    }
    await prefs.setBool('hasRunBreakSoundMigration', true);
  } else {
    Log.info("Break sound migration already completed. Skipping...");
  }
}
