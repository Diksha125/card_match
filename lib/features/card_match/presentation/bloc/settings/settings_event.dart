import 'package:card_match/features/card_match/domain/entities/game_settings.dart';
import 'package:equatable/equatable.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class LoadSettings extends SettingsEvent {
  const LoadSettings();
}

class UpdateSettings extends SettingsEvent {
  final GameSettings settings;

  const UpdateSettings(this.settings);

  @override
  List<Object> get props => [settings];
}
