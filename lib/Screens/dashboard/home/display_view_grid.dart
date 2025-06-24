import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:musa_app/Resources/colors.dart';
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
  List<String> shuffledImages = [];
  List<String> shuffledVideos = [];
  Timer? _shuffleTimer;
  Timer? _videoTimer;

  int videoIndex1 = 0; // First video container
  int videoIndex2 = 1; // Second video container

  final DisplayModeCubit displayModeCubit = DisplayModeCubit();

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
    displayModeCubit.videoList.length > 1 ? videoIndex2 = 1 : videoIndex2 = 0;

    shuffledImages.addAll(displayModeCubit.imageList);
    shuffledVideos.addAll(displayModeCubit.videoList);

    shuffledImages.shuffle(Random());
    shuffledVideos.shuffle(Random());

    _startVideoLoop();
    _startShuffleTimer();
  }

  void _startShuffleTimer() {
    _shuffleTimer = Timer.periodic(const Duration(seconds: 15), (timer) {
      setState(() {
        shuffledImages.shuffle(Random());
        shuffledVideos.shuffle(Random());
      });
    });
  }

  void _startVideoLoop() {
    if (shuffledVideos.length > 1) {
      _videoTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
        setState(() {
          // Ensure both videos are different
          videoIndex1 = Random().nextInt(shuffledVideos.length);
          do {
            videoIndex2 = Random().nextInt(shuffledVideos.length);
          } while (videoIndex2 == videoIndex1);
        });
      });
    }
  }

  @override
  void dispose() {
    _videoTimer?.cancel();
    _shuffleTimer?.cancel();
    super.dispose();
  }

  Future<void> _exitScreen() async {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgGrey,
      body: Stack(
        children: [
          shuffledImages.isNotEmpty || shuffledVideos.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: MasonryGridView.builder(
                    gridDelegate:
                        const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemCount: gridItems.length,
                    itemBuilder: (context, index) {
                      if (index == 1 && shuffledVideos.isNotEmpty) {
                        return _videoContainer(
                            videoIndex1, gridItems[index].heightFactor);
                      }
                      if (index == 5 && shuffledVideos.isNotEmpty) {
                        return _videoContainer(
                            videoIndex2, gridItems[index].heightFactor);
                      }
                      if (shuffledImages.isNotEmpty) {
                        return _imageContainer(
                            shuffledImages[index % shuffledImages.length],
                            gridItems[index].heightFactor);
                      }
                      return _placeholderContainer(
                          gridItems[index].heightFactor);
                    },
                  ),
                )
              : const SizedBox(),

          // **Exit Button**
          Positioned(
            top: 20,
            right: 20,
            child: GestureDetector(
              onTap: _exitScreen,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _videoContainer(int videoIndex, double heightFactor) {
    return Container(
      height: MediaQuery.of(context).size.height * heightFactor,
      decoration: BoxDecoration(
        color: AppColor.grey,
        border: Border.all(width: 5, color: Colors.black),
      ),
      child: VideoPlayerWidget(
        key: ValueKey(shuffledVideos[videoIndex]), // Unique key for each video
        videoUrl: shuffledVideos[videoIndex],
      ),
    );
  }

  Widget _imageContainer(String imageUrl, double heightFactor) {
    return Container(
      height: MediaQuery.of(context).size.height * heightFactor,
      decoration: BoxDecoration(
        border: Border.all(width: 5, color: Colors.black),
      ),
      child: ClipRRect(
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            return const Center(
                child: CircularProgressIndicator(color: Colors.white));
          },
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child:
                  Icon(Icons.image_not_supported, color: Colors.grey, size: 50),
            );
          },
        ),
      ),
    );
  }

  Widget _placeholderContainer(double heightFactor) {
    return Container(
      height: MediaQuery.of(context).size.height * heightFactor,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        border: Border.all(width: 5, color: Colors.black),
      ),
    );
  }
}

class StaggeredGridItem {
  final double heightFactor;
  StaggeredGridItem({required this.heightFactor});
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
    _initializeVideo();
  }

  void _initializeVideo() {
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {});
          _controller.setLooping(true);
          _controller.setVolume(0);
          _controller.play();
        }
      }).catchError((error) {
        print("Error initializing video: $error");
      });
  }

  @override
  void didUpdateWidget(VideoPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      _controller.dispose();
      _initializeVideo();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _controller.value.size.width,
              height: _controller.value.size.height,
              child: VideoPlayer(_controller),
            ),
          )
        : const Center(child: CircularProgressIndicator());
  }
}
