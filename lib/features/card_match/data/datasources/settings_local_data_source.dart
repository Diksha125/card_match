import 'package:card_match/features/card_match/domain/entities/game_settings.dart';
import 'package:hive_ce/hive.dart';

class SettingsLocalDataSource {
  final Box box;

  SettingsLocalDataSource(this.box);

  static const String soundKey = 'sound_enabled';
  static const String musicKey = 'music_enabled';
  static const String vibrationKey = 'vibration_enabled';

  GameSettings getSettings() {
    return GameSettings(
      soundEnabled: box.get(soundKey, defaultValue: true) as bool,
      musicEnabled: box.get(musicKey, defaultValue: true) as bool,
      vibrationEnabled: box.get(vibrationKey, defaultValue: true) as bool,
    );
  }

  Future<void> saveSettings(GameSettings settings) async {
    await box.put(soundKey, settings.soundEnabled);

    await box.put(musicKey, settings.musicEnabled);

    await box.put(vibrationKey, settings.vibrationEnabled);
  }
}
