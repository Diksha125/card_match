import 'package:card_match/features/card_match/domain/entities/game_settings.dart';
import 'package:equatable/equatable.dart';

class SettingsState extends Equatable {
  final GameSettings settings;
  final bool isLoading;

  const SettingsState({
    this.settings = const GameSettings(),
    this.isLoading = false,
  });

  SettingsState copyWith({GameSettings? settings, bool? isLoading}) {
    return SettingsState(
      settings: settings ?? this.settings,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [settings, isLoading];
}
