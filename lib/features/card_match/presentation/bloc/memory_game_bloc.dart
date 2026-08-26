import 'dart:async';

import 'package:card_match/features/card_match/domain/entities/card_entity.dart';
import 'package:card_match/features/card_match/domain/entities/game_difficulty.dart';
import 'package:card_match/features/card_match/domain/entities/game_statistics.dart';
import 'package:card_match/features/card_match/domain/repositories/game_repository.dart';
import 'package:card_match/features/card_match/game/game_logic.dart';
import 'package:card_match/features/card_match/presentation/bloc/memory_game_event.dart';
import 'package:card_match/features/card_match/presentation/bloc/memory_game_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MemoryGameBloc extends Bloc<MemoryGameEvent, MemoryGameState> {
  final GameLogic _gameLogic;
  final GameRepository _gameRepository;

  Timer? _timer;

  MemoryGameBloc({GameLogic? gameLogic, required GameRepository gameRepository})
    : _gameLogic = gameLogic ?? GameLogic(),
      _gameRepository = gameRepository,
      super(const MemoryGameState()) {
    on<StartGame>(_onStartGame);
    on<RestartGame>(_onRestartGame);
    on<CardTapped>(_onCardTapped);
    on<TimerTicked>(_onTimerTicked);
    on<ChangeDifficulty>(_onChangeDifficulty);
    on<PauseGame>(_onPauseGame);
    on<ResumeGame>(_onResumeGame);
    on<LoadGameStats>(_onLoadGameStats);
  }

  // START GAME
  Future<void> _onStartGame(
    StartGame event,
    Emitter<MemoryGameState> emit,
  ) async {
    await _gameRepository.incrementGamesPlayed();

    _startNewGame(emit, difficulty: event.difficulty);
  }

  // RESTART GAME
  void _onRestartGame(RestartGame event, Emitter<MemoryGameState> emit) {
    _stopTimer();

    _startNewGame(emit, difficulty: state.difficulty);
  }

  // CHANGE DIFFICULTY
  void _onChangeDifficulty(
    ChangeDifficulty event,
    Emitter<MemoryGameState> emit,
  ) {
    debugPrint('Changing difficulty to: ${event.difficulty}');

    _stopTimer();

    _startNewGame(emit, difficulty: event.difficulty);
  }

  // CREATE NEW GAME
  void _startNewGame(
    Emitter<MemoryGameState> emit, {
    required GameDifficulty difficulty,
  }) async {
    final cards = _gameLogic.createCard(difficulty);

    emit(
      state.copyWith(
        cards: cards,
        status: GameStatus.playing,
        moves: 0,
        score: 0,
        seconds: 0,
        isCheckingMatch: false,
        difficulty: difficulty,
      ),
    );

    _startTimer();
  }

  // TIMER
  void _startTimer() {
    _stopTimer();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!isClosed) {
        add(const TimerTicked());
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _onTimerTicked(TimerTicked event, Emitter<MemoryGameState> emit) {
    if (state.status != GameStatus.playing) {
      return;
    }

    emit(state.copyWith(seconds: state.seconds + 1));
  }

  // CARD TAP
  Future<void> _onCardTapped(
    CardTapped event,
    Emitter<MemoryGameState> emit,
  ) async {
    if (state.isCheckingMatch) {
      return;
    }

    if (state.status != GameStatus.playing) {
      return;
    }

    final tappedIndex = state.cards.indexWhere(
      (card) => card.id == event.cardId,
    );

    if (tappedIndex == -1) {
      return;
    }

    final tappedCard = state.cards[tappedIndex];

    if (tappedCard.isFlipped || tappedCard.isMatched) {
      return;
    }

    final flippedCards = state.cards
        .where((card) => card.isFlipped && !card.isMatched)
        .toList();

    if (flippedCards.length >= 2) {
      return;
    }

    final updatedCards = List<CardEntity>.from(state.cards);

    updatedCards[tappedIndex] = tappedCard.copyWith(isFlipped: true);

    emit(state.copyWith(cards: updatedCards));

    // First card.
    if (flippedCards.isEmpty) {
      return;
    }

    // Second card.
    final firstCard = flippedCards.first;
    final secondCard = tappedCard;

    final newMoves = state.moves + 1;

    emit(state.copyWith(isCheckingMatch: true, moves: newMoves));

    // MATCH
    if (_gameLogic.isMatch(firstCard, secondCard)) {
      await Future.delayed(const Duration(milliseconds: 250));

      if (isClosed) return;

      final matchedCards = List<CardEntity>.from(state.cards);

      final firstIndex = matchedCards.indexWhere(
        (card) => card.id == firstCard.id,
      );

      final secondIndex = matchedCards.indexWhere(
        (card) => card.id == secondCard.id,
      );

      matchedCards[firstIndex] = matchedCards[firstIndex].copyWith(
        isMatched: true,
      );

      matchedCards[secondIndex] = matchedCards[secondIndex].copyWith(
        isMatched: true,
      );

      final won = _gameLogic.isGameWon(matchedCards);

      final matchScore = _gameLogic.calculateMatchScore(
        difficulty: state.difficulty,
        moves: newMoves,
        seconds: state.seconds,
      );

      final newScore = state.score + matchScore;

      final currentStats = state.statistics;

      final updatedStatistics = currentStats.copyWith(
        bestScore: newScore > currentStats.bestScore
            ? newScore
            : currentStats.bestScore,

        bestTime:
            currentStats.bestTime == 0 || state.seconds < currentStats.bestTime
            ? state.seconds
            : currentStats.bestTime,

        gamesWon: won ? currentStats.gamesWon + 1 : currentStats.gamesWon,
      );

      emit(
        state.copyWith(
          cards: matchedCards,
          score: newScore,
          status: won ? GameStatus.won : GameStatus.playing,
          isCheckingMatch: false,
          statistics: updatedStatistics,
        ),
      );

      return;
    }

    // NOT MATCH
    await Future.delayed(const Duration(milliseconds: 800));

    if (isClosed) return;

    final currentCards = List<CardEntity>.from(state.cards);

    final firstIndex = currentCards.indexWhere(
      (card) => card.id == firstCard.id,
    );

    final secondIndex = currentCards.indexWhere(
      (card) => card.id == secondCard.id,
    );

    if (firstIndex != -1) {
      currentCards[firstIndex] = currentCards[firstIndex].copyWith(
        isFlipped: false,
      );
    }

    if (secondIndex != -1) {
      currentCards[secondIndex] = currentCards[secondIndex].copyWith(
        isFlipped: false,
      );
    }

    emit(state.copyWith(cards: currentCards, isCheckingMatch: false));
  }

  void _onPauseGame(PauseGame event, Emitter<MemoryGameState> emit) {
    if (state.status != GameStatus.playing) {
      return;
    }

    _startTimer();

    emit(state.copyWith(status: GameStatus.paused));
  }

  void _onResumeGame(ResumeGame event, Emitter<MemoryGameState> emit) {
    if (state.status != GameStatus.paused) {
      return;
    }

    emit(state.copyWith(status: GameStatus.playing));

    _startTimer();
  }

  void _onLoadGameStats(LoadGameStats event, Emitter<MemoryGameState> emit) {
    final statistics = GameStatistics(
      bestScore: _gameRepository.getBestScore(),
      bestTime: _gameRepository.getBestTime(),
      gamesPlayed: _gameRepository.getGamesPlayed(),
      gamesWon: _gameRepository.getGamesWon(),
    );

    emit(state.copyWith(statistics: statistics));
  }

  @override
  Future<void> close() {
    _stopTimer();
    return super.close();
  }
}
