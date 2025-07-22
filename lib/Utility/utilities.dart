import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:get_video_thumbnail/get_video_thumbnail.dart';
// import 'package:get_video_thumbnail/index.dart';
import 'package:musa_app/Utility/shared_preferences.dart';
import 'package:photo_manager/photo_manager.dart';
// import 'package:video_thumbnail/video_thumbnail.dart';
import '../Repository/AppResponse/Responses/logged_in_response.dart';
import '../Repository/AppResponse/social_musa_list_response.dart';
import '../Screens/dashboard/home/display_view_grid.dart';

class Utilities {
  static Future<Uint8List?> loadPhotos() async {
    final permitted = await PhotoManager.requestPermissionExtend();
    if (permitted.isAuth) {
      List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
        onlyAll: true,
      );
      if (albums.isNotEmpty) {
        List<AssetEntity> allAssets =
            await albums[0].getAssetListPaged(page: 0, size: 1000);
        // Fetch and cache thumbnail data
        for (AssetEntity asset in allAssets) {
          final Uint8List? thumbData = await asset.thumbnailDataWithOption(
            ThumbnailOption(size: ThumbnailSize(200, 200), quality: 80),
          );
          return thumbData;
        }
      }
    } else {
      PhotoManager.openSetting();
    }
    return null;
  }

  // static Future<XFile?> generateVideoThumbnailFromUrl(
  //     {required String videoUrl, imageWidth}) async {
  //   final XFile thumbnailFile = await VideoThumbnail.thumbnailFile(
  //     video: videoUrl,
  //     thumbnailPath: (await getTemporaryDirectory()).path,
  //     imageFormat: ImageFormat.JPEG,
  //     maxWidth: 100,
  //     quality: 40,
  //   );
  //   return thumbnailFile;
  // }

  static String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text
        .split(' ')
        .map((word) =>
            word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '')
        .join(' ');
  }

  //Function to check passed url is video or not
  static bool isVideoUrl(String url) {
    final videoExtensions =
        RegExp(r'\.(mp4|mkv|avi|mov|wmv|flv|webm)$', caseSensitive: false);
    return videoExtensions.hasMatch(url);
  }

  static bool isAudioUrl(String url) {
    final audioExtensions =
        RegExp(r'\.(mp3|wav|aac|ogg|flac|m4a)$', caseSensitive: false);
    return audioExtensions.hasMatch(url);
  }

  static setUserData({required String userData}) {
    Prefs.setString(PrefKeys.userData, userData);
  }

  static User getUserData() {
    final userData = Prefs.getString(PrefKeys.userData);
    if (userData == null) {
      return User.fromJson({});
    }
    Map<String, dynamic> json = jsonDecode(userData);
    return User.fromJson(json);
  }

  static Future<void> navigateToLandscapeScreen(
    BuildContext context, {
    required MusaData? displayViewItems,
    required Function() commentBtn,
  }) async {
    print(displayViewItems);
    print("DISPLAY VIEW ITEM");

    // Change device orientation
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DisplayModeLandscape(
                displayViewItems: displayViewItems,
                commentBtn: commentBtn,
              )),
    );

    // await context.push(RouteTo.displayViewGrid, extra: displayViewItems);
  }

  static Widget getAudioPlayerView(String? url,
      {double? width, double? height, double? radius}) {
    if (url == null || url.isEmpty || url == "null") {
      return _buildErrorWidget();
    }

    return AudioPlayerWidget(
        audioUrl: url, width: width, height: height, radius: radius);
  }

  static Widget _buildErrorWidget() {
    return Container(
      width: 120,
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(Icons.error, color: Colors.red),
    );
  }

  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds.remainder(60))}";
  }
}

class AudioPlayerWidget extends StatefulWidget {
  final String audioUrl;
  final double? width;
  final double? height;
  final double? radius;

  const AudioPlayerWidget({
    super.key,
    required this.audioUrl,
    this.width,
    this.height,
    this.radius,
  });

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget>
    with SingleTickerProviderStateMixin {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isLoading = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();

    _audioPlayer.onDurationChanged.listen((d) {
      setState(() => _duration = d);
    });

    _audioPlayer.onPositionChanged.listen((p) {
      setState(() => _position = p);
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      setState(() {
        _isPlaying = false;
        _position = Duration.zero;
      });
    });
  }

  void _togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
      setState(() => _isPlaying = false);
    } else {
      setState(() => _isLoading = true);
      await _audioPlayer.setSourceUrl(widget.audioUrl);
      await _audioPlayer.resume();
      setState(() {
        _isPlaying = true;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? 250,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(widget.radius ?? 15),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              4,
              (index) => AnimatedContainer(
                duration: Duration(milliseconds: 500),
                height: _isPlaying ? (10.0 + index * 5) : 5,
                width: 6,
                margin: EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: LinearProgressIndicator(
              minHeight: 20,
              value: _duration.inSeconds > 0
                  ? _position.inSeconds / _duration.inSeconds
                  : 0,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ),
          SizedBox(height: 20),
          Text(
            "${_formatDuration(_position)} / ${_formatDuration(_duration)}",
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
          SizedBox(height: 10),
          _isLoading
              ? const CircularProgressIndicator() // Show loader when preloading
              : IconButton(
                  icon: Icon(
                    _isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_fill,
                    color: Colors.blue,
                    size: 40,
                  ),
                  onPressed: _togglePlayPause,
                ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds.remainder(60))}";
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}

Future<String?> generateThumbnail(String videoUrl) async {
  return compute(generateThumbnailIsolate, videoUrl);
}

Future<String?>? generateThumbnailIsolate(String videoUrl) {
  try {
    // return VideoThumbnail.thumbnailFile(
    //   video: videoUrl,
    //   thumbnailPath: (Directory.systemTemp).path,
    //   imageFormat: ImageFormat.PNG,
    //   maxHeight: 200,
    //   quality: 75,
    // );
    return null;
  } catch (e) {
    print("Error generating thumbnail: $e");
    return null;
  }
}
