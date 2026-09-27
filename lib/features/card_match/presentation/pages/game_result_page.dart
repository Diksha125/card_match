import 'package:card_match/features/card_match/core/theme/app_colors.dart';
import 'package:card_match/features/card_match/presentation/widgets/result_card.dart';
import 'package:flutter/material.dart';

enum ResultAction { playAgain, home }

class GameResultPage extends StatelessWidget {
  final int score;
  final int moves;
  final int seconds;
  final bool isNewBestScore;
  final bool isNewBestTime;

  const GameResultPage({
    super.key,
    required this.score,
    required this.moves,
    required this.seconds,
    required this.isNewBestScore,
    required this.isNewBestTime,
  });

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('🏆', style: TextStyle(fontSize: 90)),

                const SizedBox(height: 20),

                const Text(
                  'You Won!',
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  'Great memory!',
                  style: TextStyle(fontSize: 18, color: AppColors.grey),
                ),

                const SizedBox(height: 40),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    StatCard(
                      title: 'Score',
                      value: '$score',
                      icon: Icons.stars,
                    ),

                    StatCard(
                      title: 'Moves',
                      value: '$moves',
                      icon: Icons.touch_app,
                    ),

                    StatCard(
                      title: 'Time',
                      value: _formatTime(seconds),
                      icon: Icons.timer,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                if (isNewBestScore)
                  const Text(
                    '🎉 NEW BEST SCORE!',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),

                const SizedBox(height: 20),

                if (isNewBestTime)
                  const Text(
                    '⚡ NEW BEST TIME!',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context, ResultAction.playAgain);
                    },
                    child: Text(
                      'PLAY AGAIN',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context, ResultAction.home);
                    },
                    child: const Text(
                      'HOME',
                      style: TextStyle(fontSize: 16, color: AppColors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
