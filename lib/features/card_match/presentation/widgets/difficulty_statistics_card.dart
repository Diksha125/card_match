import 'package:card_match/features/card_match/domain/entities/difficulty_statistics.dart';
import 'package:card_match/features/card_match/domain/entities/game_difficulty.dart';
import 'package:flutter/material.dart';

class DifficultyStatisticsCard extends StatelessWidget {
  final DifficultyStatistics statistics;

  const DifficultyStatisticsCard({super.key, required this.statistics});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              statistics.difficulty.title,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            _buildDetailRow('Best Score', '${statistics.bestScore}'),

            _buildDetailRow('Best Time', _formatTime(statistics.bestTime)),

            _buildDetailRow('Games Played', '${statistics.gamesPlayed}'),

            _buildDetailRow('Games Won', '${statistics.gamesWon}'),

            _buildDetailRow('Win Rate', '${statistics.winRate.round()}%'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(child: Text(title)),
          const SizedBox(width: 16),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
