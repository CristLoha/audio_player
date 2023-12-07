import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioNotifier extends ChangeNotifier {
  late final AudioPlayer _audioPlayer;
  bool _isPlay = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  Source? _audioSource;

  AudioNotifier() {
    _audioPlayer = AudioPlayer();
    _setupAudioListeners();
  }

  AudioPlayer get audioPlayer => _audioPlayer;

  Source? get audioSource => _audioSource;

  void setAudioSource(Source source) {
    _audioSource = source;
    _audioPlayer.setSource(source);
  }

  void setAudioSourceFromUrl(String url) {
    final audioSource = UrlSource(url);
    audioPlayer.setSource(audioSource);
    setAudioSource(audioSource);
  }

  void setAudioFromAsset(String path) {
    final audioSoure = AssetSource(path);
    audioPlayer.setSource(audioSoure);
    setAudioSource(audioSoure);
  }

  void _setupAudioListeners() {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      _isPlay = state == PlayerState.playing;
      if (state == PlayerState.stopped) {
        _position = Duration.zero;
      }
      notifyListeners();
    });

    _audioPlayer.onDurationChanged.listen((duration) {
      _duration = duration;
      notifyListeners();
    });

    _audioPlayer.onPositionChanged.listen((position) {
      _position = position;
      notifyListeners();
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      _position = Duration.zero;
      _isPlay = false;
      notifyListeners();
    });
  }

  bool get isPlay => _isPlay;

  Duration get duration => _duration;

  Duration get position => _position;
}
