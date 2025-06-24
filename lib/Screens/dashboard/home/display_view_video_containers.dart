import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoDisplayView extends StatefulWidget {
  final String? url;

  const VideoDisplayView({super.key, this.url,});

  @override
  _VideoDisplayViewState createState() => _VideoDisplayViewState();
}

class _VideoDisplayViewState extends State<VideoDisplayView> {
  late VideoPlayerController _controller;
  late ValueNotifier<double> _progressNotifier;
  bool isFromDetailView = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url??""))
      ..initialize().then((_) {
        setState(() {});
        _controller.setVolume(0.0);
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
            color: Colors.grey,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              _controller.value.isInitialized
                  ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
                  : Center(child: CircularProgressIndicator(color: Colors.grey,strokeWidth: 5,)),

            ],
          ),
        ),
      ),
    );
  }
}





//
//
//
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
//
// class VideoDisplayView extends StatefulWidget {
//   final String url;
//
//   const VideoDisplayView({Key? key, required this.url}) : super(key: key);
//
//   @override
//   _VideoDisplayViewState createState() => _VideoDisplayViewState();
// }
//
// class _VideoDisplayViewState extends State<VideoDisplayView> {
//   late VideoPlayerController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializePlayer();
//   }
//
//   void _initializePlayer() {
//     _controller = VideoPlayerController.network(widget.url)
//       ..initialize().then((_) {
//         setState(() {});
//         _controller.play();
//       });
//   }
//
//   @override
//   void didUpdateWidget(VideoDisplayView oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.url != widget.url) {
//
//       _controller.dispose();
//       _initializePlayer();
//     }
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return _controller.value.isInitialized
//         ? AspectRatio(
//       aspectRatio: _controller.value.aspectRatio,
//       child: VideoPlayer(_controller),
//     )
//         : Center(child:
//
//         CircularProgressIndicator(color: Colors.grey,strokeWidth: 5,)
//     );
//   }
// }
//
