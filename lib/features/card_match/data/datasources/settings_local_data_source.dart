import 'package:card_match/features/card_match/domain/entities/game_settings.dart';
import 'package:hive_ce/hive.dart';

class SettingsLocalDataSource {
  final Box _box;

  SettingsLocalDataSource(this._box);

  static const String soundKey = 'sound_enabled';
  static const String musicKey = 'music_enabled';
  static const String vibrationKey = 'vibration_enabled';

  GameSettings getSettings() {
    return GameSettings(
      soundEnabled: _box.get(soundKey, defaultValue: true) as bool,
      musicEnabled: _box.get(musicKey, defaultValue: true) as bool,
      vibrationEnabled: _box.get(vibrationKey, defaultValue: true) as bool,
    );
  }

  Future<void> saveSettings(GameSettings settings) async {
    await _box.put(soundKey, settings.soundEnabled);

    await _box.put(musicKey, settings.musicEnabled);

    await _box.put(vibrationKey, settings.vibrationEnabled);
  }
}
