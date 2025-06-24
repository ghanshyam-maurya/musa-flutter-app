import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:musa_app/Cubit/dashboard/CreateMusa/create_musa_cubit.dart';

class AudioPreviewScreen extends StatefulWidget {
  final CreateMusaCubit cubit;

  const AudioPreviewScreen({super.key, required this.cubit});

  @override
  State<AudioPreviewScreen> createState() => _AudioPreviewScreenState();
}

class _AudioPreviewScreenState extends State<AudioPreviewScreen> {
  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  int? currentPlayingIndex;

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  // Play or Pause Audio
  void playPauseAudio(int index, String path) async {
    if (currentPlayingIndex == index && isPlaying) {
      await audioPlayer.pause();
      setState(() {
        isPlaying = false;
      });
    } else {
      await audioPlayer.stop();
      await audioPlayer.play(DeviceFileSource(path));
      setState(() {
        isPlaying = true;
        currentPlayingIndex = index;
      });

      // Listen for when audio finishes playing
      audioPlayer.onPlayerComplete.listen((_) {
        setState(() {
          isPlaying = false;
          currentPlayingIndex = null;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Audio Preview"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true); // Pass a result back to update UI
          },
        ),
      ),
      body: ValueListenableBuilder<List<String>>(
        valueListenable: widget.cubit.selectedAudio,
        builder: (context, audioList, child) {
          if (audioList.isEmpty) {
            return const Center(child: Text("No audio files available"));
          }

          return ListView.builder(
            itemCount: audioList.length,
            itemBuilder: (context, index) {
              String audioPath = audioList[index];

              return ListTile(
                leading: const Icon(Icons.music_note, color: Colors.blue),
                title: Text(
                  "Audio ${index + 1}",
                  style: const TextStyle(fontSize: 16),
                ),
                subtitle: Text(audioPath.split('/').last), // Show file name
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        isPlaying && currentPlayingIndex == index
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_fill,
                        color: Colors.blue,
                        size: 30,
                      ),
                      onPressed: () => playPauseAudio(index, audioPath),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        widget.cubit.removeSelectedAudio(index);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
