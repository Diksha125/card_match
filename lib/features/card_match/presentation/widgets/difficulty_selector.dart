import 'package:card_match/core/theme/app_colors.dart';
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

        SizedBox(
          width: double.infinity,
          child: SegmentedButton<GameDifficulty>(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.black;
                }

                return AppColors.white;
              }),
              foregroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.white;
                }

                return AppColors.black;
              }),
            ),
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
        ),
      ],
    );
  }
}
