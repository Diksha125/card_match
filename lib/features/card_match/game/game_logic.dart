import 'dart:math';

import 'package:card_match/features/card_match/domain/entities/card_entity.dart';
import 'package:card_match/features/card_match/domain/entities/game_difficulty.dart';

class GameLogic {
  static const List<String> _symbols = [
    '🐶',
    '🐱',
    '🐸',
    '🐼',
    '🦊',
    '🐰',
    '🐯',
    '🐨',
    '🦁',
    '🐵',
    '🐷',
    '🐙',
  ];

  List<CardEntity> createCards(GameDifficulty gameDifficulty) {
    final requiredPairs = gameDifficulty.pairs;
    final selectedSymbols = _symbols.take(requiredPairs).toList();

    final cards = <CardEntity>[];
    int id = 0;

    for (final symbol in selectedSymbols) {
      cards.add(CardEntity(id: id++, value: symbol));
      cards.add(CardEntity(id: id++, value: symbol));
    }

    cards.shuffle(Random());

    return cards;
  }

  bool isMatch(CardEntity first, CardEntity second) {
    return first.value == second.value;
  }

  bool isGameWon(List<CardEntity> cards) {
    return cards.isNotEmpty && cards.every((card) => card.isMatched);
  }

  int calculateMatchScore({
    required GameDifficulty difficulty,
    required int moves,
    required int seconds,
  }) {
    final baseScore = difficulty.baseScore;
    final movePenalty = moves * 5;
    final timePenalty = seconds * 2;
    final score = baseScore - movePenalty - timePenalty;

    return max(10, score);
  }

  List<CardEntity> getUnmatchedFlippedCards(List<CardEntity> cards) {
    return cards.where((card) => card.isFlipped && !card.isMatched).toList();
  }

  List<CardEntity> flipCard(List<CardEntity> cards, int cardId) {
    return cards.map((card) {
      if (card.id == cardId) {
        return card.copyWith(isFlipped: true);
      }

      return card;
    }).toList();
  }

  List<CardEntity> markCardsAsMatched(
    List<CardEntity> cards,
    int firstCardId,
    int secondCardId,
  ) {
    return cards.map((card) {
      if (card.id == firstCardId || card.id == secondCardId) {
        return card.copyWith(isMatched: true);
      }

      return card;
    }).toList();
  }

  List<CardEntity> hideCards(
    List<CardEntity> cards,
    int firstCardId,
    int secondCardId,
  ) {
    return cards.map((card) {
      if (card.id == firstCardId || card.id == secondCardId) {
        return card.copyWith(isFlipped: false);
      }

      return card;
    }).toList();
  }
}
