import 'package:card_match/features/card_match/domain/entities/game_difficulty.dart';
import 'package:card_match/features/card_match/domain/entities/game_statistics.dart';
import 'package:card_match/features/card_match/presentation/bloc/memory_game_bloc.dart';
import 'package:card_match/features/card_match/presentation/bloc/memory_game_event.dart';
import 'package:card_match/features/card_match/presentation/bloc/memory_game_state.dart';
import 'package:card_match/features/card_match/presentation/widgets/difficulty_selector.dart';
import 'package:card_match/features/card_match/presentation/widgets/difficulty_statistics_card.dart';
import 'package:card_match/features/card_match/presentation/widgets/statistics_overview_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  GameDifficulty _selectedDifficulty = GameDifficulty.easy;

  @override
  void initState() {
    super.initState();

    context.read<MemoryGameBloc>().add(const LoadGameStats());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Statistics')),
      body: BlocBuilder<MemoryGameBloc, MemoryGameState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),

                const SizedBox(height: 12),

                _buildOverview(state.statistics),

                const SizedBox(height: 12),

                DifficultySelector(
                  selectedDifficulty: _selectedDifficulty,
                  onChanged: (difficulty) {
                    setState(() {
                      _selectedDifficulty = difficulty;
                    });
                  },
                ),

                const SizedBox(height: 12),

                DifficultyStatisticsCard(
                  statistics: state.statistics.get(_selectedDifficulty),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Statistics',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(
          'Track your memory game performance',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildOverview(GameStatistics statistics) {
    int gamesPlayed = 0;
    int gamesWon = 0;
    int bestScore = 0;

    for (final difficulty in GameDifficulty.values) {
      final stats = statistics.get(difficulty);

      gamesPlayed += stats.gamesPlayed;
      gamesWon += stats.gamesWon;

      if (stats.bestScore > bestScore) {
        bestScore = stats.bestScore;
      }
    }

    final winRate = gamesPlayed == 0
        ? 0
        : ((gamesWon / gamesPlayed) * 100).round();

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.3,
      children: [
        StatisticsOverviewCard(
          title: 'Games Played',
          value: '$gamesPlayed',
          icon: Icons.sports_esports_outlined,
        ),
        StatisticsOverviewCard(
          title: 'Games Won',
          value: '$gamesWon',
          icon: Icons.emoji_events_outlined,
        ),
        StatisticsOverviewCard(
          title: 'Win Rate',
          value: '$winRate%',
          icon: Icons.trending_up,
        ),
        StatisticsOverviewCard(
          title: 'Best Score',
          value: '$bestScore',
          icon: Icons.star_outline,
        ),
      ],
    );
  }
}
