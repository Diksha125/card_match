import 'package:card_match/features/card_match/data/datasources/game_local_data_source.dart';
import 'package:card_match/features/card_match/data/repositories/game_repository_impl.dart';
import 'package:card_match/features/card_match/domain/entities/game_difficulty.dart';
import 'package:card_match/features/card_match/presentation/bloc/memory_game_bloc.dart';
import 'package:card_match/features/card_match/presentation/bloc/memory_game_event.dart';
import 'package:card_match/features/card_match/presentation/bloc/memory_game_state.dart';
import 'package:card_match/features/card_match/presentation/pages/game_result_page.dart';
import 'package:card_match/features/card_match/presentation/widgets/memory_card.dart';
import 'package:card_match/features/card_match/presentation/widgets/pause_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce/hive.dart';

class MemoryGamePage extends StatelessWidget {
  final GameDifficulty difficulty;
  const MemoryGamePage({super.key, required this.difficulty});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('game_box');
    final localDataSource = GameLocalDataSource(box);
    final repository = GameRepositoryImpl(localDataSource: localDataSource);

    return BlocProvider(
      create: (_) => MemoryGameBloc(gameRepository: repository)
        ..add(const LoadGameStats())
        ..add(StartGame(difficulty)),
      child: _MemoryGameView(),
    );
  }
}

class _MemoryGameView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          context.read<MemoryGameBloc>().add(PauseGame());
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Memory Game'), centerTitle: true),
        body: BlocListener<MemoryGameBloc, MemoryGameState>(
          listenWhen: (previous, current) =>
              previous.status != GameStatus.won &&
              current.status == GameStatus.won,
          listener: (context, state) async {
            if (state.status != GameStatus.won) {
              return;
            }

            final result = await Navigator.push<ResultAction>(
              context,
              MaterialPageRoute(
                builder: (_) => GameResultPage(
                  score: state.score,
                  moves: state.moves,
                  seconds: state.seconds,
                  isNewBestScore: state.score == state.statistics.bestScore,
                  isNewBestTime: state.seconds == state.statistics.bestTime,
                ),
              ),
            );

            if (!context.mounted) {
              return;
            }

            if (result == ResultAction.playAgain) {
              context.read<MemoryGameBloc>().add(const RestartGame());
            }

            if (result == ResultAction.home) {
              Navigator.pop(context);
            }
          },
          child: BlocBuilder<MemoryGameBloc, MemoryGameState>(
            builder: (context, state) {
              return Stack(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _GameInfo(
                                  label: 'Moves',
                                  value: '${state.moves}',
                                ),
                                SizedBox(width: 12),
                                _GameInfo(
                                  label: 'Score',
                                  value: '${state.score}',
                                ),
                                SizedBox(width: 12),
                                _GameInfo(
                                  label: 'Time',
                                  value: _formatTime(state.seconds),
                                ),
                              ],
                            ),

                            IconButton(
                              tooltip: 'Pause',
                              onPressed: state.status == GameStatus.playing
                                  ? () {
                                      context.read<MemoryGameBloc>().add(
                                        PauseGame(),
                                      );
                                    }
                                  : null,
                              icon: Icon(Icons.pause_rounded),
                            ),

                            ElevatedButton(
                              onPressed: () {
                                context.read<MemoryGameBloc>().add(
                                  const RestartGame(),
                                );
                              },
                              child: Text('Restart'),
                            ),
                          ],
                        ),
                      ),

                      Expanded(
                        child: GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: state.difficulty.columns,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                          itemCount: state.cards.length,
                          itemBuilder: (context, index) {
                            final card = state.cards[index];
                            return MemoryCard(
                              value: card.value,
                              isFlipped: card.isFlipped,
                              isMatched: card.isMatched,
                              onTap: state.status == GameStatus.playing
                                  ? () {
                                      context.read<MemoryGameBloc>().add(
                                        CardTapped(card.id),
                                      );
                                    }
                                  : null,
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  if (state.status == GameStatus.paused) const PauseOverlay(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

String _formatTime(int second) {
  final minutes = second ~/ 60;
  final remainingSeconds = second % 60;

  return '${minutes.toString().padLeft(2, '0')}:'
      '${remainingSeconds.toString().padLeft(2, '0')}';
}

class _GameInfo extends StatelessWidget {
  final String label;
  final String value;
  const _GameInfo({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
