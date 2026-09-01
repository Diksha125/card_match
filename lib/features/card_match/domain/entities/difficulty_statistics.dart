import 'package:card_match/features/card_match/domain/entities/game_difficulty.dart';
import 'package:equatable/equatable.dart';

class DifficultyStatistics extends Equatable {
  final GameDifficulty difficulty;
  final int bestScore;
  final int bestTime;
  final int gamesPlayed;
  final int gamesWon;

  const DifficultyStatistics({
    required this.difficulty,
    this.bestScore = 0,
    this.bestTime = 0,
    this.gamesPlayed = 0,
    this.gamesWon = 0,
  });

  double get winRate {
    if (gamesPlayed == 0) {
      return 0;
    }

    return (gamesWon / gamesPlayed) * 100;
  }

  DifficultyStatistics copyWith({
    int? bestScore,
    int? bestTime,
    int? gamesPlayed,
    int? gamesWon,
  }) {
    return DifficultyStatistics(
      difficulty: difficulty,
      bestScore: bestScore ?? this.bestScore,
      bestTime: bestTime ?? this.bestTime,
      gamesPlayed: gamesPlayed ?? this.gamesPlayed,
      gamesWon: gamesWon ?? this.gamesWon,
    );
  }

  @override
  List<Object?> get props => [
    difficulty,
    bestScore,
    bestTime,
    gamesPlayed,
    gamesWon,
  ];
}
