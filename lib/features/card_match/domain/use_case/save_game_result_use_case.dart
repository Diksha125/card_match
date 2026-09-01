import 'package:card_match/features/card_match/domain/entities/difficulty_statistics.dart';
import 'package:card_match/features/card_match/domain/entities/game_difficulty.dart';
import 'package:card_match/features/card_match/domain/repositories/game_repository.dart';

class SaveGameResultUseCase {
  final GameRepository repository;

  SaveGameResultUseCase({required this.repository});

  Future<DifficultyStatistics> call({
    required GameDifficulty difficulty,
    required int score,
    required int seconds,
  }) async {
    final current = repository.getStatistics(difficulty);

    final updated = current.copyWith(
      bestScore: score > current.bestScore ? score : current.bestScore,
      bestTime: current.bestTime == 0 || seconds < current.bestTime
          ? seconds
          : current.bestTime,
      gamesWon: current.gamesWon + 1,
    );

    await repository.saveStatistics(updated);

    return updated;
  }
}
