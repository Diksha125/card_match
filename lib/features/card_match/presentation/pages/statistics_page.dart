import 'package:card_match/features/card_match/domain/entities/game_statistics.dart';
import 'package:card_match/features/card_match/presentation/widgets/result_card.dart';
import 'package:flutter/material.dart';

class StatisticsPage extends StatelessWidget {
  final GameStatistics statistics;

  const StatisticsPage({super.key, required this.statistics});

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
    return Scaffold(
      appBar: AppBar(title: const Text('Statistics')),
      body: GridView.count(
        padding: const EdgeInsets.all(20),
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          StatCard(
            icon: Icons.emoji_events,
            title: 'Best Score',
            value: '${statistics.bestScore}',
          ),
          StatCard(
            icon: Icons.timer,
            title: 'Best Time',
            value: _formatTime(statistics.bestTime),
          ),
          StatCard(
            icon: Icons.sports_esports,
            title: 'Games Played',
            value: '${statistics.gamesPlayed}',
          ),
          StatCard(
            icon: Icons.check_circle,
            title: 'Games Won',
            value: '${statistics.gamesWon}',
          ),
          // StatCard(
          //   icon: Icons.percent,
          //   title: 'Win Rate',
          //   value: '${statistics.winRate.toStringAsFixed(1)}%',
          // ),
        ],
      ),
    );
  }
}
