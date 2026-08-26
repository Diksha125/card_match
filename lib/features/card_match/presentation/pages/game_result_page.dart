import 'package:card_match/features/card_match/presentation/widgets/achievement.dart';
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
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🏆', style: TextStyle(fontSize: 90)),

              const SizedBox(height: 20),

              const Text(
                'You Won!',
                style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              const Text(
                'Great memory!',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),

              const SizedBox(height: 40),

              Row(
                children: [
                  StatCard(title: 'Score', value: '$score', icon: Icons.stars),

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

              if (isNewBestScore) const Achievement(text: '🎉 NEW BEST SCORE!'),

              if (isNewBestTime) const Achievement(text: '⚡ NEW BEST TIME!'),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, ResultAction.playAgain);
                  },
                  child: const Text(
                    'PLAY AGAIN',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                  child: const Text('HOME', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
