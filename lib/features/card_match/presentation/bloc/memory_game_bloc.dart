import 'dart:async';

import 'package:card_match/features/card_match/core/services/audio_service.dart';
import 'package:card_match/features/card_match/domain/entities/card_entity.dart';
import 'package:card_match/features/card_match/domain/entities/game_difficulty.dart';
import 'package:card_match/features/card_match/domain/entities/game_statistics.dart';
import 'package:card_match/features/card_match/domain/use_case/get_settings_use_case.dart';
import 'package:card_match/features/card_match/domain/use_case/get_statistics_use_case.dart';
import 'package:card_match/features/card_match/domain/use_case/save_game_result_use_case.dart';
import 'package:card_match/features/card_match/domain/use_case/start_game_use_case.dart';
import 'package:card_match/features/card_match/game/game_logic.dart';
import 'package:card_match/features/card_match/presentation/bloc/memory_game_event.dart';
import 'package:card_match/features/card_match/presentation/bloc/memory_game_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MemoryGameBloc extends Bloc<MemoryGameEvent, MemoryGameState> {
  final GameLogic _gameLogic;

  final GetStatisticsUseCase _getStatisticsUseCase;

  final StartGameUseCase _startGameUseCase;

  final SaveGameResultUseCase _saveGameResultUseCase;

  final AudioService _audioService;

  Timer? _timer;

  MemoryGameBloc({
    GameLogic? gameLogic,
    required GetStatisticsUseCase getStatisticsUseCase,
    required StartGameUseCase startGameUseCase,
    required SaveGameResultUseCase saveGameResultUseCase,
    required GetSettingsUseCase getSettingsUseCase,
    required AudioService audioService,
  }) : _audioService = audioService,
       _gameLogic = gameLogic ?? GameLogic(),
       _getStatisticsUseCase = getStatisticsUseCase,
       _startGameUseCase = startGameUseCase,
       _saveGameResultUseCase = saveGameResultUseCase,
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
    final updatedStats = await _startGameUseCase(difficulty: event.difficulty);

    final updatedAllStats = state.statistics.copyWithDifficulty(updatedStats);

    emit(state.copyWith(statistics: updatedAllStats));

    _startNewGame(emit, difficulty: event.difficulty);

    _audioService.startMusic();
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

    if (tappedCard.isFlipped) {
      return;
    }

    if (tappedCard.isMatched) {
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

    _playSound(_audioService.playCardFlip);

    if (flippedCards.isEmpty) {
      return;
    }

    final firstCard = flippedCards.first;

    final secondCard = tappedCard;

    final newMoves = state.moves + 1;

    emit(state.copyWith(isCheckingMatch: true, moves: newMoves));

    final isMatch = _gameLogic.isMatch(firstCard, secondCard);

    if (isMatch) {
      _playSound(_audioService.playMatch);

      await Future.delayed(const Duration(milliseconds: 250));

      if (isClosed) {
        return;
      }

      final matchedCards = List<CardEntity>.from(state.cards);

      final firstIndex = matchedCards.indexWhere(
        (card) => card.id == firstCard.id,
      );

      final secondIndex = matchedCards.indexWhere(
        (card) => card.id == secondCard.id,
      );

      if (firstIndex == -1 || secondIndex == -1) {
        emit(state.copyWith(isCheckingMatch: false));

        return;
      }

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

      if (won) {
        _stopTimer();

        await _audioService.stopMusic();

        _audioService.playVictory();

        final updatedStats = await _saveGameResultUseCase(
          difficulty: state.difficulty,
          score: newScore,
          seconds: state.seconds,
        );

        if (isClosed) {
          return;
        }

        final updatedAllStats = state.statistics.copyWithDifficulty(
          updatedStats,
        );

        emit(
          state.copyWith(
            cards: matchedCards,
            score: newScore,
            status: GameStatus.won,
            isCheckingMatch: false,
            statistics: updatedAllStats,
          ),
        );

        return;
      }

      emit(
        state.copyWith(
          cards: matchedCards,
          score: newScore,
          isCheckingMatch: false,
        ),
      );

      return;
    } else {
      _playSound(_audioService.playMismatch);
    }

    await Future.delayed(const Duration(milliseconds: 800));

    if (isClosed) {
      return;
    }

    final resetCards = List<CardEntity>.from(state.cards);

    final firstIndex = resetCards.indexWhere((card) => card.id == firstCard.id);

    final secondIndex = resetCards.indexWhere(
      (card) => card.id == secondCard.id,
    );

    if (firstIndex != -1) {
      resetCards[firstIndex] = resetCards[firstIndex].copyWith(
        isFlipped: false,
      );
    }

    if (secondIndex != -1) {
      resetCards[secondIndex] = resetCards[secondIndex].copyWith(
        isFlipped: false,
      );
    }

    emit(state.copyWith(cards: resetCards, isCheckingMatch: false));
  }

  void _onPauseGame(PauseGame event, Emitter<MemoryGameState> emit) {
    if (state.status != GameStatus.playing) {
      return;
    }

    _startTimer();

    _audioService.pauseMusic();

    emit(state.copyWith(status: GameStatus.paused));
  }

  void _onResumeGame(ResumeGame event, Emitter<MemoryGameState> emit) {
    if (state.status != GameStatus.paused) {
      return;
    }

    _audioService.resumeMusic();

    emit(state.copyWith(status: GameStatus.playing));

    _startTimer();
  }

  void _onLoadGameStats(LoadGameStats event, Emitter<MemoryGameState> emit) {
    var statistics = GameStatistics();

    for (final difficulty in GameDifficulty.values) {
      final difficultyStats = _getStatisticsUseCase(difficulty);

      statistics = statistics.copyWithDifficulty(difficultyStats);
    }

    emit(state.copyWith(statistics: statistics));
  }

  Future<void> _playSound(Future<void> Function() sound) async {
    _audioService.playCardFlip();

    await sound();
  }

  @override
  Future<void> close() {
    _stopTimer();
    return super.close();
  }
}
