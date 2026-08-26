import 'package:card_match/features/card_match/domain/entities/game_difficulty.dart';
import 'package:equatable/equatable.dart';

abstract class MemoryGameEvent extends Equatable {
  const MemoryGameEvent();

  @override
  List<Object> get props => [];
}

class StartGame extends MemoryGameEvent {
  final GameDifficulty difficulty;
  const StartGame(this.difficulty);
  @override
  List<Object> get props => [difficulty];
}

class CardTapped extends MemoryGameEvent {
  final int cardId;

  const CardTapped(this.cardId);

  @override
  List<Object> get props => [cardId];
}

class RestartGame extends MemoryGameEvent {
  const RestartGame();
}

class TimerTicked extends MemoryGameEvent {
  const TimerTicked();
}

class ChangeDifficulty extends MemoryGameEvent {
  final GameDifficulty difficulty;

  const ChangeDifficulty(this.difficulty);

  @override
  List<Object> get props => [difficulty];
}

class PauseGame extends MemoryGameEvent {
  const PauseGame();
}

class ResumeGame extends MemoryGameEvent {
  const ResumeGame();
}

class LoadGameStats extends MemoryGameEvent {
  const LoadGameStats();
}
