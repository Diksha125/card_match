import 'package:card_match/features/card_match/domain/entities/difficulty_statistics.dart';
import 'package:card_match/features/card_match/domain/entities/game_difficulty.dart';
import 'package:card_match/features/card_match/domain/repositories/game_repository.dart';

class StartGameUseCase {
  final GameRepository repository;

  StartGameUseCase({required this.repository});

  Future<DifficultyStatistics> call({
    required GameDifficulty difficulty,
  }) async {
    final current = repository.getStatistics(difficulty);

    final updated = current.copyWith(gamesPlayed: current.gamesPlayed + 1);

    await repository.saveStatistics(updated);

    return updated;
  }
}
