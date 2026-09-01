import 'package:card_match/features/card_match/data/datasources/game_local_data_source.dart';
import 'package:card_match/features/card_match/domain/entities/difficulty_statistics.dart';
import 'package:card_match/features/card_match/domain/entities/game_difficulty.dart';
import 'package:card_match/features/card_match/domain/repositories/game_repository.dart';

class GameRepositoryImpl implements GameRepository {
  final GameLocalDataSource localDataSource;

  GameRepositoryImpl({required this.localDataSource});

  @override
  DifficultyStatistics getStatistics(GameDifficulty difficulty) {
    return localDataSource.getStatistics(difficulty);
  }

  @override
  Future<void> saveStatistics(DifficultyStatistics statistics) {
    return localDataSource.saveStatistics(statistics);
  }
}
