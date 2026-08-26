import 'package:hive_ce/hive.dart';

class GameLocalDataSource {
  final Box _box;

  GameLocalDataSource(this._box);

  static const String bestScoreKey = 'best_score';
  static const String bestTimeKey = 'best_time';
  static const String gamesPlayedKey = 'games_played';
  static const String gamesWonKey = 'games_won';

  int getBestScore() {
    return _box.get(bestScoreKey, defaultValue: 0) as int;
  }

  int getBestTime() {
    return _box.get(bestTimeKey, defaultValue: 0) as int;
  }

  int getGamesPlayed() {
    return _box.get(gamesPlayedKey, defaultValue: 0) as int;
  }

  int getGamesWon() {
    return _box.get(gamesWonKey, defaultValue: 0) as int;
  }

  Future<void> saveBestScore(int score) async {
    await _box.put(bestScoreKey, score);
  }

  Future<void> saveBestTime(int seconds) async {
    await _box.put(bestTimeKey, seconds);
  }

  Future<void> incrementGamesPlayed() async {
    final current = getGamesPlayed();

    await _box.put(gamesPlayedKey, current + 1);
  }

  Future<void> incrementGamesWon() async {
    final current = getGamesWon();

    await _box.put(gamesWonKey, current + 1);
  }
}
