import 'package:equatable/equatable.dart';

class GameSettings extends Equatable {
  final bool soundEnabled;
  final bool musicEnabled;
  final bool vibrationEnabled;

  const GameSettings({
    this.soundEnabled = true,
    this.musicEnabled = true,
    this.vibrationEnabled = true,
  });

  GameSettings copyWith({
    bool? soundEnabled,
    bool? musicEnabled,
    bool? vibrationEnabled,
  }) {
    return GameSettings(
      soundEnabled:
      soundEnabled ?? this.soundEnabled,
      musicEnabled:
      musicEnabled ?? this.musicEnabled,
      vibrationEnabled:
      vibrationEnabled ??
          this.vibrationEnabled,
    );
  }

  @override
  List<Object> get props => [
    soundEnabled,
    musicEnabled,
    vibrationEnabled,
  ];
}