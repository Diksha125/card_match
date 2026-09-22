import 'package:card_match/features/card_match/core/services/audio_service.dart';
import 'package:card_match/features/card_match/data/datasources/game_local_data_source.dart';
import 'package:card_match/features/card_match/data/datasources/settings_local_data_source.dart';
import 'package:card_match/features/card_match/data/repositories/game_repository_impl.dart';
import 'package:card_match/features/card_match/data/repositories/settings_repository_impl.dart';
import 'package:card_match/features/card_match/domain/repositories/game_repository.dart';
import 'package:card_match/features/card_match/domain/repositories/settings_repository.dart';
import 'package:card_match/features/card_match/domain/use_case/get_settings_use_case.dart';
import 'package:card_match/features/card_match/domain/use_case/get_statistics_use_case.dart';
import 'package:card_match/features/card_match/domain/use_case/save_game_result_use_case.dart';
import 'package:card_match/features/card_match/domain/use_case/start_game_use_case.dart';
import 'package:card_match/features/card_match/domain/use_case/update_settings_use_case.dart';
import 'package:hive_ce/hive.dart';

class DependencyInjection {
  DependencyInjection._();

  static late final GameLocalDataSource gameLocalDataSource;
  static late final SettingsLocalDataSource settingsLocalDataSource;

  static late final GameRepository gameRepository;
  static late final SettingsRepository settingsRepository;

  static late final GetStatisticsUseCase getStatisticsUseCase;
  static late final StartGameUseCase startGameUseCase;
  static late final SaveGameResultUseCase saveGameResultUseCase;

  static late final GetSettingsUseCase getSettingsUseCase;
  static late final UpdateSettingsUseCase updateSettingsUseCase;

  static late final AudioService audioService;

  static void init() {
    final gameBox = Hive.box('game_box');

    gameLocalDataSource = GameLocalDataSource(gameBox);
    settingsLocalDataSource = SettingsLocalDataSource(gameBox);

    gameRepository = GameRepositoryImpl(localDataSource: gameLocalDataSource);

    settingsRepository = SettingsRepositoryImpl(
      localDataSource: settingsLocalDataSource,
    );

    getStatisticsUseCase = GetStatisticsUseCase(repository: gameRepository);

    startGameUseCase = StartGameUseCase(repository: gameRepository);

    saveGameResultUseCase = SaveGameResultUseCase(repository: gameRepository);

    getSettingsUseCase = GetSettingsUseCase(repository: settingsRepository);

    updateSettingsUseCase = UpdateSettingsUseCase(
      repository: settingsRepository,
    );

    audioService = AudioService();
  }
}
