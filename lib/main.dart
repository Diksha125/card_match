import 'package:card_match/features/card_match/core/services/audio_service.dart';
import 'package:card_match/features/card_match/data/datasources/game_local_data_source.dart';
import 'package:card_match/features/card_match/data/datasources/settings_local_data_source.dart';
import 'package:card_match/features/card_match/data/repositories/game_repository_impl.dart';
import 'package:card_match/features/card_match/data/repositories/settings_repository_impl.dart';
import 'package:card_match/features/card_match/domain/repositories/game_repository.dart';
import 'package:card_match/features/card_match/domain/repositories/settings_repository.dart';
import 'package:card_match/features/card_match/domain/use_case/get_settings_use_case.dart';
import 'package:card_match/features/card_match/domain/use_case/update_settings_use_case.dart';
import 'package:card_match/features/card_match/presentation/bloc/settings/settings_bloc.dart';
import 'package:card_match/features/card_match/presentation/bloc/settings/settings_event.dart';
import 'package:card_match/features/card_match/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/adapters.dart';

import 'features/card_match/domain/use_case/get_statistics_use_case.dart';
import 'features/card_match/domain/use_case/save_game_result_use_case.dart';
import 'features/card_match/domain/use_case/start_game_use_case.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final audioService = AudioService();

  await Hive.initFlutter();

  await Hive.openBox('game_box');

  final box = Hive.box('game_box');

  final localDataSource = GameLocalDataSource(box);

  final gameRepository = GameRepositoryImpl(localDataSource: localDataSource);

  final getStatisticsUseCase = GetStatisticsUseCase(repository: gameRepository);

  final startGameUseCase = StartGameUseCase(repository: gameRepository);

  final saveGameResultUseCase = SaveGameResultUseCase(
    repository: gameRepository,
  );

  final settingsLocalDataSource = SettingsLocalDataSource(box);

  final settingsRepository = SettingsRepositoryImpl(
    localDataSource: settingsLocalDataSource,
  );

  final getSettingsUseCase = GetSettingsUseCase(repository: settingsRepository);

  final updateSettingsUseCase = UpdateSettingsUseCase(
    repository: settingsRepository,
  );

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<GameRepository>(create: (_) => gameRepository),

        RepositoryProvider<SettingsRepository>(
          create: (_) => settingsRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<SettingsBloc>(
            create: (_) => SettingsBloc(
              getSettingsUseCase: getSettingsUseCase,
              updateSettingsUseCase: updateSettingsUseCase,
              audioService: audioService,
            )..add(const LoadSettings()),
          ),
        ],
        child: MemoryGameApp(
          getStatisticsUseCase: getStatisticsUseCase,
          startGameUseCase: startGameUseCase,
          saveGameResultUseCase: saveGameResultUseCase,
          getSettingsUseCase: getSettingsUseCase,
          audioService: audioService,
        ),
      ),
    ),
  );
}

class MemoryGameApp extends StatelessWidget {
  final GetStatisticsUseCase getStatisticsUseCase;
  final StartGameUseCase startGameUseCase;
  final SaveGameResultUseCase saveGameResultUseCase;
  final GetSettingsUseCase getSettingsUseCase;
  final AudioService audioService;

  const MemoryGameApp({
    super.key,
    required this.getStatisticsUseCase,
    required this.startGameUseCase,
    required this.saveGameResultUseCase,
    required this.getSettingsUseCase,
    required this.audioService,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Memory Game',
      theme: ThemeData(useMaterial3: true),
      home: HomePage(
        getStatisticsUseCase: getStatisticsUseCase,
        startGameUseCase: startGameUseCase,
        saveGameResultUseCase: saveGameResultUseCase,
        getSettingsUseCase: getSettingsUseCase,
        audioService: audioService,
      ),
    );
  }
}
