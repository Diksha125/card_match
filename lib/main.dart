import 'package:card_match/features/card_match/core/di/dependency_injection.dart';
import 'package:card_match/features/card_match/core/services/audio_service.dart';
import 'package:card_match/features/card_match/domain/repositories/game_repository.dart';
import 'package:card_match/features/card_match/domain/repositories/settings_repository.dart';
import 'package:card_match/features/card_match/domain/use_case/get_settings_use_case.dart';
import 'package:card_match/features/card_match/presentation/bloc/home/home_bloc.dart';
import 'package:card_match/features/card_match/presentation/bloc/home/home_event.dart';
import 'package:card_match/features/card_match/presentation/bloc/settings/settings_bloc.dart';
import 'package:card_match/features/card_match/presentation/bloc/settings/settings_event.dart';
import 'package:card_match/features/card_match/presentation/bloc/statistics/statistics_bloc.dart';
import 'package:card_match/features/card_match/presentation/bloc/statistics/statistics_event.dart';
import 'package:card_match/features/card_match/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'features/card_match/domain/use_case/get_statistics_use_case.dart';
import 'features/card_match/domain/use_case/save_game_result_use_case.dart';
import 'features/card_match/domain/use_case/start_game_use_case.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('game_box');

  DependencyInjection.init();

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<GameRepository>(
          create: (_) => DependencyInjection.gameRepository,
        ),

        RepositoryProvider<SettingsRepository>(
          create: (_) => DependencyInjection.settingsRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<SettingsBloc>(
            create: (_) => SettingsBloc(
              getSettingsUseCase: DependencyInjection.getSettingsUseCase,
              updateSettingsUseCase: DependencyInjection.updateSettingsUseCase,
              audioService: DependencyInjection.audioService,
            )..add(const LoadSettings()),
          ),

          BlocProvider<HomeBloc>(
            create: (_) => HomeBloc(
              getStatisticsUseCase: DependencyInjection.getStatisticsUseCase,
            )..add(const LoadHomeStats()),
          ),

          BlocProvider<StatisticsBloc>(
            create: (_) => StatisticsBloc(
              getStatisticsUseCase: DependencyInjection.getStatisticsUseCase,
            )..add(const LoadStatistics()),
          ),
        ],
        child: MemoryGameApp(
          getStatisticsUseCase: DependencyInjection.getStatisticsUseCase,
          startGameUseCase: DependencyInjection.startGameUseCase,
          saveGameResultUseCase: DependencyInjection.saveGameResultUseCase,
          getSettingsUseCase: DependencyInjection.getSettingsUseCase,
          audioService: DependencyInjection.audioService,
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
