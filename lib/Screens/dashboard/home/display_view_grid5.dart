import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../Cubit/display_mode_cubit/display_mode_cubit.dart';
import '../../../Repository/AppResponse/social_musa_list_response.dart';

class DisplayModeLandscape extends StatefulWidget {
  final MusaData? displayViewItems;

  const DisplayModeLandscape({
    super.key,
    required this.displayViewItems,
  });

  @override
  State<DisplayModeLandscape> createState() => _DisplayModeLandscapeState();
}

class _DisplayModeLandscapeState extends State<DisplayModeLandscape> {
  final DisplayModeCubit displayModeCubit = DisplayModeCubit();
  List<String> shuffledImages = [];
  List<String> shuffledVideos = [];
  int imageIndex = 0;
  int videoIndex = 0;
  late Timer _videoTimer;

  final List<StaggeredGridItem> gridItems = [
    StaggeredGridItem(heightFactor: 0.5),
    StaggeredGridItem(heightFactor: 0.3),
    StaggeredGridItem(heightFactor: 0.4),
    StaggeredGridItem(heightFactor: 0.3),
    StaggeredGridItem(heightFactor: 0.5),
    StaggeredGridItem(heightFactor: 0.4),
    StaggeredGridItem(heightFactor: 0.3),
  ];

  @override
  void initState() {
    super.initState();
    displayModeCubit.separateItems(widget.displayViewItems?.file);

    shuffledImages.addAll(displayModeCubit.imageList);
    shuffledVideos.addAll(displayModeCubit.videoList);

    shuffledImages.shuffle(Random());
    shuffledVideos.shuffle(Random());
    _startVideoLoop();
  }

  void _startVideoLoop() {
    _videoTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        videoIndex = (videoIndex + 1) % shuffledVideos.length;
        if (videoIndex == 0) {
          shuffledVideos.shuffle(Random());
        }
      });
    });
  }

  @override
  void dispose() {
    _videoTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MasonryGridView.builder(
          gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemCount: gridItems.length,
          itemBuilder: (context, index) {
            if (index == 1 || index == 5) {
              return VideoPlayerWidget(
                  videoUrl: shuffledVideos.isNotEmpty
                      ? shuffledVideos[videoIndex]
                      : "");
            }
            if (shuffledImages.isNotEmpty) {
              String imageUrl = shuffledImages[imageIndex];
              imageIndex = (imageIndex + 1) % shuffledImages.length;
              if (imageIndex == 0) {
                shuffledImages.shuffle(Random());
              }
              return Image.network(imageUrl, fit: BoxFit.cover);
            }
            return Container();
          },
        ),
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerWidget({super.key, required this.videoUrl});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.setLooping(true);
        _controller.setVolume(0);
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : Container(color: Colors.black);
  }
}

class StaggeredGridItem {
  final double heightFactor;
  StaggeredGridItem({required this.heightFactor});
}
