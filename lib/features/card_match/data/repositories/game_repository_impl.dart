import 'package:card_match/features/card_match/data/datasources/game_local_data_source.dart';
import 'package:card_match/features/card_match/domain/repositories/game_repository.dart';

class GameRepositoryImpl implements GameRepository {
  final GameLocalDataSource localDataSource;

  GameRepositoryImpl({required this.localDataSource});

  @override
  int getBestScore() {
    return localDataSource.getBestScore();
  }

  @override
  int getBestTime() {
    return localDataSource.getBestTime();
  }

  @override
  int getGamesPlayed() {
    return localDataSource.getGamesPlayed();
  }

  @override
  int getGamesWon() {
    return localDataSource.getGamesWon();
  }

  @override
  Future<void> saveBestScore(int score) {
    return localDataSource.saveBestScore(score);
  }

  @override
  Future<void> saveBestTime(int seconds) {
    return localDataSource.saveBestTime(seconds);
  }

  @override
  Future<void> incrementGamesPlayed() {
    return localDataSource.incrementGamesPlayed();
  }

  @override
  Future<void> incrementGamesWon() {
    return localDataSource.incrementGamesWon();
  }
}
