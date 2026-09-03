import 'package:card_match/features/card_match/domain/entities/game_settings.dart';

abstract class SettingsRepository {
  GameSettings getSettings();

  Future<void> saveSettings(
      GameSettings settings,
      );
}