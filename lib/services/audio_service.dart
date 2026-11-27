
import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioPlayer backgroundPlayer = AudioPlayer();
  static final AudioPlayer effectPlayer = AudioPlayer();

  static Future<void> playBackground() async {
    await backgroundPlayer.stop();
    await backgroundPlayer.setReleaseMode(ReleaseMode.loop);
    await backgroundPlayer.setVolume(0.6);
    await backgroundPlayer.play(
      AssetSource('sounds/background.mp3'),
    );
  }

  static Future<void> playCorrect() async {
    await effectPlayer.setAudioContext(
      AudioContextConfig(
        focus: AudioContextConfigFocus.mixWithOthers,
      ).build(),
    );
    await effectPlayer.setVolume(0.7);
    await effectPlayer.play(
      AssetSource('sounds/correct.mp3'),
    );
  }

  static Future<void> playWrong() async {
    await effectPlayer.setAudioContext(
      AudioContextConfig(
        focus: AudioContextConfigFocus.mixWithOthers,
      ).build(),
    );
    await effectPlayer.setVolume(0.7);
    await effectPlayer.play(
      AssetSource('sounds/wrong.mp3'),
    );
  }

  static Future<void> stopBackground() async {
    await backgroundPlayer.stop();
  }
}
