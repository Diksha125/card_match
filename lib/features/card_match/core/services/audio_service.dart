import 'package:audioplayers/audioplayers.dart';

class AudioService {
  final AudioPlayer _soundPlayer;

  bool _soundEnabled;

  AudioService({AudioPlayer? soundPlayer, bool soundEnabled = true})
    : _soundPlayer = soundPlayer ?? AudioPlayer(),
      _soundEnabled = soundEnabled;

  void setSoundEnabled(bool enabled) {
    _soundEnabled = enabled;
  }

  Future<void> playCardFlip() async {
    if (!_soundEnabled) {
      return;
    }

    await _playSound('card_flip.mp3');
  }

  Future<void> playMatch() async {
    if (!_soundEnabled) {
      return;
    }

    await _playSound('match.mp3');
  }

  Future<void> playMismatch() async {
    if (!_soundEnabled) {
      return;
    }

    await _playSound('mismatch.mp3');
  }

  Future<void> playVictory() async {
    if (!_soundEnabled) {
      return;
    }

    await _playSound('victory.mp3');
  }

  Future<void> playButton() async {
    if (!_soundEnabled) {
      return;
    }

    await _playSound('button.mp3');
  }

  Future<void> _playSound(String fileName) async {
    try {
      await _soundPlayer.play(AssetSource('audio/$fileName'));
    } catch (e) {
      print('Audio error: $e');
    }
  }

  Future<void> dispose() async {
    await _soundPlayer.dispose();
  }
}
