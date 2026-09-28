import 'package:card_match/core/theme/app_colors.dart';
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
      backgroundColor: AppColors.lightBrown,
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(color: AppColors.black, fontWeight: FontWeight.w700),
        ),
        backgroundColor: AppColors.lightBrown,
        foregroundColor: AppColors.black,
        elevation: 0,
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          final settings = state.settings;

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            children: [
              listTile(
                'Sound Effects',
                'Card flips, matches and victory sounds',
                Icons.volume_up,
                settings.soundEnabled,
                (value) {
                  _updateSettings(
                    context,
                    settings.copyWith(soundEnabled: value),
                  );
                },
              ),

              listTile(
                'Background Music',
                'Play music while gaming',
                Icons.music_note,
                settings.musicEnabled,
                (value) {
                  _updateSettings(
                    context,
                    settings.copyWith(musicEnabled: value),
                  );
                },
              ),

              listTile(
                'Vibration',
                'Vibrate when matching cards',
                Icons.vibration,
                settings.vibrationEnabled,
                (value) {
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

  Widget listTile(
    String title,
    String subTitle,
    IconData icon,
    bool value,
    Function(bool) onChange,
  ) {
    return Card(
      color: AppColors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SwitchListTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subTitle),
        secondary: Icon(icon, color: AppColors.darkBrown),
        activeThumbColor: AppColors.brown,
        value: value,
        onChanged: onChange,
      ),
    );
  }

  void _updateSettings(BuildContext context, GameSettings settings) {
    context.read<SettingsBloc>().add(UpdateSettings(settings));
  }
}
