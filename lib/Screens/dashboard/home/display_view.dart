import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:math';

class ShuffleGrid extends StatefulWidget {
  const ShuffleGrid({super.key});

  @override
  _ShuffleGridState createState() => _ShuffleGridState();
}

class _ShuffleGridState extends State<ShuffleGrid> {
  // List of HTTP image URLs
  final List<String> images = [
    'https://picsum.photos/id/237/800/600'
        'https://picsum.photos/id/238/800/600'
        'https://picsum.photos/id/239/800/600'
        'https://picsum.photos/id/240/800/600'
        'https://picsum.photos/id/241/800/600'
        'https://picsum.photos/id/242/800/600'
        'https://picsum.photos/id/243/800/600'
        'https://picsum.photos/id/244/800/600'
        'https://picsum.photos/id/245/800/600'
        'https://picsum.photos/id/246/800/600'
        'https://picsum.photos/id/247/800/600'
        'https://picsum.photos/id/248/800/600'
        'https://picsum.photos/id/249/800/600'
        'https://picsum.photos/id/250/800/600'
        'https://picsum.photos/id/251/800/600'
  ];

  // List of HTTP video URLs (replace with actual links)
  final List<String> videos = [
    "'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4",
    "'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_2mb.mp4",
    "'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_5mb.mp4"
  ];

  List<String> shuffledImages = [];
  List<String> shuffledVideos = [];
  int imageIndex = 0;
  int videoIndex = 0;

  @override
  void initState() {
    super.initState();
    // Shuffle images and videos at the start
    shuffledImages = List.from(images)..shuffle(Random());
    shuffledVideos = List.from(videos)..shuffle(Random());
  }

  // Shuffle content once all items have been displayed
  void shuffleContent() {
    setState(() {
      shuffledImages = List.from(images)..shuffle(Random());
      shuffledVideos = List.from(videos)..shuffle(Random());
      imageIndex = 0;
      videoIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Image & Video Shuffle')),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Number of columns in the grid
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: 9, // Total grid items (2 videos + 7 images)
        itemBuilder: (context, index) {
          // First 2 slots for videos
          if (index < 2) {
            return VideoItem(
              videoUrl: shuffledVideos[videoIndex],
              onComplete: () {
                setState(() {
                  videoIndex = (videoIndex + 1) % shuffledVideos.length;
                  if (videoIndex == 0) shuffleContent();
                });
              },
            );
          } else {
            // Remaining slots for images
            return ImageItem(
              imageUrl: shuffledImages[imageIndex],
              onComplete: () {
                setState(() {
                  imageIndex = (imageIndex + 1) % shuffledImages.length;
                  if (imageIndex == 0) shuffleContent();
                });
              },
            );
          }
        },
      ),
    );
  }
}

// Image Item Widget (Displays HTTP Image)
class ImageItem extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onComplete;

  const ImageItem({
    super.key,
    required this.imageUrl,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onComplete, // Clicking an image moves to the next
      child: Image.network(imageUrl, fit: BoxFit.cover),
    );
  }
}

// Video Item Widget (Plays HTTP Video for 5 Seconds)
class VideoItem extends StatefulWidget {
  final String videoUrl;
  final VoidCallback onComplete;

  const VideoItem({
    super.key,
    required this.videoUrl,
    required this.onComplete,
  });

  @override
  _VideoItemState createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          _controller.play();
          _controller.setVolume(0); // Mute the video
        });
      });

    // Play video for 5 seconds, then move to the next
    Future.delayed(Duration(seconds: 5), () {
      widget.onComplete();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: _controller.value.isInitialized
          ? VideoPlayer(_controller)
          : Center(child: CircularProgressIndicator()),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
