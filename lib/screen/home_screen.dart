import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/audio_notifier.dart';
import '../utils/utils.dart';
import '../widget/audio_controller_widget.dart';
import '../widget/buffer_slider_controller_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioProvider = Provider.of<AudioNotifier>(context);
    const url =
        'https://github.com/dicodingacademy/assets/raw/main/flutter_intermediate_academy/bensound_ukulele.mp3';
    audioProvider.setAudioSourceFromUrl(url);

    final audioSource = audioProvider.audioSource;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text(
          "Audio Player Project",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Consumer<AudioNotifier>(
            builder: (context, provider, _) {
              final duration = provider.duration;
              final position = provider.position;
              return BufferSliderControllerWidget(
                maxValue: duration.inSeconds.toDouble(),
                currentValue: position.inSeconds.toDouble(),
                minText: durationToTimeString(position),
                maxText: durationToTimeString(duration),
                onChanged: (value) async {
                  final newPosition = Duration(seconds: value.toInt());
                  await audioProvider.audioPlayer.seek(newPosition);
                  await audioProvider.audioPlayer.resume();
                },
              );
            },
          ),
          Consumer<AudioNotifier>(
            builder: (context, provider, _) {
              final bool isPlay = provider.isPlay;

              return AudioControllerWidget(
                // Memulai pemutaran audio menggunakan URL yang diatur di AudioNotifier
                onPlayTapped: () {
                  if (audioSource != null) {
                    audioProvider.audioPlayer.play(audioSource);
                  }
                },
                onPauseTapped: () => audioProvider.audioPlayer.pause(),
                onStopTapped: () => audioProvider.audioPlayer.stop(),
                isPlay: isPlay,
              );
            },
          ),
        ],
      ),
    );
  }
}
