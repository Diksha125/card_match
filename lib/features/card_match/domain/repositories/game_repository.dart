import 'package:card_match/features/card_match/domain/entities/difficulty_statistics.dart';
import 'package:card_match/features/card_match/domain/entities/game_difficulty.dart';

abstract class GameRepository {
  DifficultyStatistics getStatistics(GameDifficulty difficulty);

  Future<void> saveStatistics(DifficultyStatistics statistics);
}
