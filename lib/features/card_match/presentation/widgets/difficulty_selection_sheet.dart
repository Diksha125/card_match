import 'package:card_match/features/card_match/core/theme/app_colors.dart';
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
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightBrown,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Padding(
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
                child: Text(
                  'START GAME',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
