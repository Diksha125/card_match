import 'dart:async';
import 'package:card_match/features/card_match/core/services/audio_service.dart';
import 'package:card_match/features/card_match/domain/entities/card_entity.dart';
import 'package:card_match/features/card_match/domain/entities/game_difficulty.dart';
import 'package:card_match/features/card_match/domain/use_case/save_game_result_use_case.dart';
import 'package:card_match/features/card_match/domain/use_case/start_game_use_case.dart';
import 'package:card_match/features/card_match/game/game_logic.dart';
import 'package:card_match/features/card_match/presentation/bloc/memory_game_event.dart';
import 'package:card_match/features/card_match/presentation/bloc/memory_game_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MemoryGameBloc extends Bloc<MemoryGameEvent, MemoryGameState> {
  final GameLogic _gameLogic;

  final StartGameUseCase _startGameUseCase;

  final SaveGameResultUseCase _saveGameResultUseCase;

  final AudioService _audioService;

  Timer? _timer;

  MemoryGameBloc({
    GameLogic? gameLogic,
    required StartGameUseCase startGameUseCase,
    required SaveGameResultUseCase saveGameResultUseCase,
    required AudioService audioService,
  }) : _audioService = audioService,
       _gameLogic = gameLogic ?? GameLogic(),
       _startGameUseCase = startGameUseCase,
       _saveGameResultUseCase = saveGameResultUseCase,
       super(const MemoryGameState()) {
    on<StartGame>(_onStartGame);
    on<RestartGame>(_onRestartGame);
    on<CardTapped>(_onCardTapped);
    on<TimerTicked>(_onTimerTicked);
    on<PauseGame>(_onPauseGame);
    on<ResumeGame>(_onResumeGame);
  }

  // START GAME
  Future<void> _onStartGame(
    StartGame event,
    Emitter<MemoryGameState> emit,
  ) async {
    final updatedStats = await _startGameUseCase(difficulty: event.difficulty);

    final updatedAllStats = state.statistics.copyWithDifficulty(updatedStats);

    emit(state.copyWith(statistics: updatedAllStats));

    await _startNewGame(emit, difficulty: event.difficulty);
  }

  // RESTART GAME
  Future<void> _onRestartGame(
    RestartGame event,
    Emitter<MemoryGameState> emit,
  ) async {
    await _startNewGame(emit, difficulty: state.difficulty);
  }

  // CREATE NEW GAME
  Future<void> _startNewGame(
    Emitter<MemoryGameState> emit, {
    required GameDifficulty difficulty,
  }) async {
    final cards = _gameLogic.createCards(difficulty);

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

    await _audioService.startMusic();

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
    // 1. Ignore taps while checking a pair.
    if (state.isCheckingMatch) return;

    // 2. Only allow taps while the game is playing.
    if (state.status != GameStatus.playing) return;

    // 3. Find the tapped card.
    final tappedIndex = state.cards.indexWhere(
      (card) => card.id == event.cardId,
    );
    if (tappedIndex == -1) return;
    final tappedCard = state.cards[tappedIndex];

    // 4. Ignore already flipped or matched cards.
    if (tappedCard.isFlipped) return;
    if (tappedCard.isMatched) return;

    // 5. Get the currently flipped unmatched cards.
    final flippedCards = _gameLogic.getUnmatchedFlippedCards(state.cards);

    // There should never be more than two, but this protects the game from an invalid state.
    if (flippedCards.length >= 2) return;

    // 6. Flip the tapped card.
    final updatedCards = _gameLogic.flipCard(state.cards, event.cardId);
    emit(state.copyWith(cards: updatedCards));

    // 7. Play flip sound.
    await _audioService.playCardFlip();

    // 8. This is the first card, so wait for the second tap.
    if (flippedCards.isEmpty) return;

    // 9. We now have a pair.
    final firstCard = flippedCards.first;
    final secondCard = tappedCard;
    final newMoves = state.moves + 1;
    emit(state.copyWith(isCheckingMatch: true, moves: newMoves));

    // 10. Check whether the cards match.
    final isMatch = _gameLogic.isMatch(firstCard, secondCard);

    if (isMatch) {
      await _handleMatch(
        firstCard: firstCard,
        secondCard: secondCard,
        newMoves: newMoves,
        emit: emit,
      );
      return;
    }

    // 11. Cards don't match.
    await _handleMismatch(
      firstCard: firstCard,
      secondCard: secondCard,
      emit: emit,
    );
  }

  Future<void> _handleMatch({
    required CardEntity firstCard,
    required CardEntity secondCard,
    required int newMoves,
    required Emitter<MemoryGameState> emit,
  }) async {
    await _audioService.playMatch();

    await Future.delayed(const Duration(milliseconds: 250));

    if (isClosed) return;

    final matchedCards = _gameLogic.markCardsAsMatched(
      state.cards,
      firstCard.id,
      secondCard.id,
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

      final currentStats = state.statistics.get(state.difficulty);

      final isNewBestScore =
          currentStats.bestScore == 0 || newScore > currentStats.bestScore;

      final isNewBestTime =
          currentStats.bestTime == 0 || state.seconds < currentStats.bestTime;

      await _audioService.stopMusic();
      await _audioService.playVictory();

      final updatedStats = await _saveGameResultUseCase(
        difficulty: state.difficulty,
        score: newScore,
        seconds: state.seconds,
      );

      if (isClosed) return;

      final updatedAllStats = state.statistics.copyWithDifficulty(updatedStats);

      emit(
        state.copyWith(
          cards: matchedCards,
          score: newScore,
          status: GameStatus.won,
          isCheckingMatch: false,
          statistics: updatedAllStats,
          isNewBestScore: isNewBestScore,
          isNewBestTime: isNewBestTime,
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
  }

  Future<void> _handleMismatch({
    required CardEntity firstCard,
    required CardEntity secondCard,
    required Emitter<MemoryGameState> emit,
  }) async {
    await _audioService.playMismatch();

    await Future.delayed(const Duration(milliseconds: 800));

    if (isClosed) return;

    final resetCards = _gameLogic.hideCards(
      state.cards,
      firstCard.id,
      secondCard.id,
    );

    emit(state.copyWith(cards: resetCards, isCheckingMatch: false));
  }

  void _onPauseGame(PauseGame event, Emitter<MemoryGameState> emit) {
    if (state.status != GameStatus.playing) {
      return;
    }

    _stopTimer();

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

  @override
  Future<void> close() {
    _stopTimer();
    return super.close();
  }
}
