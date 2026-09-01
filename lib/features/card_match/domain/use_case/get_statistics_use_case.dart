import 'package:card_match/features/card_match/domain/entities/difficulty_statistics.dart';
import 'package:card_match/features/card_match/domain/entities/game_difficulty.dart';
import 'package:card_match/features/card_match/domain/repositories/game_repository.dart';

class GetStatisticsUseCase {
  final GameRepository repository;

  GetStatisticsUseCase({required this.repository});

  DifficultyStatistics call(GameDifficulty difficulty) {
    return repository.getStatistics(difficulty);
  }
}
