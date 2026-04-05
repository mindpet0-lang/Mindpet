import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioPlayer _musicPlayer = AudioPlayer();
  static final AudioPlayer _effectPlayer = AudioPlayer();

  static Future<void> playMusic() async {
    await _musicPlayer.setReleaseMode(ReleaseMode.loop);
    await _musicPlayer.setVolume(0.4);

    await _musicPlayer.play(AssetSource('sounds/fondo.mp3'));
  }

  static Future<void> stopMusic() async {
    await _musicPlayer.stop();
  }

  static Future<void> playClick() async {
    await _effectPlayer.play(AssetSource('sounds/click.wav'));
  }
}
