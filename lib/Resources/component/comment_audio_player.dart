import 'package:audioplayers/audioplayers.dart';
import 'package:musa_app/Utility/packages.dart';

class CommentAudioPlayer extends StatefulWidget {
  final String fileLink;

  const CommentAudioPlayer({required this.fileLink, super.key});

  @override
  _CommentAudioPlayerState createState() => _CommentAudioPlayerState();
}

class _CommentAudioPlayerState extends State<CommentAudioPlayer> {
  late AudioPlayer _audioPlayer;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isPlaying = false;
  var oldFileLink;

  @override
  void didUpdateWidget(covariant CommentAudioPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.fileLink != widget.fileLink) {
      // If the fileLink changes, stop the old audio
      _audioPlayer.stop();
      _isPlaying = false; // Update the playing state
      oldFileLink = widget.fileLink;
    }
  }

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    performAction();
  }

  void performAction() {
    if (mounted) {
      _audioPlayer.onDurationChanged.listen((duration) {
        if (mounted) {
          setState(() {
            _duration = duration;
          });
        }
      });

      _audioPlayer.onPositionChanged.listen((position) {
        if (mounted) {
          setState(() {
            _position = position;
          });
        }
      });

      _audioPlayer.onPlayerStateChanged.listen((state) {
        if (mounted) {
          setState(() {
            _isPlaying = state == PlayerState.playing;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  bool isAudioPlay = false;

  void _playPauseAudio() async {
    setState(() {
      isAudioPlay = true;
    });
    if (oldFileLink != widget.fileLink) {
      await _audioPlayer.stop();
      await _audioPlayer.play(UrlSource(widget.fileLink));
      isAudioPlay = false;
      oldFileLink = widget.fileLink; // Update the reference
    } else {
      // Toggle play/pause for the same audio
      if (_isPlaying) {
        await _audioPlayer.pause();
        isAudioPlay = false;
      } else {
        await _audioPlayer.resume();
        isAudioPlay = false;
      }
    }
  }

  void _seekAudio(Duration position) async {
    await _audioPlayer.seek(position);
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Container(
  //         decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(5),
  //             border: Border.all(width: 1, color: AppColor.greyLine)),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Spacer(),
  //             Text(
  //               formatDuration(_position),
  //               style: TextStyle(fontSize: 12),
  //             ),
  //             SizedBox(
  //               height: 10,
  //               width: 150,
  //               child: Slider(
  //                 value: _position.inSeconds
  //                     .clamp(0, _duration.inSeconds)
  //                     .toDouble(),
  //                 min: 0,
  //                 max: _duration.inSeconds > 0
  //                     ? _duration.inSeconds.toDouble()
  //                     : 1,
  //                 onChanged: (value) {
  //                   _seekAudio(Duration(seconds: value.toInt()));
  //                 },
  //                 activeColor: isAudioPlay
  //                     ? AppColor.primaryColor
  //                     : AppColor.primaryColor,
  //                 inactiveColor: AppColor.primaryColor,
  //               ),
  //             ),
  //             Spacer(),
  //             IconButton(
  //               icon: Icon(
  //                 _isPlaying
  //                     ? Icons.pause_circle_filled
  //                     : Icons.play_circle_fill,
  //                 color: AppColor.primaryColor,
  //                 size: 25,
  //               ),
  //               onPressed: _playPauseAudio,
  //             ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Container(
  //     //padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  //     padding: const EdgeInsets.all(4),
  //     decoration: BoxDecoration(
  //       color: const Color(0xF9FCFC), // very light background like your image
  //       borderRadius: BorderRadius.circular(8),
  //       border: Border.all(width: 1, color: AppColor.primaryColor),
  //     ),
  //     child: Row(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         // Current time
  //         Text(
  //           formatDuration(_position),
  //           style: const TextStyle(
  //             fontSize: 12,
  //             color: Colors.black87,
  //           ),
  //         ),
  //         //const SizedBox(width: 8),

  //         // Progress bar
  //         Expanded(
  //           child: SliderTheme(
  //             data: SliderTheme.of(context).copyWith(
  //               thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
  //             ),
  //             child: Slider(
  //               value: _position.inSeconds
  //                   .clamp(0, _duration.inSeconds)
  //                   .toDouble(),
  //               min: 0,
  //               max: _duration.inSeconds > 0
  //                   ? _duration.inSeconds.toDouble()
  //                   : 1,
  //               onChanged: (value) {
  //                 _seekAudio(Duration(seconds: value.toInt()));
  //               },
  //               activeColor: AppColor.primaryColor,
  //               inactiveColor: AppColor.primaryColor.withOpacity(0.3),
  //             ),
  //           ),
  //         ),

  //         //const SizedBox(width: 8),

  //         // Play/Pause button
  //         IconButton(
  //           icon: Icon(
  //             _isPlaying ? Icons.pause : Icons.play_arrow,
  //             color: AppColor.primaryColor,
  //             size: 24,
  //           ),
  //           onPressed: _playPauseAudio,
  //           padding: EdgeInsets.zero, // remove default padding
  //           constraints: const BoxConstraints(), // shrink icon button box
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SizedBox(
            height: 50,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: AppColor.greenTextbg,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade100),
              ),
              child: Row(
                children: [
                  Text(
                    formatDuration(_position),
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Slider(
                      value: _position.inMilliseconds
                          .toDouble()
                          .clamp(0, _duration.inMilliseconds.toDouble()),
                      max: _duration.inMilliseconds.toDouble(),
                      onChanged: (value) {
                        _seekAudio(Duration(milliseconds: value.toInt()));
                      },
                      activeColor: AppColor.greenDark,
                      inactiveColor: AppColor.lightGreenNew,
                    ),
                  ),
                  IconButton(
                    icon: _isPlaying
                        ? SvgPicture.asset(Assets.pauseIcon)
                        : SvgPicture.asset(Assets.playIcon),
                    onPressed: _playPauseAudio,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}
