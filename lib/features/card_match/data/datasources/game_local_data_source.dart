import 'package:card_match/features/card_match/domain/entities/difficulty_statistics.dart';
import 'package:card_match/features/card_match/domain/entities/game_difficulty.dart';
import 'package:hive_ce/hive.dart';

class GameLocalDataSource {
  final Box _box;

  GameLocalDataSource(this._box);

  static const String bestScoreKey = 'best_score';
  static const String bestTimeKey = 'best_time';
  static const String gamesPlayedKey = 'games_played';
  static const String gamesWonKey = 'games_won';

  String _bestScoreKey(GameDifficulty difficulty) {
    return '${difficulty.name}_best_score';
  }

  String _bestTimeKey(GameDifficulty difficulty) {
    return '${difficulty.name}_best_time';
  }

  String _gamesPlayedKey(GameDifficulty difficulty) {
    return '${difficulty.name}_games_played';
  }

  String _gamesWonKey(GameDifficulty difficulty) {
    return '${difficulty.name}_games_won';
  }

  DifficultyStatistics getStatistics(GameDifficulty difficulty) {
    return DifficultyStatistics(
      difficulty: difficulty,
      bestScore: _box.get(_bestScoreKey(difficulty), defaultValue: 0) as int,
      bestTime: _box.get(_bestTimeKey(difficulty), defaultValue: 0) as int,
      gamesPlayed:
          _box.get(_gamesPlayedKey(difficulty), defaultValue: 0) as int,
      gamesWon: _box.get(_gamesWonKey(difficulty), defaultValue: 0) as int,
    );
  }

  Future<void> saveStatistics(DifficultyStatistics statistics) async {
    final difficulty = statistics.difficulty;

    await _box.put(_bestScoreKey(difficulty), statistics.bestScore);

    await _box.put(_bestTimeKey(difficulty), statistics.bestTime);

    await _box.put(_gamesPlayedKey(difficulty), statistics.gamesPlayed);

    await _box.put(_gamesWonKey(difficulty), statistics.gamesWon);
  }
}
