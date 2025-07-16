import 'dart:async';
import 'dart:math';
import 'dart:io';
import 'package:just_audio/just_audio.dart';
import 'package:musa_app/Utility/packages.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class AudioCommentPopup extends StatefulWidget {
  final Function(String) onRecordingComplete;
  final Function() recordUploadBtn;
  // final Function(String) onSpeechTextUpdate;

  const AudioCommentPopup({
    super.key,
    required this.onRecordingComplete,
    required this.recordUploadBtn,
    // this.onSpeechTextUpdate = _defaultSpeechTextUpdate,
  });

  @override
  _AudioCommentPopupState createState() => _AudioCommentPopupState();
}

class _AudioCommentPopupState extends State<AudioCommentPopup> {
  final record = AudioRecorder();
  bool _isRecording = false;
  bool _isPaused = false;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Timer? _timer;
  List<double> _waveformSamples = [];
  String? audioFilePath;

  @override
  void initState() {
    super.initState();

    _checkPermission();
    audioPlayer.playerStateStream.listen((playerState) {
      setState(() {
        _isPlaying = playerState.playing; // Update playing state
      });
    });
  }

  AudioPlayer audioPlayer = AudioPlayer();

  Future<void> _checkPermission() async {
    if (!await record.hasPermission()) {
      throw Exception('Microphone permission not granted');
    }
  }

  Future<void> startRecording() async {
    if (await record.hasPermission()) {
      final directory = await getApplicationDocumentsDirectory();
      // Use .m4a for iOS, .aac for Android
      String extension = Platform.isIOS ? 'm4a' : 'aac';
      final filePath =
          '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.$extension';

      final config = RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        sampleRate: 44100,
      );

      await record.start(config, path: filePath);
      setState(() {
        _isRecording = true;
        _isPaused = false;
        _duration = Duration.zero;
      });

      _startTimer();
    }
  }

  Future<void> stopRecording() async {
    try {
      final path = await record.stop();
      setState(() {
        _isRecording = false;
        _isPaused = false;
        _stopTimer();
      });
      if (path != null) {
        audioFilePath = path;
        widget.onRecordingComplete(path);
        return;
      } else {
        print('Error: Recording path is null');
      }
    } catch (e) {
      print('Error stopping recording: $e');
    }
    // If we reach here, recording failed
    setState(() {
      audioFilePath = null;
    });
  }

  Future<void> pauseRecording() async {
    if (_isRecording) {
      await record.pause();
      setState(() {
        _isPaused = true;
        _isRecording = false;
        _stopTimer();
      });
    }
  }

  Future<void> resumeRecording() async {
    if (_isPaused) {
      await record.resume();
      setState(() {
        _isPaused = false;
        _isRecording = true;
      });
      _startTimer();
    }
  }

  Future<void> cancelRecording() async {
    setState(() {
      _isRecording = false;
      _isPaused = false;
      _duration = Duration.zero;
      _stopTimer();
      _waveformSamples = [];
    });
  }

  Duration _elapsedDuration = Duration.zero;

  void _startTimer() {
    final startTime = DateTime.now();
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        _duration = _elapsedDuration + DateTime.now().difference(startTime);
        _waveformSamples.add(Random().nextDouble() * 100);
        if (_waveformSamples.length > 50) {
          _waveformSamples.removeAt(0);
        }
      });
    });
  }

  void _stopTimer() {
    _elapsedDuration = _duration;
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    record.dispose();
    _stopTimer();
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Spacer(),
            GestureDetector(
                onTap: () {
                  context.pop();
                  setState(() {
                    _isRecording ? stopRecording() : startRecording();
                    _isRecording || _isPaused ? cancelRecording() : null;
                  });
                },
                child: Icon(Icons.cancel)),
          ],
        ),
        SizedBox(height: 10),
        Text(
          _isRecording
              ? 'Recording...'
              : _isPaused
                  ? 'Paused'
                  : 'Tap to Record',
          style: AppTextStyle.normalTextStyle(
              color: AppColor.primaryTextColor, size: 14),
        ),
        SizedBox(height: 10),
        Text(
          _formatDuration(_duration),
          style: AppTextStyle.normalTextStyle(
              color: AppColor.primaryTextColor, size: 16),
        ),
        SizedBox(height: 30),
        Container(
          padding: EdgeInsets.only(left: 40, right: 40),
          width: double.infinity,
          child: CustomPaint(
            painter: WaveformPainter(samples: _waveformSamples),
          ),
        ),
        SizedBox(height: 60),
        audioFilePath != null
            ? Container()
            : Column(
                children: [
                  // IconButton(
                  //   onPressed: () {
                  //     setState(() {
                  //       _isRecording || _isPaused ? cancelRecording() : null;
                  //     });
                  //   },
                  //   icon: Icon(Icons.close, size: 30),
                  // ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: AppColor.greenDark,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              if (!_isRecording && !_isPaused) {
                                // Start recording
                                startRecording();
                              } else if (_isRecording) {
                                // Pause recording
                                pauseRecording();
                              } else if (_isPaused) {
                                // Resume recording
                                resumeRecording();
                              }
                              // _isRecording ? stopRecording() : startRecording();
                            });
                          },
                          icon: Icon(
                            !_isRecording && !_isPaused
                                ? Icons.record_voice_over
                                : _isRecording
                                    ? Icons.pause
                                    : Icons.record_voice_over,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                  (_isRecording || _isPaused)
                      ? Container(
                          padding:
                              EdgeInsets.only(top: 10, left: 40, right: 40),
                          height: 45,
                          child: MusaTextButton.borderTextButton(
                            onPressed: () async {
                              // Wait for recording to complete before proceeding
                              await stopRecording();
                              // Only call upload if we have a valid audio file
                              if (audioFilePath != null) {
                                widget.recordUploadBtn();
                              }
                            },
                            title: 'Stop Recording',
                            textcolor: AppColor.greenDark,
                            borderColor: AppColor.greenTextbd,
                          ),
                        )
                      : Container(),
                ],
              ),
        audioFilePath != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        cancelRecording();
                        audioFilePath = null;
                      });
                    },
                    icon: Icon(Icons.close, size: 20),
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      try {
                        if (_isPlaying) {
                          await audioPlayer.pause();
                        } else {
                          await audioPlayer.setFilePath(audioFilePath!);
                          await audioPlayer.play();
                        }
                      } catch (e) {
                        print('Error playing audio: $e');
                      }
                      // try {
                      //   await audioPlayer.setFilePath(audioFilePath!);
                      //   await audioPlayer.play();
                      //   if (audioPlayer.playing) {
                      //     await audioPlayer.stop();
                      //   }
                      // } catch (e) {
                      //   print('Error playing audio: $e');
                      // }
                    },
                    icon: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow_sharp,
                    ),
                    label: Text(
                      _isPlaying ? 'Pause' : 'Play',
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor:
                            const Color.fromARGB(255, 215, 207, 207),
                        child: IconButton(
                          onPressed: () async {
                            if (audioFilePath != null) {
                              // Ensure any ongoing recording is stopped
                              if (_isRecording || _isPaused) {
                                await record.stop();
                              }
                              widget.recordUploadBtn();
                            }
                          },
                          icon: Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : SizedBox(),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}

class WaveformPainter extends CustomPainter {
  final List<double> samples;

  WaveformPainter({required this.samples});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xffc62828) // 0xffc62828
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < samples.length; i++) {
      final x = i * (size.width / samples.length);
      final y = size.height / 2;
      final sampleHeight = samples[i] / 100 * size.height;
      canvas.drawLine(
          Offset(x, y - sampleHeight), Offset(x, y + sampleHeight), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
