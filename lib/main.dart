import 'package:card_match/features/card_match/data/datasources/game_local_data_source.dart';
import 'package:card_match/features/card_match/data/repositories/game_repository_impl.dart';
import 'package:card_match/features/card_match/domain/repositories/game_repository.dart';
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

  final box = Hive.box('game_box');

  final localDataSource = GameLocalDataSource(box);

  final gameRepository = GameRepositoryImpl(localDataSource: localDataSource);

  final getStatisticsUseCase = GetStatisticsUseCase(repository: gameRepository);

  final startGameUseCase = StartGameUseCase(repository: gameRepository);

  final saveGameResultUseCase = SaveGameResultUseCase(
    repository: gameRepository,
  );

  runApp(
    RepositoryProvider<GameRepository>(
      create: (_) => gameRepository,
      child: MemoryGameApp(
        getStatisticsUseCase: getStatisticsUseCase,
        startGameUseCase: startGameUseCase,
        saveGameResultUseCase: saveGameResultUseCase,
      ),
    ),
  );
}

class MemoryGameApp extends StatelessWidget {
  final GetStatisticsUseCase getStatisticsUseCase;
  final StartGameUseCase startGameUseCase;
  final SaveGameResultUseCase saveGameResultUseCase;

  const MemoryGameApp({
    super.key,
    required this.getStatisticsUseCase,
    required this.startGameUseCase,
    required this.saveGameResultUseCase,
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
      ),
    );
  }
}
