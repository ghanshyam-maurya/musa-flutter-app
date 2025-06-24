import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'display_view_image_detail.dart';
import 'display_view_video_containers.dart';

// For Index 1
class RandomVideoDisplayOne extends StatefulWidget {
  final List<String> videoList;
  final musaDetails;
  const RandomVideoDisplayOne(
      {super.key, required this.videoList, required this.musaDetails});

  @override
  _RandomVideoDisplayOneState createState() => _RandomVideoDisplayOneState();
}

class _RandomVideoDisplayOneState extends State<RandomVideoDisplayOne> {
  late int currentVideoIndex;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initializeRandomVideo();
  }

  void _initializeRandomVideo() {
    currentVideoIndex = 0;

    _timer = Timer.periodic(const Duration(seconds: 50), (timer) {
      _setRandomVideoIndex();
    });
  }

  void _setRandomVideoIndex() {
    final random = Random();

    setState(() {
      int newIndex;
      do {
        newIndex = random.nextInt(widget.videoList.length);
      } while (newIndex == currentVideoIndex);

      currentVideoIndex = newIndex;
      print("Switching to video index: $currentVideoIndex");
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        DisplayViewImageDetail.showDetailDialog(
          context,
          musaData: widget.musaDetails,
          musaImage: widget.videoList[currentVideoIndex],
        );
      },
      child: VideoDisplayView(
        key: ValueKey(currentVideoIndex),
        url: widget.videoList[currentVideoIndex],
      ),
    );
  }
}

// For Index 5
class RandomVideoDisplayTwo extends StatefulWidget {
  final List<String> videoList;
  final musaDetails;
  const RandomVideoDisplayTwo({
    super.key,
    required this.videoList,
    required this.musaDetails,
  });

  @override
  _RandomVideoDisplayTwoState createState() => _RandomVideoDisplayTwoState();
}

class _RandomVideoDisplayTwoState extends State<RandomVideoDisplayTwo> {
  late int currentVideoIndex;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initializeRandomVideo();
  }

  void _initializeRandomVideo() {
    currentVideoIndex = 1;

    _timer = Timer.periodic(const Duration(seconds: 40), (timer) {
      _setRandomVideoIndex();
    });
  }

  void _setRandomVideoIndex() {
    final random = Random();

    setState(() {
      int newIndex;
      do {
        newIndex = random.nextInt(widget.videoList.length);
      } while (newIndex == currentVideoIndex);

      currentVideoIndex = newIndex;
      print("Switching to video index: $currentVideoIndex");
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        DisplayViewImageDetail.showDetailDialog(
          context,
          musaData: widget.musaDetails,
          musaImage: widget.videoList[currentVideoIndex],
        );
      },
      child: VideoDisplayView(
        key: ValueKey(currentVideoIndex),
        url: widget.videoList[currentVideoIndex],
      ),
    );
  }
}
