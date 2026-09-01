import 'package:card_match/features/card_match/domain/entities/difficulty_statistics.dart';
import 'package:card_match/features/card_match/domain/entities/game_difficulty.dart';
import 'package:card_match/features/card_match/domain/entities/game_statistics.dart';
import 'package:card_match/features/card_match/presentation/widgets/result_card.dart';
import 'package:flutter/material.dart';

class StatisticsPage extends StatefulWidget {
  final GameStatistics statistics;

  const StatisticsPage({super.key, required this.statistics});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  GameDifficulty _selectedDifficulty = GameDifficulty.medium;

  DifficultyStatistics get _currentStats {
    return widget.statistics.get(_selectedDifficulty);
  }

  String _formatTime(int seconds) {
    if (seconds == 0) {
      return '--:--';
    }

    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final stats = _currentStats;

    return Scaffold(
      appBar: AppBar(title: const Text('Statistics'), centerTitle: true),

      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Text(
                    'Your Performance',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Statistics for ${_selectedDifficulty.title}',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),

                  const SizedBox(height: 30),

                  SegmentedButton<GameDifficulty>(
                    segments: const [
                      ButtonSegment<GameDifficulty>(
                        value: GameDifficulty.easy,
                        label: Text('Easy'),
                        icon: Icon(Icons.sentiment_satisfied),
                      ),
                      ButtonSegment<GameDifficulty>(
                        value: GameDifficulty.medium,
                        label: Text('Medium'),
                        icon: Icon(Icons.sentiment_neutral),
                      ),
                      ButtonSegment<GameDifficulty>(
                        value: GameDifficulty.hard,
                        label: Text('Hard'),
                        icon: Icon(Icons.local_fire_department),
                      ),
                    ],

                    selected: {_selectedDifficulty},

                    onSelectionChanged: (selection) {
                      setState(() {
                        _selectedDifficulty = selection.first;
                      });
                    },
                  ),

                  const SizedBox(height: 30),

                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.25,
                    children: [
                      StatCard(
                        icon: Icons.emoji_events,
                        title: 'Best Score',
                        value: '${stats.bestScore}',
                      ),

                      StatCard(
                        icon: Icons.timer,
                        title: 'Best Time',
                        value: _formatTime(stats.bestTime),
                      ),

                      StatCard(
                        icon: Icons.sports_esports,
                        title: 'Games Played',
                        value: '${stats.gamesPlayed}',
                      ),

                      StatCard(
                        icon: Icons.check_circle,
                        title: 'Games Won',
                        value: '${stats.gamesWon}',
                      ),

                      StatCard(
                        icon: Icons.percent,
                        title: 'Win Rate',
                        value: '${stats.winRate.toStringAsFixed(1)}%',
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  _PerformanceMessage(stats: stats),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PerformanceMessage extends StatelessWidget {
  final DifficultyStatistics stats;

  const _PerformanceMessage({required this.stats});

  String get _message {
    if (stats.gamesPlayed == 0) {
      return 'Start playing to see your statistics!';
    }

    if (stats.winRate >= 80) {
      return '🔥 Excellent! Your memory is amazing!';
    }

    if (stats.winRate >= 50) {
      return '👏 Great job! Keep improving!';
    }

    return '💪 Keep practicing. You will get better!';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            const Text('💡', style: TextStyle(fontSize: 30)),

            const SizedBox(width: 16),

            Expanded(
              child: Text(_message, style: const TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
