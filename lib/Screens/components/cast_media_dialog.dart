import 'package:flutter/material.dart';
//import 'package:flutter_cast_video/flutter_cast_video.dart';

class CastMediaDialog extends StatefulWidget {
  final String url;
  final String title;

  const CastMediaDialog({
    Key? key,
    required this.url,
    required this.title,
  }) : super(key: key);

  @override
  State<CastMediaDialog> createState() => _CastMediaDialogState();
}

class _CastMediaDialogState extends State<CastMediaDialog> {
  // ChromeCastController? _controller;

  // void _loadMedia() {
  //   if (_controller == null) return;
  //   _controller!.loadMedia(
  //     widget.url,
  //     title: widget.title,
  //   );
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return AlertDialog(
  //     title: Text('Cast "${widget.url}"'),
  //     content: ChromeCastButton(
  //       onButtonCreated: (controller) {
  //         setState(() => _controller = controller);
  //         _controller?.addSessionListener();
  //       },
  //       onSessionStarted: () {
  //         _controller?.loadMedia(
  //             'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4');
  //       },
  //     ),
  //     actions: [
  //       TextButton(
  //         onPressed: () => Navigator.pop(context),
  //         child: const Text('Close'),
  //       ),
  //     ],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Cast "${widget.title}"'),
      content: Text('Media URL: ${widget.url}'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
