import 'package:card_match/features/card_match/core/services/audio_service.dart';
import 'package:card_match/features/card_match/domain/use_case/get_settings_use_case.dart';
import 'package:card_match/features/card_match/domain/use_case/update_settings_use_case.dart';
import 'package:card_match/features/card_match/presentation/bloc/settings/settings_event.dart';
import 'package:card_match/features/card_match/presentation/bloc/settings/settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final AudioService _audioService;
  final GetSettingsUseCase _getSettingsUseCase;
  final UpdateSettingsUseCase _updateSettingsUseCase;

  SettingsBloc({
    required GetSettingsUseCase getSettingsUseCase,
    required UpdateSettingsUseCase updateSettingsUseCase,
    required AudioService audioService,
  }) : _getSettingsUseCase = getSettingsUseCase,
       _updateSettingsUseCase = updateSettingsUseCase,
       _audioService = audioService,
       super(const SettingsState()) {
    on<LoadSettings>(_onLoadSettings);
    on<UpdateSettings>(_onUpdateSettings);
  }

  void _onLoadSettings(LoadSettings event, Emitter<SettingsState> emit) {
    final settings = _getSettingsUseCase();

    _audioService.setSoundEnabled(settings.soundEnabled);

    _audioService.setMusicEnabled(settings.musicEnabled);

    emit(state.copyWith(settings: settings));
  }

  Future<void> _onUpdateSettings(
    UpdateSettings event,
    Emitter<SettingsState> emit,
  ) async {
    await _updateSettingsUseCase(event.settings);

    _audioService.setSoundEnabled(event.settings.soundEnabled);

    _audioService.setMusicEnabled(event.settings.musicEnabled);

    emit(state.copyWith(settings: event.settings));
  }
}
