import 'dart:io';
import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';
import '../../../Utility/packages.dart';
import 'package:intl/intl.dart';

class AudioPlayerPopup extends StatefulWidget {
  final String filePath;
  final VoidCallback? onRemove;

  const AudioPlayerPopup({
    super.key,
    required this.filePath,
    this.onRemove,
  });

  @override
  State<AudioPlayerPopup> createState() => _AudioPlayerPopupState();
}

class _AudioPlayerPopupState extends State<AudioPlayerPopup> {
  late AudioPlayer _player;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  // Future<void> _initPlayer() async {
  //   _player = AudioPlayer();
  //   await _player.setFilePath(widget.filePath);
  //   _duration = _player.duration ?? Duration.zero;

  //   _player.positionStream.listen((p) {
  //     setState(() => _position = p);
  //   });

  //   _player.playerStateStream.listen((state) {
  //     setState(() => _isPlaying = state.playing);
  //   });
  //   _player.processingStateStream.listen((state) {
  //     if (state == ProcessingState.completed) {
  //       _player.pause();
  //       _player.seek(Duration.zero);
  //       setState(() {
  //         _isPlaying = false;
  //         _position = Duration.zero;
  //       });
  //     }
  //   });
  // }
  Future<void> _initPlayer() async {
    _player = AudioPlayer();
    // iOS: Set up audio session for playback
    if (Platform.isIOS) {
      final session = await AudioSession.instance;
      await session.configure(AudioSessionConfiguration.music());
    }
    if (widget.filePath.startsWith('http')) {
      await _player.setUrl(widget.filePath);
    } else {
      await _player.setFilePath(widget.filePath);
    }

    _duration = _player.duration ?? Duration.zero;

    // Listen to position updates
    _player.positionStream.listen((p) {
      setState(() => _position = p);
    });

    // Listen to player state changes
    _player.playerStateStream.listen((state) {
      final isPlaying = state.playing;
      final isCompleted = state.processingState == ProcessingState.completed;

      if (isCompleted) {
        _player.seek(Duration.zero);
        _player.pause();
        setState(() {
          _isPlaying = false;
          _position = Duration.zero;
        });
      } else {
        setState(() {
          _isPlaying = isPlaying;
        });
      }
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    return DateFormat.ms().format(DateTime(0).add(d));
  }

  @override
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
                border: Platform.isIOS
                    ? Border.all(color: Colors.green.shade400, width: 1.5)
                    : Border.all(color: Colors.green.shade100),
              ),
              child: Row(
                children: [
                  Text(
                    _formatDuration(_position),
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
                        _player.seek(Duration(milliseconds: value.toInt()));
                      },
                      activeColor: AppColor.greenDark,
                      inactiveColor: AppColor.lightGreenNew,
                    ),
                  ),
                  Platform.isIOS
                      ? Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Colors.green.shade400, width: 1.5),
                          ),
                          child: IconButton(
                            icon: _isPlaying
                                ? SvgPicture.asset(Assets.pauseIcon)
                                : SvgPicture.asset(Assets.playIcon),
                            onPressed: () async {
                              if (_isPlaying) {
                                await _player.pause();
                              } else {
                                await _player.play();
                              }
                            },
                          ),
                        )
                      : IconButton(
                          icon: _isPlaying
                              ? SvgPicture.asset(Assets.pauseIcon)
                              : SvgPicture.asset(Assets.playIcon),
                          onPressed: () async {
                            if (_isPlaying) {
                              await _player.pause();
                            } else {
                              await _player.play();
                            }
                          },
                        ),
                ],
              ),
            ),
          ),
        ),
        if (widget.onRemove != null) ...[
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: AppColor.greenTextbg,
              borderRadius: BorderRadius.circular(8),
              border: Platform.isIOS
                  ? Border.all(color: Colors.green.shade400, width: 1.5)
                  : Border.all(color: Colors.green.shade100),
            ),
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.black87),
              onPressed: widget.onRemove,
            ),
          ),
        ],
      ],
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
  //     decoration: BoxDecoration(
  //       color: AppColor.greenTextbg,
  //       borderRadius: BorderRadius.circular(8),
  //       border: Border.all(color: Colors.green.shade100),
  //     ),
  //     child: Row(
  //       children: [
  //         Text(
  //           _formatDuration(_position),
  //           style: const TextStyle(fontSize: 12),
  //         ),
  //         const SizedBox(width: 4),
  //         Expanded(
  //           child: Slider(
  //             value: _position.inMilliseconds
  //                 .toDouble()
  //                 .clamp(0, _duration.inMilliseconds.toDouble()),
  //             max: _duration.inMilliseconds.toDouble(),
  //             onChanged: (value) {
  //               _player.seek(Duration(milliseconds: value.toInt()));
  //             },
  //             activeColor: AppColor.greenDark,
  //             inactiveColor: AppColor.lightGreenNew,
  //           ),
  //         ),
  //         // IconButton(
  //         //   icon: Icon(
  //         //     _isPlaying ? Icons.pause : Icons.play_arrow,
  //         //     color: Colors.green.shade700,
  //         //   ),
  //         //   onPressed: () async {
  //         //     if (_isPlaying) {
  //         //       await _player.pause();
  //         //     } else {
  //         //       await _player.play();
  //         //     }
  //         //   },
  //         // ),
  //         IconButton(
  //           icon: _isPlaying
  //               ? SvgPicture.asset(Assets.settings)
  //               : SvgPicture.asset(Assets.playIcon),
  //           onPressed: () async {
  //             if (_isPlaying) {
  //               await _player.pause();
  //             } else {
  //               await _player.play();
  //             }
  //           },
  //         ),
  //         IconButton(
  //           icon: const Icon(Icons.close, color: Colors.black87),
  //           onPressed: widget.onRemove,
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
