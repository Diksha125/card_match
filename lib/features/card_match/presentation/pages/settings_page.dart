import 'package:card_match/features/card_match/domain/entities/game_settings.dart';
import 'package:card_match/features/card_match/presentation/bloc/settings/settings_bloc.dart';
import 'package:card_match/features/card_match/presentation/bloc/settings/settings_event.dart';
import 'package:card_match/features/card_match/presentation/bloc/settings/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          final settings = state.settings;

          return ListView(
            children: [
              SwitchListTile(
                title: const Text('Sound Effects'),
                subtitle: const Text('Card flips, matches and victory sounds'),
                secondary: const Icon(Icons.volume_up),
                value: settings.soundEnabled,
                onChanged: (value) {
                  _updateSettings(
                    context,
                    settings.copyWith(soundEnabled: value),
                  );
                },
              ),

              SwitchListTile(
                title: const Text('Background Music'),
                subtitle: const Text('Play music while gaming'),
                secondary: const Icon(Icons.music_note),
                value: settings.musicEnabled,
                onChanged: (value) {
                  _updateSettings(
                    context,
                    settings.copyWith(musicEnabled: value),
                  );
                },
              ),

              SwitchListTile(
                title: const Text('Vibration'),
                subtitle: const Text('Vibrate when matching cards'),
                secondary: const Icon(Icons.vibration),
                value: settings.vibrationEnabled,
                onChanged: (value) {
                  _updateSettings(
                    context,
                    settings.copyWith(vibrationEnabled: value),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  void _updateSettings(BuildContext context, GameSettings settings) {
    context.read<SettingsBloc>().add(UpdateSettings(settings));
  }
}
