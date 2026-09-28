import 'package:card_match/features/card_match/core/services/audio_service.dart';
import 'package:card_match/features/card_match/core/theme/app_colors.dart';
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
import 'package:card_match/features/card_match/presentation/widgets/game_card.dart';
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
      backgroundColor: AppColors.lightBrown,
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
                      _buildHero(),

                      const SizedBox(height: 40),

                      _buildGameOptions(context, isWide),

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

  Widget _buildHero() {
    return Column(
      children: [
        Image.asset(
          'assets/images/raw_play_img.png',
          height: 150,
          fit: BoxFit.contain,
        ),

        const SizedBox(height: 8),

        Text(
          'Play. Think. Repeat.',
          style: TextStyle(
            color: AppColors.darkBrown,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildGameOptions(BuildContext context, bool isWide) {
    final cardFlip = GameCard(
      icon: Icons.grid_view_rounded,
      title: 'CardFlip Match',
      description: 'Test your memory by matching pairs of cards.',
      buttonText: 'PLAY NOW',
      onTap: () {
        _showDifficultySelection(context);
      },
    );

    final comingSoon = GameCard(
      icon: Icons.extension_rounded,
      title: 'More Games',
      description: 'New puzzles, arcade games and challenges are coming soon.',
      buttonText: 'COMING SOON',
      enabled: false,
      onTap: null,
    );

    if (isWide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: cardFlip),
          const SizedBox(width: 20),
          Expanded(child: comingSoon),
        ],
      );
    }

    return Column(children: [cardFlip, const SizedBox(height: 20), comingSoon]);
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
                color: AppColors.grey,
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
      backgroundColor: AppColors.lightBrown,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
