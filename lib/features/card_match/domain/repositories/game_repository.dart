abstract class GameRepository {
  int getBestScore();

  int getBestTime();

  int getGamesPlayed();

  int getGamesWon();

  Future<void> saveBestScore(int score);

  Future<void> saveBestTime(int seconds);

  Future<void> incrementGamesPlayed();

  Future<void> incrementGamesWon();
}