import 'package:card_match/features/card_match/domain/entities/game_settings.dart';
import 'package:card_match/features/card_match/domain/repositories/settings_repository.dart';

class GetSettingsUseCase {
  final SettingsRepository repository;

  GetSettingsUseCase({required this.repository});

  GameSettings call() {
    return repository.getSettings();
  }
}
