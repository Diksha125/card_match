import 'package:card_match/features/card_match/domain/entities/game_settings.dart';
import 'package:card_match/features/card_match/domain/repositories/settings_repository.dart';

class UpdateSettingsUseCase {
  final SettingsRepository repository;

  UpdateSettingsUseCase({required this.repository});

  Future<void> call(GameSettings settings) {
    return repository.saveSettings(settings);
  }
}
