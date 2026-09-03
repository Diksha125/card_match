import 'package:audioplayers/audioplayers.dart';

class AudioService {
  final AudioPlayer _soundPlayer;
  final AudioPlayer _musicPlayer;

  bool _soundEnabled;
  bool _musicEnabled;

  AudioService({
    AudioPlayer? soundPlayer,
    AudioPlayer? musicPlayer,
    bool soundEnabled = true,
    bool musicEnabled = true,
  }) : _soundPlayer = soundPlayer ?? AudioPlayer(),
       _musicPlayer = musicPlayer ?? AudioPlayer(),
       _soundEnabled = soundEnabled,
       _musicEnabled = musicEnabled;

  void setSoundEnabled(bool enabled) {
    _soundEnabled = enabled;
  }

  void setMusicEnabled(bool enabled) {
    _musicEnabled = enabled;

    if (!enabled) {
      stopMusic();
    }
  }

  Future<void> playCardFlip() async {
    if (!_soundEnabled) return;

    await _playSound('card_flip.mp3');
  }

  Future<void> playMatch() async {
    if (!_soundEnabled) return;

    await _playSound('match.mp3');
  }

  Future<void> playMismatch() async {
    if (!_soundEnabled) return;

    await _playSound('mismatch.mp3');
  }

  Future<void> playVictory() async {
    if (!_soundEnabled) return;

    await _playSound('victory.mp3');
  }

  Future<void> playButton() async {
    if (!_soundEnabled) return;

    await _playSound('button.mp3');
  }

  Future<void> _playSound(String fileName) async {
    try {
      await _soundPlayer.play(AssetSource('audio/$fileName'));
    } catch (e) {
      print('Audio error: $e');
    }
  }

  Future<void> startMusic() async {
    if (!_musicEnabled) return;

    try {
      await _musicPlayer.setReleaseMode(ReleaseMode.loop);

      await _musicPlayer.setVolume(0.3);

      await _musicPlayer.play(AssetSource('audio/background_music.mp3'));
    } catch (e) {
      print('Music error: $e');
    }
  }

  Future<void> stopMusic() async {
    try {
      await _musicPlayer.stop();
    } catch (e) {
      print('Music stop error: $e');
    }
  }

  Future<void> pauseMusic() async {
    try {
      await _musicPlayer.pause();
    } catch (e) {
      print('Music pause error: $e');
    }
  }

  Future<void> resumeMusic() async {
    if (!_musicEnabled) return;

    try {
      await _musicPlayer.resume();
    } catch (e) {
      print('Music resume error: $e');
    }
  }

  Future<void> dispose() async {
    await _soundPlayer.dispose();
    await _musicPlayer.dispose();
  }
}
