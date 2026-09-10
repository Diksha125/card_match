import 'package:card_match/features/card_match/domain/entities/game_difficulty.dart';
import 'package:flutter/material.dart';

class DifficultySelector extends StatelessWidget {
  final GameDifficulty selectedDifficulty;
  final ValueChanged<GameDifficulty> onChanged;

  const DifficultySelector({
    super.key,
    required this.selectedDifficulty,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Difficulty',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SegmentedButton<GameDifficulty>(
          segments: GameDifficulty.values
              .map(
                (difficulty) => ButtonSegment<GameDifficulty>(
                  value: difficulty,
                  label: Text(difficulty.title),
                ),
              )
              .toList(),
          selected: {selectedDifficulty},
          onSelectionChanged: (selection) {
            onChanged(selection.first);
          },
        ),
      ],
    );
  }
}
