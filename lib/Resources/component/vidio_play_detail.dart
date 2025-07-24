import 'package:flutter/material.dart';
import 'package:musa_app/Utility/packages.dart';
import 'package:video_player/video_player.dart';

class VideoPlayDetailView extends StatefulWidget {
  final String? url;

  const VideoPlayDetailView({
    super.key,
    this.url,
  });

  @override
  _VideoPlayDetailViewState createState() => _VideoPlayDetailViewState();
}

class _VideoPlayDetailViewState extends State<VideoPlayDetailView> {
  late VideoPlayerController _controller;
  late ValueNotifier<double> _progressNotifier;
  bool isFromDetailView = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url ?? ""))
      ..initialize().then((_) {
        setState(() {});
      });

    _progressNotifier = ValueNotifier(0.0);

    _controller.addListener(() {
      if (_controller.value.isInitialized) {
        final position = _controller.value.position.inSeconds;
        final duration = _controller.value.duration.inSeconds;
        if (position < duration) {
          _progressNotifier.value = position / duration;
        }
        _controller.play();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _progressNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              _controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : Center(child: CircularProgressIndicator()),
              Align(
                alignment: Alignment.center,
                child: FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      if (_controller.value.isPlaying) {
                        _controller.pause();
                      } else {
                        _controller.play();
                      }
                    });
                  },
                  backgroundColor: Colors.black45,
                  child: Icon(
                    _controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: Colors.white,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 42),
                  child: ValueListenableBuilder<double>(
                    valueListenable: _progressNotifier,
                    builder: (context, progress, child) {
                      return LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppColor.greenDark),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
//
// class VideoPlayDetailView extends StatefulWidget {
//   final String? url;
//
//   const VideoPlayDetailView({super.key, this.url});
//
//   @override
//   _VideoPlayDetailViewState createState() => _VideoPlayDetailViewState();
// }
//
// class _VideoPlayDetailViewState extends State<VideoPlayDetailView> {
//   late VideoPlayerController _controller;
//   late ValueNotifier<double> _progressNotifier;
//   bool isPlaying = false;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Validate the URL and initialize the controller
//     if (widget.url == null || widget.url!.isEmpty) {
//       debugPrint("Invalid video URL");
//       return;
//     }
//
//     _controller = VideoPlayerController.network(widget.url!)
//       ..initialize().then((_) {
//         if (mounted) {
//           setState(() {}); // Update UI when initialization is done
//         }
//         _controller.play();
//         isPlaying = true; // Start playing by default
//       });
//
//     // Initialize the progress notifier
//     _progressNotifier = ValueNotifier(0.0);
//
//     // Add listener to update progress
//     _controller.addListener(() {
//       if (_controller.value.isInitialized) {
//         final position = _controller.value.position.inMilliseconds.toDouble();
//         final duration = _controller.value.duration.inMilliseconds.toDouble();
//
//         if (duration > 0) {
//           _progressNotifier.value = position / duration;
//         }
//
//         // Update play/pause state
//         if (_controller.value.isPlaying != isPlaying) {
//           setState(() {
//             isPlaying = _controller.value.isPlaying;
//           });
//         }
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     _progressNotifier.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             color: Colors.grey,
//           ),
//           child: Stack(
//             alignment: Alignment.center,
//             children: [
//               // Video player widget
//               _controller.value.isInitialized
//                   ? AspectRatio(
//                       aspectRatio: _controller.value.aspectRatio,
//                       child: VideoPlayer(_controller),
//                     )
//                   : const CircularProgressIndicator(),
//
//               // Play/Pause button
//               Align(
//                 alignment: Alignment.center,
//                 child: FloatingActionButton(
//                   onPressed: () {
//                     if (_controller.value.isPlaying) {
//                       _controller.pause();
//                     } else {
//                       _controller.play();
//                     }
//                     setState(() {
//                       isPlaying = _controller.value.isPlaying;
//                     });
//                   },
//                   child: Icon(
//                     isPlaying ? Icons.pause : Icons.play_arrow,
//                     color: Colors.white,
//                   ),
//                   backgroundColor: Colors.black45,
//                 ),
//               ),
//
//               // Progress bar
//               Align(
//                 alignment: Alignment.bottomCenter,
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: ValueListenableBuilder<double>(
//                     valueListenable: _progressNotifier,
//                     builder: (context, progress, child) {
//                       return LinearProgressIndicator(
//                         value: progress,
//                         backgroundColor: Colors.grey,
//                         valueColor: const AlwaysStoppedAnimation<Color>(
//                           Colors.blue,
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
