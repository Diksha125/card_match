import 'package:card_match/features/card_match/presentation/bloc/memory_game_bloc.dart';
import 'package:card_match/features/card_match/presentation/bloc/memory_game_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PauseOverlay extends StatelessWidget {
  const PauseOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.black54,
        child: Center(
          child: Card(
            margin: const EdgeInsets.all(32),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.pause_circle_filled, size: 70),

                  const SizedBox(height: 20),

                  const Text(
                    'Game Paused',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        context.read<MemoryGameBloc>().add(const ResumeGame());
                      },
                      child: const Text('Resume'),
                    ),
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        context.read<MemoryGameBloc>().add(const RestartGame());
                      },
                      child: const Text('Restart'),
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Home'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
