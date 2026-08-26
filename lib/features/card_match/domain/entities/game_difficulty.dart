enum GameDifficulty {
  easy,
  medium,
  hard,
}

extension GameDifficultyExtension on GameDifficulty {
  int get pairs {
    switch (this) {
      case GameDifficulty.easy:
        return 4;
      case GameDifficulty.medium:
        return 8;
      case GameDifficulty.hard:
        return 12;
    }
  }

  int get columns {
    return 4;
  }

  String get title {
    switch (this) {
      case GameDifficulty.easy:
        return 'Easy';
      case GameDifficulty.medium:
        return 'Medium';
      case GameDifficulty.hard:
        return 'Hard';
    }
  }

  int get baseScore {
    switch (this) {
      case GameDifficulty.easy:
        return 50;
      case GameDifficulty.medium:
        return 100;
      case GameDifficulty.hard:
        return 150;
    }
  }
}