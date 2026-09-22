import 'package:card_match/features/card_match/data/datasources/settings_local_data_source.dart';
import 'package:card_match/features/card_match/domain/entities/game_settings.dart';
import 'package:card_match/features/card_match/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource _localDataSource;

  SettingsRepositoryImpl({required SettingsLocalDataSource localDataSource})
    : _localDataSource = localDataSource;

  @override
  GameSettings getSettings() {
    return _localDataSource.getSettings();
  }

  @override
  Future<void> saveSettings(GameSettings settings) {
    return _localDataSource.saveSettings(settings);
  }
}
