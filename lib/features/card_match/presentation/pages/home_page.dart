import 'package:card_match/features/card_match/domain/entities/game_difficulty.dart';
import 'package:card_match/features/card_match/domain/use_case/get_statistics_use_case.dart';
import 'package:card_match/features/card_match/domain/use_case/save_game_result_use_case.dart';
import 'package:card_match/features/card_match/domain/use_case/start_game_use_case.dart';
import 'package:card_match/features/card_match/presentation/pages/memory_game_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final GetStatisticsUseCase getStatisticsUseCase;
  final StartGameUseCase startGameUseCase;
  final SaveGameResultUseCase saveGameResultUseCase;

  const HomePage({
    super.key,
    required this.getStatisticsUseCase,
    required this.startGameUseCase,
    required this.saveGameResultUseCase,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GameDifficulty _selectedDifficulty = GameDifficulty.medium;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(26),
          child: Center(
            child: Column(
              children: [
                const Text('🧠', style: TextStyle(fontSize: 80)),

                const SizedBox(height: 20),

                const Text(
                  'Memory Game',
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Remember the cards',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 40),

                const Text(
                  'Test your memory!',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),

                const SizedBox(height: 50),

                const Text(
                  'Select Difficulty',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 40),

                SegmentedButton<GameDifficulty>(
                  segments: const [
                    ButtonSegment(
                      value: GameDifficulty.easy,
                      label: Text('Easy'),
                      icon: Icon(Icons.mood),
                    ),
                    ButtonSegment(
                      value: GameDifficulty.medium,
                      label: Text('Medium'),
                      icon: Icon(Icons.star_half),
                    ),
                    ButtonSegment(
                      value: GameDifficulty.hard,
                      label: Text('Hard'),
                      icon: Icon(Icons.whatshot),
                    ),
                  ],
                  selected: {_selectedDifficulty},
                  onSelectionChanged: (selection) {
                    setState(() {
                      _selectedDifficulty = selection.first;
                    });
                  },
                ),

                const SizedBox(height: 50),

                SizedBox(
                  width: 220,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _startGame,
                    child: const Text(
                      'PLAY',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
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

  void _startGame() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MemoryGamePage(
          difficulty: _selectedDifficulty,
          getStatisticsUseCase: widget.getStatisticsUseCase,
          startGameUseCase: widget.startGameUseCase,
          saveGameResultUseCase: widget.saveGameResultUseCase,
        ),
      ),
    );
  }
}
