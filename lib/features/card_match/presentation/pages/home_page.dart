import 'package:card_match/features/card_match/core/services/audio_service.dart';
import 'package:card_match/features/card_match/domain/entities/game_difficulty.dart';
import 'package:card_match/features/card_match/domain/use_case/get_settings_use_case.dart';
import 'package:card_match/features/card_match/domain/use_case/get_statistics_use_case.dart';
import 'package:card_match/features/card_match/domain/use_case/save_game_result_use_case.dart';
import 'package:card_match/features/card_match/domain/use_case/start_game_use_case.dart';
import 'package:card_match/features/card_match/presentation/bloc/home/home_bloc.dart';
import 'package:card_match/features/card_match/presentation/bloc/home/home_state.dart';
import 'package:card_match/features/card_match/presentation/pages/memory_game_page.dart';
import 'package:card_match/features/card_match/presentation/pages/settings_page.dart';
import 'package:card_match/features/card_match/presentation/pages/statistics_page.dart';
import 'package:card_match/features/card_match/presentation/widgets/difficulty_selection_sheet.dart';
import 'package:card_match/features/card_match/presentation/widgets/home_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  final GetStatisticsUseCase getStatisticsUseCase;
  final StartGameUseCase startGameUseCase;
  final SaveGameResultUseCase saveGameResultUseCase;
  final GetSettingsUseCase getSettingsUseCase;
  final AudioService audioService;

  const HomePage({
    super.key,
    required this.getStatisticsUseCase,
    required this.startGameUseCase,
    required this.saveGameResultUseCase,
    required this.getSettingsUseCase,
    required this.audioService,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 800;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isWide ? 32 : 20,
                vertical: 24,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 900),
                  child: Column(
                    children: [
                      _buildTopBar(context),

                      const SizedBox(height: 40),

                      _buildHero(),

                      const SizedBox(height: 40),

                      _buildPlayButton(context),

                      const SizedBox(height: 24),

                      _buildNavigationButtons(context, isWide),

                      const SizedBox(height: 32),

                      _buildBestScore(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: IconButton(
        tooltip: 'Settings',
        icon: const Icon(Icons.settings_outlined),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SettingsPage()),
          );
        },
      ),
    );
  }

  Widget _buildHero() {
    return Column(
      children: [
        const Text('🧠', style: TextStyle(fontSize: 80)),

        const SizedBox(height: 16),

        Text(
          'Memory Game',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 10),

        Text(
          'Remember the cards',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          'Test your memory and beat your best score!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildPlayButton(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 58,
      child: ElevatedButton.icon(
        onPressed: () {
          _showDifficultySelection(context);
        },
        icon: const Icon(Icons.play_arrow_rounded),
        label: const Text(
          'PLAY GAME',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildNavigationButtons(BuildContext context, bool isWide) {
    final statisticsButton = HomeActionButton(
      icon: Icons.bar_chart_rounded,
      title: 'Statistics',
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const StatisticsPage()),
        );
      },
    );

    final settingsButton = HomeActionButton(
      icon: Icons.settings_outlined,
      title: 'Settings',
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SettingsPage()),
        );
      },
    );

    return Row(
      children: [
        Expanded(child: statisticsButton),
        SizedBox(width: isWide ? 16 : 12),
        Expanded(child: settingsButton),
      ],
    );
  }

  Widget _buildBestScore() {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        var bestScore = 0;

        for (final difficulty in GameDifficulty.values) {
          final statistics = state.statistics.get(difficulty);

          if (statistics.bestScore > bestScore) {
            bestScore = statistics.bestScore;
          }
        }

        return Column(
          children: [
            Text(
              'YOUR BEST SCORE',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star_rounded, size: 28),
                const SizedBox(width: 8),
                Text(
                  '$bestScore',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _showDifficultySelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return DifficultySelectionSheet(
          onStart: (difficulty) {
            _startGame(context, difficulty);
          },
        );
      },
    );
  }

  void _startGame(BuildContext context, GameDifficulty difficulty) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MemoryGamePage(
          difficulty: difficulty,
          startGameUseCase: startGameUseCase,
          saveGameResultUseCase: saveGameResultUseCase,
          audioService: audioService,
        ),
      ),
    );
  }
}
