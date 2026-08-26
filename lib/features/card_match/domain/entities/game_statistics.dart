import 'package:equatable/equatable.dart';

class GameStatistics extends Equatable {
  final int bestScore;
  final int bestTime;
  final int gamesPlayed;
  final int gamesWon;

  const GameStatistics({
    this.bestScore = 0,
    this.bestTime = 0,
    this.gamesPlayed = 0,
    this.gamesWon = 0,
  });

  GameStatistics copyWith({
    int? bestScore,
    int? bestTime,
    int? gamesPlayed,
    int? gamesWon,
  }) {
    return GameStatistics(
      bestScore: bestScore ?? this.bestScore,
      bestTime: bestTime ?? this.bestTime,
      gamesPlayed: gamesPlayed ?? this.gamesPlayed,
      gamesWon: gamesWon ?? this.gamesWon,
    );
  }

  @override
  List<Object> get props => [bestScore, bestTime, gamesPlayed, gamesWon];
}
