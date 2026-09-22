import 'package:card_match/features/card_match/domain/entities/game_difficulty.dart';
import 'package:flutter/material.dart';

class DifficultySelectionSheet extends StatefulWidget {
  final GameDifficulty initialDifficulty;
  final ValueChanged<GameDifficulty> onStart;

  const DifficultySelectionSheet({
    super.key,
    this.initialDifficulty = GameDifficulty.medium,
    required this.onStart,
  });

  @override
  State<DifficultySelectionSheet> createState() =>
      _DifficultySelectionSheetState();
}

class _DifficultySelectionSheetState extends State<DifficultySelectionSheet> {
  late GameDifficulty _selectedDifficulty;

  @override
  void initState() {
    super.initState();
    _selectedDifficulty = widget.initialDifficulty;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Select Difficulty',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 24),

          SegmentedButton<GameDifficulty>(
            segments: GameDifficulty.values
                .map(
                  (difficulty) => ButtonSegment<GameDifficulty>(
                    value: difficulty,
                    label: Text(difficulty.title),
                  ),
                )
                .toList(),
            selected: {_selectedDifficulty},
            expandedInsets: EdgeInsets.zero,
            onSelectionChanged: (selection) {
              setState(() {
                _selectedDifficulty = selection.first;
              });
            },
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                widget.onStart(_selectedDifficulty);
              },
              child: const Text(
                'START GAME',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
