import 'package:card_match/features/card_match/domain/entities/difficulty_statistics.dart';
import 'package:card_match/features/card_match/domain/entities/game_difficulty.dart';
import 'package:equatable/equatable.dart';

class GameStatistics extends Equatable {
  final Map<GameDifficulty, DifficultyStatistics> byDifficulty;

  const GameStatistics({this.byDifficulty = const {}});

  DifficultyStatistics get(GameDifficulty difficulty) {
    return byDifficulty[difficulty] ??
        DifficultyStatistics(difficulty: difficulty);
  }

  GameStatistics copyWithDifficulty(DifficultyStatistics statistics) {
    final updated = Map<GameDifficulty, DifficultyStatistics>.from(
      byDifficulty,
    );

    updated[statistics.difficulty] = statistics;

    return GameStatistics(byDifficulty: updated);
  }

  @override
  List<Object> get props => [byDifficulty];
}
