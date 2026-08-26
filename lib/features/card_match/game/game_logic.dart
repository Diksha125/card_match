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

  List<CardEntity> createCard(GameDifficulty gameDifficulty) {
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
}
