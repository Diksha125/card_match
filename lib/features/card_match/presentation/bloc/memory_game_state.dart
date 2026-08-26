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

  const MemoryGameState({
    this.cards = const [],
    this.status = GameStatus.initial,
    this.moves = 0,
    this.score = 0,
    this.seconds = 0,
    this.isCheckingMatch = false,
    this.difficulty = GameDifficulty.medium,
    this.statistics = const GameStatistics(),
  });

  MemoryGameState copyWith({
    List<CardEntity>? cards,
    GameStatus? status,
    int? moves,
    int? score,
    int? seconds,
    bool? isCheckingMatch,
    GameDifficulty? difficulty,
    GameStatistics? statistics,
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
  ];
}
