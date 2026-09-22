import 'package:card_match/features/card_match/domain/entities/card_entity.dart';
import 'package:card_match/features/card_match/domain/entities/game_difficulty.dart';
import 'package:card_match/features/card_match/domain/entities/game_statistics.dart';
import 'package:equatable/equatable.dart';

enum GameStatus { initial, playing, paused, won }

class MemoryGameState extends Equatable {
  final List<CardEntity> cards;
  final GameStatus status;
  final int moves;
  final int score;
  final int seconds;
  final bool isCheckingMatch;
  final GameDifficulty difficulty;
  final GameStatistics statistics;
  final bool isNewBestScore;
  final bool isNewBestTime;

  const MemoryGameState({
    this.cards = const [],
    this.status = GameStatus.initial,
    this.moves = 0,
    this.score = 0,
    this.seconds = 0,
    this.isCheckingMatch = false,
    this.difficulty = GameDifficulty.medium,
    this.statistics = const GameStatistics(),
    this.isNewBestScore = false,
    this.isNewBestTime = false,
  });

  bool get isGameActive => status == GameStatus.playing;

  bool get isPaused => status == GameStatus.paused;

  bool get isWon => status == GameStatus.won;

  MemoryGameState copyWith({
    List<CardEntity>? cards,
    GameStatus? status,
    int? moves,
    int? score,
    int? seconds,
    bool? isCheckingMatch,
    GameDifficulty? difficulty,
    GameStatistics? statistics,
    bool? isNewBestScore,
    bool? isNewBestTime,
  }) {
    return MemoryGameState(
      cards: cards ?? this.cards,
      status: status ?? this.status,
      moves: moves ?? this.moves,
      score: score ?? this.score,
      seconds: seconds ?? this.seconds,
      isCheckingMatch: isCheckingMatch ?? this.isCheckingMatch,
      difficulty: difficulty ?? this.difficulty,
      statistics: statistics ?? this.statistics,
      isNewBestScore: isNewBestScore ?? this.isNewBestScore,
      isNewBestTime: isNewBestTime ?? this.isNewBestTime,
    );
  }

  @override
  List<Object> get props => [
    cards,
    status,
    moves,
    score,
    seconds,
    isCheckingMatch,
    difficulty,
    statistics,
    isNewBestScore,
    isNewBestTime,
  ];
}
